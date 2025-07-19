import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/chat_detail_screen.dart';
import 'package:klubba/view/community/doc_preview_screen.dart';
import 'package:klubba/view/community/file_preview_screen.dart';
import 'package:klubba/view/community/friend_profile_screen.dart';
import 'package:klubba/view/community/full_video_screen.dart';
import 'package:klubba/view/community/group_detail_screen.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:klubba/widgets/video_widget.dart';
import 'package:toast/toast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenUser extends StatefulWidget {
  String roomID;
  String receiverUserID;
  String receiverName;
  String receiverProfileImage;
  bool isGroupChat;

  ChatScreenUser(this.roomID, this.receiverUserID, this.receiverName,
      this.receiverProfileImage, this.isGroupChat);

  ChatState createState() => ChatState();
}

class ChatState extends State<ChatScreenUser> {
  bool isLoading = false;
  int selectedMoreIndex = 0;
  String currentUserID = '';
  List<dynamic> chatList = [];
  List<XFile> imageList = [];
  List<XFile> videoList = [];
  List<File> docsList = [];
  String imagePath = "";
  String fileName = "";
  var chatController = TextEditingController();
  late IO.Socket socket;
  Map<String, dynamic> userData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: Loader(),
              )
            : Column(
                children: [
                  Container(
                    height: 110,
                    padding: EdgeInsets.only(left: 12, top: 20),
                    decoration: BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(34),
                            bottomRight: Radius.circular(34))),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.black)),
                        SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            if (widget.isGroupChat) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GroupDetailScreen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatDetailScreen(
                                          widget.roomID,
                                          widget.receiverUserID,
                                          widget.receiverName,
                                          widget.receiverProfileImage)));
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            margin: EdgeInsets.only(top: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(width: 1.2, color: Colors.white),
                                image:
                                    //assets/dummy_profile.png

                                    widget.receiverProfileImage == "" ||
                                            widget.isGroupChat
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/dummy_profile.png"))
                                        : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(AppConstant
                                                    .profileImageURL +
                                                widget.receiverProfileImage))),
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 35),
                            Text(widget.receiverName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                )),
                            SizedBox(height: 1),
                            /* Text("Online",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: Colors.green,
                                )),*/
                          ],
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          reverse: true,
                          itemCount: chatList.length,
                          itemBuilder: (BuildContext context, int pos) {
                            return GestureDetector(
                              onTap: () {
                                deleteChatBottomSheet(
                                    chatList[pos]["_id"], pos);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child:
                                      chatList[pos]["sender"] != currentUserID
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                chatList[pos]
                                                        .toString()
                                                        .contains("memberData")
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 0),
                                                        child: chatList[pos][
                                                                            "chatId"]
                                                                        [
                                                                        "user"][0]
                                                                    [
                                                                    "profile_image"] !=
                                                                ""
                                                            ? CircleAvatar(
                                                                radius: 25,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 22,
                                                                  backgroundImage: NetworkImage(AppConstant
                                                                          .profileImageURL +
                                                                      chatList[pos]["chatId"]["user"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          "profile_image"]),
                                                                ),
                                                              )
                                                            : CircleAvatar(
                                                                radius: 25,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 22,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          "assets/dummy_profile.png"),
                                                                ),
                                                              ),
                                                      )
                                                    : chatList[pos]["user"][0][
                                                                "profile_image"] !=
                                                            ""
                                                        ? CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: CircleAvatar(
                                                              radius: 22,
                                                              backgroundImage: NetworkImage(AppConstant
                                                                      .profileImageURL +
                                                                  chatList[pos][
                                                                          "user"][0]
                                                                      [
                                                                      "profile_image"]),
                                                            ),
                                                          )
                                                        : CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: CircleAvatar(
                                                              radius: 22,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      "assets/dummy_profile.png"),
                                                            ),
                                                          ),
                                                SizedBox(width: 5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 5),
                                                    chatList[pos]["type"] ==
                                                            "image"
                                                        ? InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ImageView(chatList[pos]
                                                                              [
                                                                              "path"])));
                                                            },
                                                            child: Container(
                                                              width: 120,
                                                              height: 120,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: NetworkImage(
                                                                          chatList[pos]
                                                                              [
                                                                              "path"]))),
                                                            ),
                                                          )
                                                        : chatList[pos]
                                                                    ["type"] ==
                                                                "video"
                                                            ? InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => FullVideoScreen(
                                                                              chatList[pos]["path"],
                                                                              "")));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 120,
                                                                  height: 120,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child:
                                                                      VideoWidget(
                                                                    url: chatList[
                                                                            pos]
                                                                        [
                                                                        "path"],
                                                                    play: true,
                                                                    loaderColor:
                                                                        AppTheme
                                                                            .blueColor,
                                                                  ),
                                                                ),
                                                              )
                                                            : chatList[pos][
                                                                        "type"] ==
                                                                    "text"
                                                                ? Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            12),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFEEF1FF),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        chatList[pos]["user"][0]["full_name"] != null &&
                                                                                widget.isGroupChat
                                                                            ? Text(chatList[pos]["user"][0]["full_name"],
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: pos % 2 == 0 ? Colors.pink : Colors.blue,
                                                                                ))
                                                                            : Container(),
                                                                        chatList[pos]["user"][0]["full_name"] != null &&
                                                                                widget.isGroupChat
                                                                            ? SizedBox(height: 5)
                                                                            : Container(),
                                                                        Text(
                                                                            chatList[pos][
                                                                                "content"],
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              color: Colors.black,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            70),
                                                                  )
                                                                : Image.asset(
                                                                    "assets/doc_ic.png"),
                                                    SizedBox(height: 3.5),
                                                    chatList[pos]
                                                            .toString()
                                                            .contains(
                                                                "memberData")
                                                        ? Text(
                                                            parseServerFormat(
                                                                chatList[pos][
                                                                        "createdAt"]
                                                                    .toString()),
                                                            style: TextStyle(
                                                              fontSize: 9,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                            ))
                                                        : Text(
                                                            parseServerFormatDate(
                                                                chatList[pos][
                                                                        "created_at"]
                                                                    .toString()),
                                                            style: TextStyle(
                                                              fontSize: 9,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                            )),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      chatList[pos]["type"] ==
                                                              "image"
                                                          ? InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ImageView(chatList[pos]["path"])));
                                                              },
                                                              child: Container(
                                                                width: 120,
                                                                height: 120,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image: NetworkImage(chatList[pos]
                                                                            [
                                                                            "path"]))),
                                                              ),
                                                            )
                                                          : chatList[pos][
                                                                      "type"] ==
                                                                  "video"
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                FullVideoScreen(chatList[pos]["path"], "")));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    height: 120,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        VideoWidget(
                                                                      url: chatList[
                                                                              pos]
                                                                          [
                                                                          "path"],
                                                                      play:
                                                                          true,
                                                                      loaderColor:
                                                                          AppTheme
                                                                              .blueColor,
                                                                    ),
                                                                  ),
                                                                )
                                                              : chatList[pos][
                                                                          "type"] ==
                                                                      "text"
                                                                  ? Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              12),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Color(0xFF5879EE),
                                                                            Color(0xFF6180F2),
                                                                            Color(0xFF6C89F6) /*Color.fromARGB(255, 29, 221, 163)*/
                                                                          ],
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                      ),
                                                                      child: Text(
                                                                          chatList[pos]
                                                                              [
                                                                              "content"],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              70),
                                                                    )
                                                                  : Image.asset(
                                                                      "assets/doc_ic.png"),
                                                      SizedBox(height: 3.5),
                                                      Row(
                                                        children: [
                                                          Spacer(),

                                                          /*    chatList[pos].toString().contains("memberData")?

                                                    Text(
                                                        parseServerFormat(
                                                            chatList[pos][
                                                            "createdAt"]
                                                                .toString()),
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                        )):
                              */

                                                          Text(
                                                              parseServerFormat(
                                                                  chatList[pos][
                                                                          "created_at"]
                                                                      .toString()),
                                                              style: TextStyle(
                                                                fontSize: 9,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                              )),
                                                          SizedBox(width: 5),
                                                          Icon(
                                                              Icons
                                                                  .remove_red_eye_outlined,
                                                              color: Color(
                                                                  0xFF6381F2),
                                                              size: 13)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8),

                                                /*     chatList[pos].toString().contains("memberData")?

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 13),
                                            child: chatList[pos]["chatId"]["user"][1]
                                            ["profile_image"] !=
                                                ""
                                                ? CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                              Colors.white,
                                              child: CircleAvatar(
                                                radius: 22,
                                                backgroundImage:
                                                NetworkImage(AppConstant
                                                    .profileImageURL +
                                                    chatList[pos]["chatId"]["user"][1]
                                                    ["profile_image"]),
                                              ),
                                            )
                                                : CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                              Colors.white,
                                              child: CircleAvatar(
                                                radius: 22,
                                                backgroundImage: AssetImage(
                                                    "assets/dummy_profile.png"),
                                              ),
                                            ),
                                          ):*/

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 13),
                                                  child: chatList[pos]["user"]
                                                                  [0][
                                                              "profile_image"] !=
                                                          ""
                                                      ? CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: CircleAvatar(
                                                            radius: 22,
                                                            backgroundImage: NetworkImage(AppConstant
                                                                    .profileImageURL +
                                                                chatList[pos][
                                                                        "user"][0]
                                                                    [
                                                                    "profile_image"]),
                                                          ),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: CircleAvatar(
                                                            radius: 22,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    "assets/dummy_profile.png"),
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            )),
                            );
                          })),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            offset: Offset(0, 0)),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child:

                          userData["profile_image"]!=null?

                          CircleAvatar(
                            radius: 22,
                            backgroundImage:




                            NetworkImage(
                                AppConstant.profileImageURL +
                                    userData["profile_image"])
                          ):

                          CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage("assets/dummy_profile.png"),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9)),
                            // height: 50,
                            child: TextFormField(
                                cursorHeight: 21,
                                controller: chatController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  suffixIcon: Container(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                      bottomSheet());
                                            },
                                            child: const Icon(
                                              Icons.attach_file,
                                              color: Colors.black54,
                                            )),
                                        SizedBox(width: 5),
                                        InkWell(
                                            onTap: () {
                                              _fetchImageFromCamera(context);
                                            },
                                            child: const Icon(
                                              Icons.camera_alt_outlined,
                                              color: Color(0xFF6180F2),
                                            )),
                                        SizedBox(width: 7),
                                      ],
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  fillColor: Color(0xFF7A8FA6).withOpacity(0.1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      10.0, 12.0, 5.0, 12.0),
                                  hintText: 'Type your message here',
                                  hintStyle: const TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: "Poppins",
                                    color: Color(0XFFD1D1D1),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            if (imageList.length != 0) {
                              _uploadPost(context);
                            } else if (chatController.text != "") {
                              chatList.insert(0, {
                                "_id": "64d3672a205bf75f83ec70cf",
                                "sender": currentUserID,
                                "roomId": widget.roomID,
                                "type": "text",
                                "path": "",
                                "content": chatController.text,
                                "fileName": "",
                                "created_at":
                                    DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
                                        .format(DateTime.now()),
                                "updated_at":
                                    DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
                                        .format(DateTime.now()),
                                "user": [
                                  {
                                    "_id": currentUserID,
                                    "full_name": userData["full_name"],
                                    "profile_image": userData["profile_image"]
                                  }
                                ]
                              });

                              setState(() {});
                              sendMessage(false);

                              sendMessageOnSocket();
                            } else if (docsList.length != 0) {
                              _uploadDoc(context);
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: AppTheme.blueColor,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData = AppModel.userData;
    fetchCurrentuserID();
    fetchChatMessages(true);
    messageSeen();
    initSocket();
  }

  initSocket() {
    socket = IO.io(AppConstant.socketURL, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
      print(socket.connected);
      socket.emit('setup', userData);
      socket.emit('join chat', widget.roomID);
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));

    socket.on('messageReceived', (newMessage) {
      print("New message arrived");
      print(newMessage);
      chatList.insert(0, newMessage);
      setState(() {});
    });
  }

  sendMessageOnSocket() {
    /*String message = chatController.text.trim();
    if (message.isEmpty) return;*/
    Map messageMap = {
      "sender": {
        "_id": userData["_id"],
        "name": userData["full_name"],
        "image": userData["profile_image"]
      },
      "content": chatController.text,
      "chatId": {
        "_id": widget.roomID,
        "chatName": "sender",
        "isGroupChat": widget.isGroupChat ? 1 : 0,
        "latestMessage": chatController.text,
        "newMessage": 0,
        "created_at":
            DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now()),
        "updated_at":
            DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now()),
        "user": [
          {
            "_id": userData["_id"],
            "full_name": userData["full_name"],
            "profile_image": userData["profile_image"]
          },
          {
            "_id": widget.receiverUserID,
            "full_name": widget.receiverName,
            "profile_image": widget.receiverProfileImage
          },
        ],
        "memberData": {
          "_id": widget.receiverUserID,
          "full_name": widget.receiverName,
          "profile_image": widget.receiverProfileImage
        }
      },
      "_id": widget.roomID,
      "type": imageList.length != 0
          ? "image"
          : docsList.length != 0
              ? "doc"
              : "text",
      "fileName": fileName,
      "path": imagePath,
      "createdAt":
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now()),
      "updatedAt": DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now())
    };

    print("Sending message on socket");
    socket.emit('new message', messageMap);
    print("Message sent on socket");
    print(messageMap);
  }

  String parseServerFormat(String serverDate) {
    var date = DateTime.parse(serverDate).toLocal();
    final dateformat = DateFormat.jm();
    final dateformat2 = DateFormat.yMMMd();
    final clockString = dateformat.format(date);
    final clockString2 = dateformat2.format(date);
    return clockString2.toString() + " " + clockString.toString();
  }

  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.yMMMEd();
    final clockString = dateformat.format(date);
    return clockString.toString();
  }

  fetchChatMessages(bool showLoader) async {
    if (showLoader) {
      setState(() {
        isLoading = true;
      });
    }
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getChatMessages",
      "data": {
        "roomId": widget.roomID,
        "user_id": id,
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
        'getChatMessages', requestModel, context);
    var responseJSON = json.decode(response.body);

    if (showLoader) {
      isLoading = false;
    }
    chatList = responseJSON['decodedData']['result'];
    chatList = chatList.reversed.toList();
    setState(() {});
    print(responseJSON);
  }

  deleteMessage(String msgID, int pos) async {
    APIDialog.showAlertDialog(context, "Deleting message...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "deleteMessage",
      "data": {
        "msg_id": msgID,
        "user_id": id,
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
        await helper.postAPI('deleteMessage', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show("Deleted successfully !!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      chatList.removeAt(pos);
      setState(() {

      });

    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  messageSeen() async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "seenMessage",
      "data": {
        "roomId": widget.roomID,
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
        await helper.postAPIWithHeader('seenMessage', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
  }

  _uploadPost(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Uploading Post...');
    String? id = await MyUtils.getSharedPreferences('_id');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "data": {
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      },
      "method_name": "sendImageForChat"
    };

    FormData formData = FormData.fromMap({
      "req": base64.encode(utf8.encode(json.encode(data))),
    });
    print(formData.fields);
    for (int i = 0; i < imageList.length; i++) {
      var path = imageList[i].path.toString();
      formData.files.addAll([
        MapEntry("image", await MultipartFile.fromFile(path, filename: path))
      ]);
    }
    Dio dio = Dio();
    var response = await dio.post(AppConstant.appBaseURL + "sendImageForChat",
        data: formData);

    //sendPdfForChat
    print(data);
    print(response.data.toString());
    Navigator.pop(context);

    if (response.data['decodedData']['status'] == "success") {
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      imagePath = response.data['decodedData']['result']['image'][0];
      fileName = imagePath.split('/').last;

      sendMessage(false);
      sendMessageOnSocket();
    } else {
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _uploadDoc(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Uploading Docs...');
    String? id = await MyUtils.getSharedPreferences('_id');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "data": {
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      },
      "method_name": "sendPdfForChat"
    };

    FormData formData = FormData.fromMap({
      "req": base64.encode(utf8.encode(json.encode(data))),
    });
    print(formData.fields);
    for (int i = 0; i < docsList.length; i++) {
      var path = docsList[i].path.toString();
      formData.files.addAll([
        MapEntry("image", await MultipartFile.fromFile(path, filename: path))
      ]);
    }
    Dio dio = Dio();
    var response = await dio.post(AppConstant.appBaseURL + "sendPdfForChat",
        data: formData);

    //sendPdfForChat
    print(data);
    print(response.data.toString());
    Navigator.pop(context);

    if (response.data['decodedData']['status'] == "success") {
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      imagePath = response.data['decodedData']['result']['image'][0];
      fileName = imagePath.split('/').last;

      sendMessage(false);
      sendMessageOnSocket();
    } else {
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  sendMessage(bool showLoader) async {
    if (showLoader) {
      APIDialog.showAlertDialog(context, "Uploading file...");
    }
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveMessage",
      "data": {
        "sender": id,
        "roomId": widget.roomID,
        "type": imageList.length != 0
            ? "image"
            : docsList.length != 0
                ? "doc"
                : "text",
        "fileName": fileName,
        "content": chatController.text,
        "path": imagePath,
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
        await helper.postAPIWithHeader('saveMessage', requestModel, context);
    var responseJSON = json.decode(response.body);

    if (showLoader) {
      Navigator.pop(context);
    }
    if (responseJSON['decodedData']['status'] == "success") {
      imageList.clear();
      imagePath = "";
      fileName = "";
      chatController.text = "";
      fetchChatMessages(false);
    }
    setState(() {});
    print(responseJSON);
  }

  fetchCurrentuserID() async {
    String? id = await MyUtils.getSharedPreferences('_id');
    currentUserID = id.toString();
  }

  _fetchImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      imageList.add(image);
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => FilePreviewScreen(image)));
      if (result != null) {
        if (result.toString() != "Only file") {
          chatController.text = result.toString();
        }

        _uploadPost(context);
        setState(() {});
      } else {
        imageList.clear();
      }
    }
  }





  _fetchVideo() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      videoList.add(image);
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => FilePreviewScreen(image)));
      if (result != null) {
        if (result.toString() != "Only file") {
          chatController.text = result.toString();
        }

        _uploadPost(context);

        setState(() {});
      } else {
        videoList.clear();
      }
    }
  }

  _fetchImageFromCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      imageList.add(image);
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => FilePreviewScreen(image)));
      if (result != null) {
        if (result.toString() != "Only file") {
          chatController.text = result.toString();
        }

        _uploadPost(context);
        setState(() {});
      } else {
        imageList.clear();
      }
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 166,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.only(left: 32, right: 32, top: 18, bottom: 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconCreation(Icons.insert_photo, AppTheme.blueColor, "Picture",
                  () {
                _fetchImage(context);
              }),
              iconCreation(
                  Icons.video_collection_rounded, AppTheme.blueColor, "Video",
                  () {
                _fetchVideo();
              }),
              iconCreation(Icons.file_copy, AppTheme.blueColor, "Docs", () {
                pickDocs();
              }),
            ],
          ),
        ),
      ),
    );
  }

  pickDocs() async {
    FilePickerResult? result22 = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc'],
    );

    if (result22 != null) {
      File file = File(result22.files.single.path.toString());
      docsList.add(file);
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => DocPreviewScreen(file)));
      if (result != null) {
        if (result.toString() != "Only file") {
          chatController.text = result.toString();
        }

        _uploadDoc(context);
        setState(() {});
      } else {
        docsList.clear();
      }
    } else {
      // User canceled the picker
    }
  }

  Widget iconCreation(
      IconData icons, Color color, String text, Function onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.disconnect();
    socket.dispose();
  }

  deleteChatBottomSheet(String messageID, int pos) {
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
                              children: [
                                SizedBox(height: 10),
                                Text('More',
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
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            selectedMoreIndex == pos
                                ? Icon(Icons.radio_button_on,
                                    color: AppTheme.themeColor)
                                : GestureDetector(
                                    child: Icon(Icons.radio_button_off),
                                    onTap: () {
                                      dialogState(() {
                                        selectedMoreIndex = pos;
                                      });
                                    },
                                  ),
                            SizedBox(width: 5),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, top: 5, bottom: 25),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            child: Text('Save',
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
                              deleteMessage(messageID, pos);
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
}
