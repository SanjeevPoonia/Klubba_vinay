import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/community/user_chat_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';
import '../app_theme.dart';
import 'createNewGroupScreen.dart';

class AddNewMemberScreen extends StatefulWidget {
  _newGroupScreen createState() => _newGroupScreen();
}

class _newGroupScreen extends State<AddNewMemberScreen> {
  bool isLoading = false;
  List<dynamic> memberList = [];
  var searchController = TextEditingController();
  int selectedIndex = 9999;
  String roomID = "";
  String receiverID = "";
  String receiverName = "";
  String receiverProfileImage = "";

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
                selectedIndex == 9999 ? Colors.grey : AppTheme.themeColor,
            onPressed: () {
              if (selectedIndex != 9999) {
               createRoom();
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
                text: 'Chat',
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
                    hintText: "Search members for chat",
                    hintStyle: TextStyle(
                        color: Color(0xFF919191),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    border: InputBorder.none),
              ),
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
                              selectedIndex = pos;
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
                                              ? Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          NetworkImage(AppConstant
                                                                  .profileImageURL +
                                                              memberList[pos][
                                                                  "profile_image"]),
                                                    ),
                                                    selectedIndex == pos
                                                        ? Container(
                                                            width: 50,
                                                            height: 50,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 14),
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                )
                                              : Stack(
                                                children: [
                                                  CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage: AssetImage(
                                                          "assets/dummy_profile.png"),
                                                    ),

                                                  selectedIndex == pos
                                                      ? Container(
                                                    width: 50,
                                                    height: 50,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomRight,
                                                      child: Icon(
                                                          Icons
                                                              .check_circle,
                                                          color: Colors
                                                              .green,
                                                          size: 14),
                                                    ),
                                                  )
                                                      : Container()
                                                ],
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

  createRoom() async {
    APIDialog.showAlertDialog(context, "Starting chat...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "createRoomForChat",
      "data": {
        "senderId": id,
        "receiverId": memberList[selectedIndex]["_id"],
        "isGroupChat": 0,
        "chatName": "sender",
        "latestMessage": "Start Chatting",
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
        'createRoomForChat', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    Navigator.pop(context);

    if(responseJSON["decodedData"]["status"]=="success")
      {
        Toast.show(responseJSON['decodedData']['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);

        roomID=responseJSON['decodedData']["result"][0]['_id'];



         Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatScreenUser(roomID,memberList[selectedIndex]["_id"],memberList[selectedIndex]["name"],memberList[selectedIndex]["profile_image"],false)));


      }


  }
}
