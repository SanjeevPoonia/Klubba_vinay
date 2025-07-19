import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/community/friend_profile_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';

class menuMyCommunity extends StatefulWidget {
  _menuMyCommunityState createState() => _menuMyCommunityState();
}

class _menuMyCommunityState extends State<menuMyCommunity> {
  List<dynamic> communityList = [];
  bool isLoading = false;
  int _selectedIndex = 0;
  var searchController = TextEditingController();
  List<dynamic> searchList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                text: 'My ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Community',
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
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : Column(
            children: [

              SizedBox(height: 15),

              Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(
                            0, 0), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    border: Border.all(
                        width: 1, color: const Color(0xFFCDCDCD))),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    _runFilter(value);
                  },
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search,
                          color: AppTheme.blueColor),
                      contentPadding:
                      EdgeInsets.only(left: 8, top: 11),
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: Color(0xFF919191),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none),
                ),
              ),



              SizedBox(height: 10),


              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 17, right: 17, top: 29),
                    child:
                    searchList.length != 0 ||
                        searchController.text.isNotEmpty?

                    GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 13,
                            mainAxisSpacing: 30,
                            crossAxisCount: 2,
                            childAspectRatio: (3 / 3)),
                        padding: EdgeInsets.all(5),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FriendProfileScreen(
                                                      searchList[index]
                                                      ["user_id"])));
                                    },
                                    child: Container(
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4)),
                                        color: Color(0xFFEBEBEB),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 35),
                                            Text(searchList[index]["name"],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/loc_blue_ic.png",
                                                    width: 14, height: 14),
                                                Text(
                                                  "Jaipur, Rajasthan",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            InkWell(
                                              onTap: (){

                                                unfollowCommunity(searchList[index]
                                                ["user_id"]);


                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppTheme.themeColor,
                                                    borderRadius:
                                                    BorderRadius.circular(2)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 5,
                                                      bottom: 5),
                                                  child: Text(
                                                    "Unfollow",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 18),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    transform:
                                    Matrix4.translationValues(0.0, -25.0, 0.0),
                                    child: Center(
                                      child: searchList[index]
                                          .toString()
                                          .contains("profile")
                                          ? CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(
                                              AppConstant.profileImageURL +
                                                  searchList[index]
                                                  ["profile"]),
                                        ),
                                      )
                                          : CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundImage: AssetImage(
                                              "assets/dummy_profile.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),

                              /*     Center(
                          child: RadioListTile(
                              value: index,
                              groupValue: _selectedIndex,
                              onChanged: (newIndex){
                                setState(() {
                                  _selectedIndex = newIndex!;
                                });
                              }),
                        )*/
                            ],
                          );
                        }):
                    GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 13,
                            mainAxisSpacing: 30,
                            crossAxisCount: 2,
                            childAspectRatio: (3 / 3)),
                        padding: EdgeInsets.all(5),
                        itemCount: communityList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FriendProfileScreen(
                                                      communityList[index]
                                                          ["user_id"])));
                                    },
                                    child: Container(
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4)),
                                        color: Color(0xFFEBEBEB),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 35),
                                            Text(communityList[index]["name"],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/loc_blue_ic.png",
                                                    width: 14, height: 14),
                                                Text(
                                                  "Jaipur, Rajasthan",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            InkWell(
                                              onTap: (){

                                                unfollowCommunity(communityList[index]
                                                ["user_id"]);


                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppTheme.themeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(2)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 5,
                                                      bottom: 5),
                                                  child: Text(
                                                    "Unfollow",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 18),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    transform:
                                        Matrix4.translationValues(0.0, -25.0, 0.0),
                                    child: Center(
                                      child: communityList[index]
                                              .toString()
                                              .contains("profile")
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 28,
                                                backgroundImage: NetworkImage(
                                                    AppConstant.profileImageURL +
                                                        communityList[index]
                                                            ["profile"]),
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 28,
                                                backgroundImage: AssetImage(
                                                    "assets/dummy_profile.png"),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),

                              /*     Center(
                          child: RadioListTile(
                              value: index,
                              groupValue: _selectedIndex,
                              onChanged: (newIndex){
                                setState(() {
                                  _selectedIndex = newIndex!;
                                });
                              }),
                        )*/
                            ],
                          );
                        }),
                  ),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMyCommunity();
  }

  fetchMyCommunity() async {
    setState(() {
      isLoading = true;
    });

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "allYourFriends",
      "data": {
        "user_id": id,
        "page": 1,
        "limit": 10,
        "section_type": "all_your_communities",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('allYourFriends', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    communityList = responseJSON['decodedData']['result'];
    setState(() {});
    print(responseJSON);
  }
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = communityList;
    } else {
      results = communityList
          .where((friend) => friend['name']
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }
  unfollowCommunity(String communityID) async {
    APIDialog.showAlertDialog(context, "Removing community");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "unfollowfriendOrCommunity",
      "data": {
        "user_id": id,
        "requested_user_id": communityID,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('unfollowfriendOrCommunity', requestModel, context);
    var responseJSON = json.decode(response.body);

    Navigator.pop(context);

    if (responseJSON['decodedData']['status'] == "success") {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      fetchMyCommunity();
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
    print(responseJSON);
  }
}
