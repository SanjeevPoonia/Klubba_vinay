import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/all_media_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class GroupDetailScreen extends StatefulWidget {
  GroupDetailState createState() => GroupDetailState();
}

class GroupDetailState extends State<GroupDetailScreen> {
  Map<String, dynamic> groupData = {};
  bool status = false;
  bool status2 = true;
  int selectedSettingsIndex = 9999;
  List<int> selectedMemberIndex=[];
  String? userID;
  List<String> settingsList = ["Remove from group"/*, "Make Admin"*/];

  bool isLoading = false;
  List<dynamic> memberList = [];
  var searchController = TextEditingController();
  List<dynamic> addedMemberList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Group Details',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          SizedBox(height: 25),
          Center(
            child: Container(
              padding: EdgeInsets.all(25),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFB6BECA)),
              child: Center(
                child: Image.asset("assets/camera_ic.png"),
              ),
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: Text(groupData["chatName"],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5)),
          ),
          Center(
            child: Text(
                "Group Members : " + groupData["user"].length.toString(),
                style: TextStyle(
                    color: Color(0xFF708096),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 11)),
          ),
          SizedBox(height: 30),
          Text("About Group",
              style: TextStyle(
                  color: AppTheme.themeColor,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),
          SizedBox(height: 3),
          Text(groupData["description"] ?? "NA",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 12)),
          SizedBox(height: 5),
          Divider(
            thickness: 1.5,
          ),
          /* SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text("Group Media",
                  style: TextStyle(
                      color: AppTheme.themeColor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 13)),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllMediaScreen()));
                },
                child: Text("View All >",
                    style: TextStyle(
                        color: AppTheme.themeColor,
                        fontFamily: "Poppins",
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                        fontSize: 13)),
              ),


            ],
          ),

          SizedBox(height: 15),

          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: AssetImage("assets/group_dummy.jpeg"),
                    fit: BoxFit.fill
                  )
                ),
              ),

              SizedBox(width: 12),


              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("assets/group_dummy.jpeg"),
                        fit: BoxFit.fill
                    )
                ),
              ),

              SizedBox(width: 12),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("assets/group_dummy.jpeg"),
                        fit: BoxFit.fill
                    )
                ),
              ),

              SizedBox(width: 12),

              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("assets/group_dummy.jpeg"),
                        fit: BoxFit.fill
                    )
                ),
              ),




            ],
          ),

          SizedBox(height: 12),
          Divider(
            thickness: 1.5,
          ),


          SizedBox(height: 10),

          Text("Group Settings",
              style: TextStyle(
                  color: AppTheme.themeColor,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),


          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mute Messages",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 13)),



              Container(
                child: FlutterSwitch(
                  width: 56.0,
                  height: 26.0,
                  toggleSize: 25.0,
                  value: status,
                  borderRadius: 30.0,
                  padding: 1.0,
                  toggleColor: Color.fromRGBO(225, 225, 225, 1),
                  switchBorder: Border.all(
                    color:status? Color(0xFFFEDB74):Color(0xFF666666).withOpacity(0.8),
                    width: 1.0,
                  ),
                  toggleBorder: Border.all(
                    color:status ?Color(0xFFFEDB74):Color(0xFFBBBBBB),
                    width: 1.0,
                  ),
                  activeColor: Color(0xFFFFFAEB),
                  activeToggleColor:Color(0xFFFEDB74),
                  inactiveToggleColor: Color(0xFFBBBBBB),
                  inactiveColor: Color(0xFFECECEC),
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });
                  },
                ),
              ),

            ],
          ),

          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Archive Chat",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 13)),



              Container(
                child: FlutterSwitch(
                  width: 56.0,
                  height: 26.0,
                  toggleSize: 25.0,
                  value: status2,
                  borderRadius: 30.0,
                  padding: 1.0,
                  toggleColor: Color.fromRGBO(225, 225, 225, 1),
                  switchBorder: Border.all(
                    color:status2? Color(0xFFFEDB74):Color(0xFF666666).withOpacity(0.8),
                    width: 1.0,
                  ),
                  toggleBorder: Border.all(
                    color:status2 ?Color(0xFFFEDB74):Color(0xFFBBBBBB),
                    width: 1.0,
                  ),
                  activeColor: Color(0xFFFFFAEB),
                  activeToggleColor:Color(0xFFFEDB74),
                  inactiveToggleColor: Color(0xFFBBBBBB),
                  inactiveColor: Color(0xFFECECEC),
                  onToggle: (val) {
                    setState(() {
                      status2 = val;
                    });
                  },
                ),
              ),

            ],
          ),

          SizedBox(height: 15),

          Text("Leave Group",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),

          SizedBox(height: 18),

          Text("Report",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),


          SizedBox(height: 7),
          Divider(
            thickness: 1.5,
          ),
*/
          Text("Group Members",
              style: TextStyle(
                  color: AppTheme.themeColor,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 5, right: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 12,
                mainAxisSpacing: 0,
                crossAxisCount: 4,
                childAspectRatio: (2 / 3.2)),
            itemCount: groupData["user"].length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if(groupData["user"][index]["_id"]!=userID)
                    {
                      groupSettingsBottomSheet(groupData["user"][index]["_id"],index);
                    }



                },
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.white),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    groupData["user"][index]["profile_image"] != null
                                        ? AppConstant.profileImageURL+groupData["user"][index]["profile_image"]
                                        : ""))),
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2, right: 2),
                            child: Text(groupData["user"][index]["full_name"],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // Item rendering
            },
          ),
          SizedBox(height: 10),

          Text("Add Members",
              style: TextStyle(
                  color: AppTheme.themeColor,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),


          SizedBox(height: 15),
          Container(
            height: 48,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.3),
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
                  hintText: "Search members",
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
          Container(
              child: isLoading
                  ? Center(
                child: Loader(),
              )
                  : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: memberList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int pos) {
                    return InkWell(
                      onTap: () {

                        addMember(memberList[pos]["_id"]);
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
                                                                                  backgroundImage: NetworkImage(
                                              AppConstant
                                                  .profileImageURL +
                                                  memberList[pos][
                                                  "profile_image"]),
                                                                                ),
                                            selectedMemberIndex.contains(pos)
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
                                            selectedMemberIndex.contains(pos)
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
                                            ) : Container()
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
                  })),

          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
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
  groupSettingsBottomSheet(String memberID,int pos) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, dialogState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Card(
                margin: EdgeInsets.zero,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                            width: 80, height: 3, color: Color(0xFFAAAAAA)),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
                              child: Center(
                                child: Icon(Icons.close_sharp,
                                    color: Colors.white, size: 13.5),
                              ),
                            ),
                          ),
                          SizedBox(width: 15)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Group ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                    fontSize: 16)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Settings',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                        fontSize: 16)),
                                SizedBox(height: 3),
                                Container(
                                  width: 38,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: AppTheme.themeColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      ListView.builder(
                          itemCount: settingsList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      selectedSettingsIndex == pos
                                          ? Icon(Icons.radio_button_on,
                                              color: AppTheme.themeColor)
                                          : GestureDetector(
                                              child:
                                                  Icon(Icons.radio_button_off),
                                              onTap: () {
                                                dialogState(() {
                                                  selectedSettingsIndex = pos;
                                                });
                                              },
                                            ),
                                      SizedBox(width: 5),
                                      Text(
                                        settingsList[pos],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 18)
                              ],
                            );
                          }),
                      SizedBox(height: 27),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, top: 5, bottom: 25),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            child: Text('Apply',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.5)),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ))),
                            onPressed: () {
                              Navigator.pop(context);
                              removeMember(memberID, pos);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, false ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupData = AppModel.groupData;
  }
  fetchUserId() async {
    userID = await MyUtils.getSharedPreferences('_id');
  }

  removeMember(String memberID,int pos) async {
    APIDialog.showAlertDialog(context,"Removing Member");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? userId = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "leaveGroup",
      "data": {
        "room_id": groupData["_id"],
        "user": memberID,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": userId
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('leaveGroup', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if(responseJSON["decodedData"]["status"]=="success")
    {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      groupData["user"].removeAt(pos);
      setState(() {

      });
    }
    else
      {
        Toast.show(responseJSON['decodedData']['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
      }
    setState(() {});
    print(responseJSON);
  }


  addMember(String memberID) async {
    APIDialog.showAlertDialog(context,"Adding Member");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? userId = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "addMemberInGroup",
      "data": {
        "room_id": groupData["_id"],
        "members": memberID,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": userId
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('addMemberInGroup', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if(responseJSON["decodedData"]["status"]=="success")
    {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.pop(context);
      Navigator.pop(context,"refreeswh Data");
    }
    else
    {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    }
    setState(() {});
    print(responseJSON);
  }
}
