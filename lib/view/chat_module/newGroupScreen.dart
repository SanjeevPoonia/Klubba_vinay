import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';
import '../app_theme.dart';
import 'createNewGroupScreen.dart';

class newGroupScreen extends StatefulWidget {
  _newGroupScreen createState() => _newGroupScreen();
}

class _newGroupScreen extends State<newGroupScreen> {
  bool isLoading = false;
  List<dynamic> memberList = [];
  var searchController = TextEditingController();
  List<dynamic> addedMemberList = [];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      floatingActionButton: Container(
        width: 50,
        height: 50,
        child: FloatingActionButton(
            elevation: 4.0,
            child: Icon(Icons.arrow_forward_rounded),
            backgroundColor:
                addedMemberList.length == 0 ? Colors.grey : AppTheme.themeColor,
            onPressed: () {
              if (addedMemberList.length != 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            createNewGroupScreen(addedMemberList)));
              }
            }),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppTheme.themeColor,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'New ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Group',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  border: Border.all(width: 1, color: const Color(0xFFCDCDCD))),
              child: TextFormField(
                controller: searchController,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                  if (searchController.text.toString().length > 1) {
                    searchMembers();
                  }
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          if (searchController.text.toString().length > 1) {
                            searchMembers();
                          }
                        },
                        child: Icon(Icons.search, color: AppTheme.blueColor)),
                    contentPadding: EdgeInsets.only(left: 8, top: 11),
                    hintText: "Search people",
                    hintStyle: TextStyle(
                        color: Color(0xFF919191),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    border: InputBorder.none),
              ),
            ),
            addedMemberList.length == 0
                ? Container()
                : SizedBox(
                    height: 15,
                  ),
            addedMemberList.length == 0
                ? Container()
                : Container(
                    height: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: addedMemberList.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int pos) {
                          return Row(
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      addedMemberList[pos]["profile_image"] !=
                                              ""
                                          ? CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  AppConstant.profileImageURL +
                                                      addedMemberList[pos]
                                                          ["profile_image"]),
                                            )
                                          : CircleAvatar(
                                              radius: 25,
                                              backgroundImage: AssetImage(
                                                  "assets/dummy_profile.png"),
                                            ),
                                      Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              addedMemberList.removeAt(pos);
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF708096),
                                              ),
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(addedMemberList[pos]["name"],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Poppins",
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ),
                              SizedBox(width: 5),
                            ],
                          );
                        }),
                  ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: isLoading
                    ? Center(
                        child: Loader(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: memberList.length,
                        itemBuilder: (BuildContext context, int pos) {
                          return InkWell(
                            onTap: () {
                              addedMemberList.add(memberList[pos]);
                              setState(() {});
                            },
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 6),
                                      child: Row(
                                        children: [
                                          // assets/dummy_profile.png

                                          memberList[pos]["profile_image"] != ""
                                              ? CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(
                                                      AppConstant
                                                              .profileImageURL +
                                                          memberList[pos][
                                                              "profile_image"]),
                                                )
                                              : CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: AssetImage(
                                                      "assets/dummy_profile.png"),
                                                ),
                                          SizedBox(width: 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(memberList[pos]["name"],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "Poppins",
                                                      color: AppTheme.blueColor,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  color: AppTheme.greyColor,
                                  height: 07,
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          );
                        }))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  searchMembers() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "searchNewMember",
      "data": {
        "user_id": id,
        "name": searchController.text.toString(),
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'searchNewMember', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    isLoading = false;
    setState(() {});
    memberList = responseJSON["decodedData"]["result"];
    setState(() {});
  }
}
