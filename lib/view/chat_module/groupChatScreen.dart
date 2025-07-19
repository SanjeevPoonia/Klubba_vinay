import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klubba/view/chat_module/newGroupScreen.dart';
import 'package:klubba/view/community/user_chat_screen.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class groupChatScreen extends StatefulWidget
{
  _groupChatScreen createState()=>_groupChatScreen();
}
class _groupChatScreen extends State<groupChatScreen>{
  bool isLoading=false;
  List<dynamic> groupChatList=[];
  List<dynamic> searchList=[];
  String userId="";
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      floatingActionButton: Container(
        width: 50,
        height: 50,
        child: FloatingActionButton(
            elevation: 4.0,
            child: Icon(Icons.group_add_sharp),
            backgroundColor:AppTheme.themeColor,
            onPressed: () async {

           final data=await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => newGroupScreen()));

           if(data!=null)
             {
               fetchChats();
             }



            }
        ),
      ),
      body:   Padding(padding: EdgeInsets.all(5),
        child: ListView(
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
                controller: _controller,
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
                onChanged: (String value){
                  onSearchTextChanged(value);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),

            isLoading?Center(child: Loader(),):
            searchList.length!=0 || _controller.text.isNotEmpty ?
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: searchList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int pos) {
                  String groupName=searchList[pos]['chatName'];
                  String groupId=searchList[pos]['_id'];
                  String groupImage="";
                  String lastMsg=searchList[pos]['latestMessage'];
                  String newMsg=searchList[pos]['newMessage'].toString();

                  String utcTime=searchList[pos]['updated_at'];

                  var date = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(utcTime, true);
                  var dateLocal  = date.toLocal();

                  var dateFormat=DateFormat("dd/MM");
                  var chatDate=dateFormat.format(dateLocal);
                  var todayDate=dateFormat.format(DateTime.now());

                  var hourFormat=DateFormat("HH:mm");
                  var chatTime=hourFormat.format(dateLocal);



                  print("Chat Date"+chatDate.toString());
                  print("Chat Time"+chatTime.toString());
                  print("today"+todayDate.toString());

                  bool isToday=false;
                  if(chatDate==isToday){
                    isToday=true;
                  }

                  return InkWell(
                    onTap: () async {

                      AppModel.setGroupData(searchList[pos]);


                  final data= await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreenUser(groupId,"",groupName,"",true)));
                  if(data!=null)
                    {
                      fetchChats();
                    }
                    },
                    onLongPress: (){
                      archiveChatBottomSheet(groupId);
                    },
                    child: Container(
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
                                    Stack(
                                      children: [
                                        groupImage.isNotEmpty
                                            ? CircleAvatar(
                                          radius: 18,
                                          backgroundImage:
                                          NetworkImage(AppConstant
                                              .profileImageURL +
                                              groupImage),
                                        )
                                            : CircleAvatar(
                                          radius: 18,
                                          backgroundImage: AssetImage(
                                              "assets/dummy_profile.png"),
                                        ),
                                      /*  Positioned(
                                            right: 2,
                                            bottom: 2,
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF06D451),
                                              ),
                                            )
                                        )*/
                                      ],
                                    ),

                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(groupName,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                    "Poppins",
                                                    color: AppTheme
                                                        .blueColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500)),
                                            Text(lastMsg,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: "Poppins",
                                                  color:
                                                  Color(0xFFB1B1B1),
                                                )),
                                          ],
                                        )),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        SizedBox(height: 5),



                                        isToday?Text(chatTime,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                "Poppins",
                                                color: Color(0xFFB1B1B1),
                                                fontWeight:
                                                FontWeight
                                                    .w500)):
                                        Text(chatDate+" "+chatTime,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                "Poppins",
                                                color: Color(0xFFB1B1B1),
                                                fontWeight:
                                                FontWeight
                                                    .w500)),

                                        newMsg=="0"?Stack():
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.themeColor,
                                            shape: BoxShape.circle,

                                          ),
                                          height: 18,
                                          width: 18,
                                          child: Center(
                                            child: Text(
                                              int.parse(newMsg)>9?
                                              "9+":

                                              newMsg,style: TextStyle(fontSize: 9,color: Colors.black,fontWeight: FontWeight.w500 ),),
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(width: 10),
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
                    ),
                  );
                }):
            groupChatList.length==0?

            Container(
              height: 400,
              child: Center(
                child: Text("No chats found!"),
              ),
            ):
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: groupChatList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int pos) {
                  String groupName=groupChatList[pos]['chatName'];
                  String groupId=groupChatList[pos]['_id'];
                  String groupImage="";
                  String lastMsg=groupChatList[pos]['latestMessage']??"";
                  String newMsg=groupChatList[pos]['newMessage'].toString();

                  String utcTime=groupChatList[pos]['updated_at'];

                  var date = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(utcTime, true);
                  var dateLocal  = date.toLocal();

                  var dateFormat=DateFormat("dd/MM");
                  var chatDate=dateFormat.format(dateLocal);
                  var todayDate=dateFormat.format(DateTime.now());

                  var hourFormat=DateFormat("HH:mm");
                  var chatTime=hourFormat.format(dateLocal);



                  print("Chat Date"+chatDate.toString());
                  print("Chat Time"+chatTime.toString());
                  print("today"+todayDate.toString());

                  bool isToday=false;
                  if(chatDate==isToday){
                    isToday=true;
                  }

                  return InkWell(
                    onTap: () async {

                      AppModel.setGroupData(groupChatList[pos]);

                    final data= await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreenUser(groupId,"",groupName,"",true)));
                    if(data!=null)
                      {
                        fetchChats();
                      }
                    },
                    onLongPress: (){
                      archiveChatBottomSheet(groupId);
                    },
                    child: Container(

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
                                    Stack(
                                      children: [
                                        groupImage.isNotEmpty
                                            ? CircleAvatar(
                                          radius: 18,
                                          backgroundImage:
                                          NetworkImage(AppConstant
                                              .profileImageURL +
                                              groupImage),
                                        )
                                            : CircleAvatar(
                                          radius: 18,
                                          backgroundImage: AssetImage(
                                              "assets/dummy_profile.png"),
                                        ),
                                     /*   Positioned(
                                            right: 2,
                                            bottom: 2,
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF06D451),
                                              ),
                                            )
                                        )*/
                                      ],
                                    ),

                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(groupName,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                    "Poppins",
                                                    color: AppTheme
                                                        .blueColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500)),
                                            Text(lastMsg,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: "Poppins",
                                                  color:
                                                  Color(0xFFB1B1B1),
                                                )),
                                          ],
                                        )),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        SizedBox(height: 5),



                                        isToday?Text(chatTime,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                "Poppins",
                                                color: Color(0xFFB1B1B1),
                                                fontWeight:
                                                FontWeight
                                                    .w500)):
                                        Text(chatDate+" "+chatTime,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                "Poppins",
                                                color: Color(0xFFB1B1B1),
                                                fontWeight:
                                                FontWeight
                                                    .w500)),

                                        newMsg=="0"?Stack():
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.themeColor,
                                            shape: BoxShape.circle,

                                          ),
                                          height: 18,
                                          width: 18,
                                          child: Center(
                                            child: Text(
                                              int.parse(newMsg)>9?
                                              "9+":

                                              newMsg,style: TextStyle(fontSize: 9,color: Colors.black,fontWeight: FontWeight.w500 ),),
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(width: 10),
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
                    ),
                  );
                })


          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchChats();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  fetchChats() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    userId = (await MyUtils.getSharedPreferences('_id'))!;
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getActiveChats",
      "data": {
        "user_id":userId,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by":userId
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('getActiveChats', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    List<dynamic> tempList=[];
    List<dynamic> chatList=[];
    tempList=responseJSON['decodedData']['result'];
    groupChatList.clear();



    for(int i=0; i<tempList.length;i++){
      if(tempList[i]['isGroupChat']==0){
        chatList.add(tempList[i]);
      }else{
        groupChatList.add(tempList[i]);
      }
    }


    //chatList= responseJSON['decodedData']['result'];


    setState(() {});
    print(responseJSON);
  }

  archiveChatBottomSheet(String roomId) {
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Text('Archive',
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

                      SizedBox(height: 10,),

                      Align(
                        alignment: Alignment.center,
                        child: Padding(padding: EdgeInsets.only(left: 30,right: 30,top: 5,bottom: 25),
                          child: Text("Archive this chat ?",

                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.5,
                            ),
                          ) ,),
                      ),
                      SizedBox(height: 27),

                      Padding(padding: EdgeInsets.only(left: 30,right: 30,top: 5,bottom: 25),
                        child: Row(
                          children: [
                            Expanded(child: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  child: Text('Yes',
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
                                    addToArchive(roomId);
                                  }),
                            )),
                            Expanded(child:  Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  child: Text('No',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.5)),
                                  style: ButtonStyle(
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            )),

                          ],
                        ),
                      ),

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
  addToArchive(String roomId) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    userId = (await MyUtils.getSharedPreferences('_id'))!;
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "archiveChat",
      "data": {
        "user_id":userId,
        "room_id":roomId,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('archiveChat', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    setState(() {});
    if(responseJSON['decodedData']['status'].toString()=='success'){
      Toast.show("Chat Archived Successfully!!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      fetchChats();
    }




    //chatList= responseJSON['decodedData']['result'];


    //setState(() {});
    print(responseJSON);
  }


  onSearchTextChanged(String text) async{
    searchList.clear();
    if(text.isEmpty){
      setState(() {

      });
      return ;
    }
    for(int i=0;i<groupChatList.length;i++){
      String groupName=groupChatList[i]['chatName'];
      if(groupName.toLowerCase().contains(text.toLowerCase())){
        searchList.add(groupChatList[i]);
      }
      setState(() {

      });
    }

  }

}