import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/full_video_screen.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/widgets/video_widget.dart';
import 'package:mime/mime.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toast/toast.dart';

class ResharePostWidget extends StatefulWidget {
  String userName;
  String profileImage;
  Map<String, dynamic> postData;
  List<dynamic> mediaFiles;
  List<String> radioItems;

  ResharePostWidget(this.userName, this.profileImage, this.postData,
      this.mediaFiles, this.radioItems);

  @override
  PostState createState() => PostState();
}

class PostState extends State<ResharePostWidget> {
  var addPostController = TextEditingController();
  late PageController _pageController;
  int activePage = 1;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 85,
              padding: EdgeInsets.only(left: 12, right: 10, top: 20),
              width: double.infinity,
              color: AppTheme.themeColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, top: 7),
                      child: Icon(
                        Icons.close_outlined,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 7),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins",
                          color: Color(0xFF1A1A1A),
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Reshare ',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Post',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 80,
                    child: ElevatedButton(
                        child: Text('Post',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ))),
                        onPressed: () {
                          repost();
                          if (addPostController.text != "") {

                          }
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: 8),
                Container(
                  width: 55,
                  height: 55,
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 1.2, color: Colors.white),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.profileImage))),
                ),
                SizedBox(width: 5),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    SizedBox(height: 5),
                    Container(
                      width: 66,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: AppTheme.themeColor),
                      child: Row(
                        children: [
                          SizedBox(width: 7),
                          Text("Public",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.5)),
                          SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                          )
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: addPostController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(4.0, 5.0, 0.0, 10.0),
                    hintText: 'What\'s on your mind?',
                    hintStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB8B6B6)),
                  )),
            ),

            /*  Row(
              children: [
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(Icons.location_pin,color: Color(0xFF484D54),size: 12),
                ),
                SizedBox(width: 2),

                Text('Jaipur, Rajasthan',
                    style: TextStyle(
                        color: Color(0xFF484D54),
                        fontWeight: FontWeight.w500,
                        fontSize: 11)),
              ],
            ),*/

            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Color(0xFFF1F1F5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 6),
                    child: Row(
                      children: [
                        // assets/dummy_profile.png
                        widget.postData
                                .toString()
                                .contains("user_profile_image")
                            ? CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                    AppConstant.profileImageURL +
                                        widget.postData["user_profile_image"]),
                              )
                            : CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    AssetImage("assets/dummy_profile.png"),
                              ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.postData["name"],
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.w500)),
                            Text(
                                timeago.format(DateTime.parse(
                                    widget.postData["created_at"])),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontFamily: "Poppins",
                                  color: Color(0xFFB1B1B1),
                                )),
                          ],
                        )),
                        /* Padding(
                          padding:
                          const EdgeInsets.only(
                              bottom: 5),
                          child: GestureDetector(
                            onTap: (){
                           //   postOptionsBottomSheet();
                            },
                            child: Image.asset(
                                "assets/menu_icc.png",
                                width: 15,
                                height: 15),
                          ),
                        ),*/
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  // Repost Data

                  widget.postData.toString().contains("repostData")
                      ? widget.postData["repostData"]
                              .toString()
                              .contains("survey_title")
                          ? Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.postData
                                              .toString()
                                              .contains("description") &&
                                          widget.postData != null
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, bottom: 8),
                                          child: Text(
                                              widget.postData["description"]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontFamily: "Poppins",
                                                color: Colors.black,
                                              )),
                                        )
                                      : Container(),
                                  Card(
                                    elevation: 3,
                                    margin:
                                        EdgeInsets.only(left: 15, right: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 6),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              // assets/dummy_profile.png
                                              widget.postData["repostData"]
                                                      .toString()
                                                      .contains(
                                                          "user_profile_image")
                                                  ? CircleAvatar(
                                                      radius: 18,
                                                      backgroundImage:
                                                          NetworkImage(AppConstant
                                                                  .profileImageURL +
                                                              widget.postData[
                                                                      "repostData"]
                                                                  [
                                                                  "user_profile_image"]),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 18,
                                                      backgroundImage: AssetImage(
                                                          "assets/dummy_profile.png"),
                                                    ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(widget.postData["name"],
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily: "Poppins",
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(
                                                      timeago.format(
                                                          DateTime.parse(widget
                                                                      .postData[
                                                                  "repostData"]
                                                              ["created_at"])),
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        fontFamily: "Poppins",
                                                        color:
                                                            Color(0xFFB1B1B1),
                                                      )),
                                                ],
                                              )),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                                widget.postData["repostData"]
                                                    ["survey_title"],
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontFamily: "Poppins",
                                                  color: Colors.black,
                                                )),
                                          ),
                                          SizedBox(height: 5),
                                          ListView.builder(
                                              itemCount:
                                                  widget.radioItems.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index22) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .radio_button_off),
                                                            SizedBox(width: 5),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 15),
                                                              child: Text(
                                                                  widget.radioItems[
                                                                      index22],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11.5,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {},
                                                    )
                                                  ],
                                                );
                                              }),
                                          SizedBox(height: 8),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                            )
                          : Column(
                              children: [
                                widget.postData
                                            .toString()
                                            .contains("description") &&
                                        widget.postData != null
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, bottom: 8),
                                        child: Text(
                                            widget.postData["description"]
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontFamily: "Poppins",
                                              color: Colors.black,
                                            )),
                                      )
                                    : Container(),
                                Card(
                                  elevation: 3,
                                  margin: EdgeInsets.only(left: 15, right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 6),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            // assets/dummy_profile.png
                                            widget.postData["repostData"]
                                                    .toString()
                                                    .contains(
                                                        "user_profile_image")
                                                ? CircleAvatar(
                                                    radius: 18,
                                                    backgroundImage:
                                                        NetworkImage(AppConstant
                                                                .profileImageURL +
                                                            widget.postData[
                                                                    "repostData"]
                                                                [
                                                                "user_profile_image"]),
                                                  )
                                                : CircleAvatar(
                                                    radius: 18,
                                                    backgroundImage: AssetImage(
                                                        "assets/dummy_profile.png"),
                                                  ),
                                            SizedBox(width: 10),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(widget.postData["name"],
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: "Poppins",
                                                        color:
                                                            AppTheme.blueColor,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Text(
                                                    timeago.format(
                                                        DateTime.parse(widget
                                                                    .postData[
                                                                "repostData"]
                                                            ["created_at"])),
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      fontFamily: "Poppins",
                                                      color: Color(0xFFB1B1B1),
                                                    )),
                                              ],
                                            )),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        widget.postData["repostData"]
                                                        ["description"] !=
                                                    "" &&
                                                widget.postData["repostData"]
                                                        ["description"] !=
                                                    null
                                            ? Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Text(
                                                        widget.postData[
                                                                "repostData"]
                                                            ["description"],
                                                        style: TextStyle(
                                                          fontSize: 11.5,
                                                          fontFamily: "Poppins",
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        SizedBox(height: 5),
                                        widget.mediaFiles.length != 0
                                            ? Stack(
                                                children: [
                                                  SizedBox(
                                                    //  width: MediaQuery.of(context).size.width,
                                                    height: 200,
                                                    child: PageView.builder(
                                                        itemCount: widget
                                                            .mediaFiles.length,
                                                        pageSnapping: true,
                                                        controller:
                                                            _pageController,
                                                        onPageChanged: (page) {
                                                          setState(() {
                                                            activePage = page;
                                                          });
                                                        },
                                                        itemBuilder: (context,
                                                            pagePosition) {
                                                          bool active =
                                                              pagePosition ==
                                                                  activePage;
                                                          return slider(
                                                              widget.mediaFiles,
                                                              pagePosition,
                                                              active);
                                                        }),
                                                  ),
                                                  Container(
                                                    height: 200,
                                                    child: Column(
                                                      children: [
                                                        Spacer(),
                                                        Container(
                                                          transform: Matrix4
                                                              .translationValues(
                                                                  0.0,
                                                                  -10.0,
                                                                  0.0),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: indicators(
                                                                  widget
                                                                      .mediaFiles
                                                                      .length,
                                                                  activePage)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        widget.postData["repostData"]
                                                .toString()
                                                .contains("event_name")
                                            ? Container(
                                                padding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                margin: EdgeInsets.only(top: 7),
                                                child: DottedBorder(
                                                  borderType: BorderType.RRect,
                                                  radius: Radius.circular(2),
                                                  dashPattern: [1, 1],
                                                  color: Colors.grey,
                                                  strokeWidth: 2,
                                                  child: Card(
                                                    color: AppTheme.eveBgColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF1F1F5)),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                    width: 5),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      returnEventMonth(widget
                                                                          .postData[
                                                                              "repostData"]
                                                                              [
                                                                              "event_start_date"]
                                                                          .toString()),
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFFFF0200),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      returnEventDateSeparate(widget
                                                                          .postData[
                                                                              "repostData"]
                                                                              [
                                                                              "event_start_date"]
                                                                          .toString()),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              20),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    width: 15),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        widget.postData["repostData"]
                                                                            [
                                                                            "event_name"],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                "Poppins",
                                                                            color:
                                                                                AppTheme.blueColor,
                                                                            fontWeight: FontWeight.w500)),
                                                                    Text(
                                                                        returnEventDate(widget.postData["repostData"]["event_start_date"].toString()) +
                                                                            "-" +
                                                                            returnEventDate(widget.postData["repostData"]["event_end_date"]
                                                                                .toString()),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                          color:
                                                                              Color(0xFFB1B1B1),
                                                                        )),
                                                                  ],
                                                                )),
                                                                SizedBox(
                                                                    width: 10),
                                                                /* Expanded(child: InkWell(
                                                                       onTap:(){} ,
                                                                       child: Container(
                                                                         decoration: BoxDecoration(color: AppTheme.blueColor),
                                                                         child: Center(
                                                                           child: Text("Interested",
                                                                             style: TextStyle(fontSize: 12,color: Colors.white),),
                                                                         ),
                                                                       ),

                                                                     )),*/
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 7),
                                                          Row(
                                                            children: [
                                                              Image.asset(
                                                                  "assets/loc_blue_ic.png",
                                                                  width: 13,
                                                                  color: AppTheme
                                                                      .blueColor,
                                                                  height: 13),
                                                              SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                  child: Text(
                                                                widget.postData[
                                                                        "repostData"]
                                                                    ["address"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black),
                                                              ))
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          /*Row(
                                                                 children: [
                                                               CircleAvatar(
                                                                     radius: 10,
                                                                     backgroundImage: AssetImage(
                                                                         "assets/dummy_profile.png"),
                                                                   ),
                                                                   SizedBox(width: 10),
                                                                   Expanded(child: Text("27 People Went", style: TextStyle(fontSize: 12,color: Colors.black,),))
                                                                 ],
                                                               )
*/
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            )
                      : widget.postData.toString().contains("survey_title")
                          ? Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.postData
                                              .toString()
                                              .contains("description") &&
                                          widget.postData != null
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, bottom: 8),
                                          child: Text(
                                              widget.postData["description"]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontFamily: "Poppins",
                                                color: Colors.black,
                                              )),
                                        )
                                      : Container(),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 6),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                              widget.postData["survey_title"],
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontFamily: "Poppins",
                                                color: Colors.black,
                                              )),
                                        ),
                                        SizedBox(height: 5),
                                        ListView.builder(
                                            itemCount: widget.radioItems.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context,
                                                int index22) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons
                                                              .radio_button_off),
                                                          SizedBox(width: 5),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                            child: Text(
                                                                widget.radioItems[
                                                                    index22],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      11.5,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () {},
                                                  )
                                                ],
                                              );
                                            }),
                                        SizedBox(height: 8),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                            )
                          : Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  widget.postData["description"] != "" &&
                                          widget.postData["description"] != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                    widget.postData["description"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 11.5,
                                                      fontFamily: "Poppins",
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(height: 5),
                                  widget.mediaFiles.length != 0
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200,
                                              child: PageView.builder(
                                                  itemCount:
                                                      widget.mediaFiles.length,
                                                  pageSnapping: true,
                                                  controller: _pageController,
                                                  onPageChanged: (page) {
                                                    setState(() {
                                                      activePage = page;
                                                    });
                                                  },
                                                  itemBuilder:
                                                      (context, pagePosition) {
                                                    bool active =
                                                        pagePosition ==
                                                            activePage;
                                                    return slider(
                                                        widget.mediaFiles,
                                                        pagePosition,
                                                        active);
                                                  }),
                                            ),
                                            Container(
                                              height: 200,
                                              child: Column(
                                                children: [
                                                  Spacer(),
                                                  Container(
                                                    transform: Matrix4
                                                        .translationValues(
                                                            0.0, -10.0, 0.0),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: indicators(
                                                            widget.mediaFiles
                                                                .length,
                                                            activePage)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  widget.postData
                                          .toString()
                                          .contains("event_name")
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          margin: EdgeInsets.only(top: 7),
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(2),
                                            dashPattern: [1, 1],
                                            color: Colors.grey,
                                            strokeWidth: 2,
                                            child: Card(
                                              color: AppTheme.eveBgColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xFFF1F1F5)),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 5),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                returnEventMonth(widget
                                                                    .postData[
                                                                        "event_start_date"]
                                                                    .toString()),
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFFF0200),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                returnEventDateSeparate(widget
                                                                    .postData[
                                                                        "event_start_date"]
                                                                    .toString()),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        20),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(width: 15),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  widget.postData[
                                                                      "event_name"],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      color: AppTheme
                                                                          .blueColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              Text(
                                                                  returnEventDate(widget
                                                                          .postData[
                                                                              "event_start_date"]
                                                                          .toString()) +
                                                                      "-" +
                                                                      returnEventDate(widget
                                                                          .postData[
                                                                              "event_end_date"]
                                                                          .toString()),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 9,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    color: Color(
                                                                        0xFFB1B1B1),
                                                                  )),
                                                            ],
                                                          )),
                                                          SizedBox(width: 10),
                                                          /* Expanded(child: InkWell(
                                                                       onTap:(){} ,
                                                                       child: Container(
                                                                         decoration: BoxDecoration(color: AppTheme.blueColor),
                                                                         child: Center(
                                                                           child: Text("Interested",
                                                                             style: TextStyle(fontSize: 12,color: Colors.white),),
                                                                         ),
                                                                       ),

                                                                     )),*/
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 7),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            "assets/loc_blue_ic.png",
                                                            width: 13,
                                                            color: AppTheme
                                                                .blueColor,
                                                            height: 13),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                            child: Text(
                                                          widget.postData[
                                                              "address"],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                        ))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    /*Row(
                                                                 children: [
                                                               CircleAvatar(
                                                                     radius: 10,
                                                                     backgroundImage: AssetImage(
                                                                         "assets/dummy_profile.png"),
                                                                   ),
                                                                   SizedBox(width: 10),
                                                                   Expanded(child: Text("27 People Went", style: TextStyle(fontSize: 12,color: Colors.black,),))
                                                                 ],
                                                               )
*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  /*    widget.postData.toString().contains("video")?

                                                    widget.postData["video"].length!=0 ?

                                                    Container(
                                                      height: 200,
                                                      child: Stack(
                                                        children: [

                                                          Container(
                                                            height: 200,
                                                            color: Colors.black,
                                                          ),

                                                          Center(
                                                            child: Icon(Icons.play_arrow_rounded,color: Colors.white,size: 32),
                                                          )




                                                        ],
                                                      ),
                                                    )


                                                        :Container():Container(),*/

                                  SizedBox(height: 9),
                                ],
                              ),
                            ),

                  /*  Container(
                                            height: 200,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        "assets/cricket_dummy.jpg"))),
                                          ),*/

                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ));
  }

  InkWell slider(images, pagePosition, active) {
    double margin = active ? 8 : 8;
    return InkWell(
      onTap: () {
        if (lookupMimeType(images[pagePosition])
            .toString()
            .startsWith('video/')) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FullVideoScreen(images[pagePosition], "")));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageView(images[pagePosition])));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.all(0),
        decoration:
            lookupMimeType(images[pagePosition]).toString().startsWith('video/')
                ? BoxDecoration()
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(images[pagePosition]))),
        child:
            lookupMimeType(images[pagePosition]).toString().startsWith('video/')
                ? VideoWidget(
                    url: images[pagePosition],
                    play: true,
                    loaderColor: AppTheme.themeColor)
                : Container(),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(5),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? AppTheme.themeColor
                : Colors.grey.withOpacity(0.45),
            shape: BoxShape.circle),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 1.0, initialPage: 1);
    print(widget.radioItems);
  }

  repost() async {
    APIDialog.showAlertDialog(context, "Adding Post...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "reportApostOrRepostOrShared",
      "data": {
        "description": addPostController.text,
        "post_id": widget.postData["_id"],
        "action_type": "repost",
        "repost_user": widget.postData["user_id"],
        "is_public": "",
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
        'reportApostOrRepostOrShared', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == "success") {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,"refresh Screen");
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    print(responseJSON);
  }

  String returnEventDate(String date) {
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    var dateTime22 = format.parse(date, true);
    final DateFormat dayFormatter = DateFormat.MMMd();
    String dayAsString = dayFormatter.format(dateTime22);
    return dayAsString;
  }

  String returnEventMonth(String date) {
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    var dateTime22 = format.parse(date, true);
    final DateFormat dayFormatter = DateFormat.MMM();
    String dayAsString = dayFormatter.format(dateTime22);
    return dayAsString;
  }

  String returnEventDateSeparate(String date) {
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    var dateTime22 = format.parse(date, true);
    final DateFormat dayFormatter = DateFormat.d();
    String dayAsString = dayFormatter.format(dateTime22);
    return dayAsString;
  }
}
