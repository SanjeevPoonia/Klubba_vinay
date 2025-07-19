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

class sendRequest extends StatefulWidget {
  sendRequestState createState() => sendRequestState();
}

class sendRequestState extends State<sendRequest> {
  bool isLoading = false;
  List<dynamic> requestsList = [];
  List<dynamic> searchList=[];
  var searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return ListView(
      children: [
        isLoading
            ? Center(
          child: Loader(),
        )
            : Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                      suffixIcon:
                      Icon(Icons.search, color: AppTheme.blueColor),
                      contentPadding: EdgeInsets.only(left: 8, top: 11),
                      hintText: "Search",
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

              requestsList.length==0?

              Container(
                height: 400,
                child: Center(
                  child: Text("No requests found!"),
                ),
              ):

              searchList.length != 0 ||
                  searchController.text.isNotEmpty
                  ?
              ListView.builder(
                  shrinkWrap: true,
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
                              searchList[pos]
                                  .toString()
                                  .contains("profile_image") && searchList[pos]
                              ["profile_image"]!=""
                                  ? GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfileScreen(searchList[pos]["user_id"])));
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
                                  : GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfileScreen(searchList[pos]["user_id"])));
                                },
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                        "assets/dummy_profile.png"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                    searchList[pos]["full_name"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )),
                              SizedBox(
                                width: 5,
                              ),

                              InkWell(
                                onTap: () {
                                  unfollowCommunity(searchList[pos]["user_id"], pos);
                                },
                                child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(4)),
                                    color: Colors.red,
                                    child: Container(
                                      width: 100,
                                      height: 37,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text(
                                            "Cancel Request",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )),
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
                  }):
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: requestsList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int pos) {
                    return Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              requestsList[pos]
                                  .toString()
                                  .contains("profile_image") && requestsList[pos]
                              ["profile_image"]!=""
                                  ? GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfileScreen(requestsList[pos]["user_id"])));
                                },
                                    child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        AppConstant.profileImageURL +
                                            requestsList[pos]
                                            ["profile_image"]),
                                ),
                              ),
                                  )
                                  : GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfileScreen(requestsList[pos]["user_id"])));
                                },
                                    child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                        "assets/dummy_profile.png"),
                                ),
                              ),
                                  ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                    requestsList[pos]["full_name"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )),
                              SizedBox(
                                width: 5,
                              ),

                              InkWell(
                                onTap: () {
                                  unfollowCommunity(requestsList[pos]["user_id"], pos);
                                },
                                child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(4)),
                                    color: Colors.red,
                                    child: Container(
                                    //  width: 100,
                                      height: 37,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text(
                                            "Cancel Request",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    )),
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
                  }),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMyRequests();
  }

  fetchMyRequests() async {
    setState(() {
      isLoading = true;
    });

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getAllSentRequest",
      "data": {
        "user_id": id,
        "page": 1,
        "limit": 10,
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
        'getAllSentRequest', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;

    if(responseJSON['decodedData']['result'].length!=0)
      {
        requestsList = responseJSON['decodedData']['result'][0]['record'];
      }



    setState(() {});
    print(responseJSON);
  }

  unfollowCommunity(String communityID,int pos) async {
    APIDialog.showAlertDialog(context, "Please wait");
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
      requestsList.removeAt(pos);
      setState(() {

      });

    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
    print(responseJSON);
  }
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = requestsList;
    } else {
      results = requestsList
          .where((friend) => friend['full_name']
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
}
