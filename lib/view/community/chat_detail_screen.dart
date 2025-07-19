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
import 'package:klubba/view/community/friend_profile_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class ChatDetailScreen extends StatefulWidget {
  String roomID;
  String receiverUserID;
  String receiverName;
  String receiverProfileImage;

  ChatDetailScreen(this.roomID, this.receiverUserID, this.receiverName,
      this.receiverProfileImage);

  GroupDetailState createState() => GroupDetailState();
}

class GroupDetailState extends State<ChatDetailScreen> {
  Map<String, dynamic> groupData = {};
  bool status = false;
  bool status2 = true;
  int selectedSettingsIndex = 9999;
  List<int> selectedMemberIndex = [];
  String? userID;
  List<String> settingsList = [
    "Remove from group" /*, "Make Admin"*/
  ];

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
                text:  'Details',
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
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 57,
                height: 57,
                margin: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.2, color: Colors.white),
                    image:
                        //assets/dummy_profile.png

                        widget.receiverProfileImage == ""
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/dummy_profile.png"))
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    AppConstant.profileImageURL +
                                        widget.receiverProfileImage))),
              ),
              SizedBox(width: 10),
              Text(widget.receiverName,
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
          Text("Chat Settings",
              style: TextStyle(
                  color: AppTheme.themeColor,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),
          SizedBox(height: 20),
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
                  value: status,
                  borderRadius: 30.0,
                  padding: 1.0,
                  toggleColor: Color.fromRGBO(225, 225, 225, 1),
                  switchBorder: Border.all(
                    color: status
                        ? Color(0xFFFEDB74)
                        : Color(0xFF666666).withOpacity(0.8),
                    width: 1.0,
                  ),
                  toggleBorder: Border.all(
                    color: status ? Color(0xFFFEDB74) : Color(0xFFBBBBBB),
                    width: 1.0,
                  ),
                  activeColor: Color(0xFFFFFAEB),
                  activeToggleColor: Color(0xFFFEDB74),
                  inactiveToggleColor: Color(0xFFBBBBBB),
                  inactiveColor: Color(0xFFECECEC),
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });

                    if(status)
                      {
                        addToArchive();
                      }

                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendProfileScreen(widget.receiverUserID)));
            },
            child: Text("View Profile",
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 13)),
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: (){
              deleteMemberChat();
            },
            child:    Text("Delete Chat",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 13)),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              blockMemberChat();
            },
            child: Text("Block",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 13)),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserId();
  }

  fetchUserId() async {
    userID = await MyUtils.getSharedPreferences('_id');
  }

  blockMemberChat() async {
    APIDialog.showAlertDialog(context, "Blocking Member");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? userId = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "blockChat",
      "data": {
        "roomId": widget.roomID,
        "user_id": userId,
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
        await helper.postAPIWithHeader('blockChat', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.of(context)
        ..pop()
        ..pop();
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    }
    setState(() {});
    print(responseJSON);
  }

  deleteMemberChat() async {
    APIDialog.showAlertDialog(context, "Deleting Chat");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? userId = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    var data = {
      "method_name": "deleteChatRoom",
      "data": {
        "roomId": widget.roomID,
        "user_id": userId,
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
        await helper.postAPIWithHeader('deleteChatRoom', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.of(context)
        ..pop()
        ..pop();
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    }
    setState(() {});
    print(responseJSON);
  }


  addToArchive() async {
    APIDialog.showAlertDialog(context, "Archiving Chat");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "archiveChat",
      "data": {
        "user_id":userID,
        "room_id":widget.roomID,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('archiveChat', requestModel, context);
    var responseJSON = json.decode(response.body);
     Navigator.pop(context);
    setState(() {});
    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    /*  Navigator.of(context)
        ..pop()
        ..pop();*/
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    }
    print(responseJSON);
  }
}
