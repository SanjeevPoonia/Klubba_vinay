import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/friend_profile_screen.dart';
import 'package:klubba/widgets/loader.dart';

class MemberSearchTab extends StatefulWidget {
  MemberState createState() => MemberState();
}

class MemberState extends State<MemberSearchTab> {
  var searchController = TextEditingController();
  bool isLoading = false;
  List<dynamic> searchList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
              if(searchController.text.length>1)
              {
                searchUsers();
              }
            },
            textInputAction: TextInputAction.search,
            /*  onChanged: (value) {
              _runFilter(value);
            },*/
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: (){
                      if(searchController.text.length>1)
                      {
                        searchUsers();
                      }
                    },

                    child: Icon(Icons.search, color: AppTheme.blueColor)),
                contentPadding: EdgeInsets.only(left: 8, top: 11),
                hintText: "Please search your members",
                hintStyle: TextStyle(
                    color: Color(0xFF919191),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
            child:


                isLoading?


                    Center(
                      child: Loader(),
                    ):





            searchController.text.isNotEmpty && searchList.length==0?



            Container(
              child: Center(
                child: Text("No search results found"),
              ),
            ):




            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.vertical,
                itemCount: searchList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int pos) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            searchList[pos].toString().contains("profile_image")
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FriendProfileScreen(
                                                      searchList[pos]["_id"])));
                                    },
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            AppConstant.profileImageURL +
                                                searchList[pos]
                                                    ["profile_image"]),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                          "assets/dummy_profile.png"),
                                    ),
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Text(
                              searchList[pos]["name"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )),
                            SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 10,
                          color: Color(0x12000000),
                          thickness: 1,
                        )
                      ],
                    ),
                  );
                }))
      ],
    );
  }

  searchUsers() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "searchNewMember",
      "data": {
        "user_id":id,
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
    isLoading = false;
    searchList = responseJSON['decodedData']['result'];
    setState(() {});
    print(responseJSON);
  }
}
