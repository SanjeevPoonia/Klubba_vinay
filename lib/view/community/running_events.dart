import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/friend_profile_screen.dart';
import 'package:klubba/view/community/full_video_screen.dart';
import 'package:klubba/view/community/reshare_post.dart';
import 'package:klubba/view/community/view_post.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/widgets/reaction_widget/reaction.dart';
import 'package:klubba/widgets/reaction_widget/reaction_toggle.dart';
import 'package:klubba/widgets/video_widget.dart';
import 'package:mime/mime.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import 'package:page_transition/page_transition.dart';
import 'package:klubba/utils/example_data.dart' as example_data;
import 'package:timeago/timeago.dart' as timeago;

class runingEvents extends StatefulWidget{
  runingEventsState createState()=>runingEventsState();
}
class runingEventsState extends State<runingEvents>{
  bool isLoading=false;
  int selectedMoreIndex=9999;
  List<String> moreList=["Edit Event","Delete Event","Hide Event"];
  List<dynamic> postList=[];
  late PageController _pageController;
  int activePage = 1;
  List<String> selectedValue = [];
  Map<String, dynamic> profileDetails = {};
  @override
  Widget build(BuildContext context) {

    return
      isLoading?
    Center(
      child: Loader(),
    ):ListView(
      children: [
        Padding(padding: EdgeInsets.all(10),
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
              SizedBox(height:10,),
              postList.length==0?

              Container(
                height: 400,
                child: Center(
                  child: Text("No events found!"),
                ),
              ):
              ListView.builder(
                  shrinkWrap: true,
                  //  cacheExtent: 10000,
                  scrollDirection: Axis.vertical,
                  itemCount: postList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int pos) {
                    List<dynamic> mediaFiles = [];

                    List<String> radioItems = [];
                    if (postList[pos]
                        .toString()
                        .contains("repostData")) {
                      if (postList[pos]["repostData"]
                          .toString()
                          .contains("survey_title")) {
                        List<dynamic> options =
                        postList[pos]["repostData"]["options"];
                        for (int i = 0; i < options.length; i++) {
                          radioItems.add(options[i]["choice1"]);
                        }
                      }
                    } else if (postList[pos]
                        .toString()
                        .contains("survey_title")) {
                      List<dynamic> options = postList[pos]["options"];
                      for (int i = 0; i < options.length; i++) {
                        radioItems.add(options[i]["choice1"]);
                      }
                    }

                    if (postList[pos]
                        .toString()
                        .contains("repostData")) {
                      if (postList[pos]["repostData"]
                          .toString()
                          .contains("images")) {
                        mediaFiles =
                        postList[pos]["repostData"]["images"];
                      }

                      if (postList[pos]["repostData"]
                          .toString()
                          .contains("video")) {
                        mediaFiles = mediaFiles +
                            postList[pos]["repostData"]["video"];
                      }
                    } else {
                      if (postList[pos].toString().contains("images")) {
                        mediaFiles = postList[pos]["images"];
                      }
                      if (postList[pos].toString().contains("video")) {
                        mediaFiles =
                            mediaFiles + postList[pos]["video"];
                      }
                    }

                    print("Mdeia Files");

                    print(mediaFiles.toString());

                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color(0xFFF1F1F5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 6,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 6),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendProfileScreen(
                                                    postList[pos][
                                                    "user_id"])));
                                  },
                                  child: Row(
                                    children: [
                                      // assets/dummy_profile.png
                                      postList[pos].toString().contains(
                                          "user_profile_image")
                                          ? CircleAvatar(
                                        radius: 18,
                                        backgroundImage:
                                        NetworkImage(AppConstant
                                            .profileImageURL +
                                            postList[pos][
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
                                              Text(postList[pos]["name"],
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: "Poppins",
                                                      color: AppTheme
                                                          .blueColor,
                                                      fontWeight:
                                                      FontWeight.w500)),
                                              Text(
                                                  timeago.format(DateTime
                                                      .parse(postList[pos]
                                                  ["created_at"])),
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontFamily: "Poppins",
                                                    color:
                                                    Color(0xFFB1B1B1),
                                                  )),
                                            ],
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            postOptionsBottomSheet();
                                          },
                                          child: Image.asset(
                                              "assets/menu_icc.png",
                                              width: 15,
                                              height: 15),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),

                              // Repost Data

                              postList[pos]
                                  .toString()
                                  .contains("repostData")
                                  ? postList[pos]["repostData"]
                                  .toString()
                                  .contains("survey_title")
                                  ? Container(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    postList[pos]
                                        .toString()
                                        .contains(
                                        "description") &&
                                        postList[pos] !=
                                            null
                                        ? Padding(
                                      padding: EdgeInsets
                                          .only(
                                          left: 10,
                                          bottom:
                                          8),
                                      child: Text(
                                          postList[pos][
                                          "description"]
                                              .toString(),
                                          style:
                                          TextStyle(
                                            fontSize:
                                            11.5,
                                            fontFamily:
                                            "Poppins",
                                            color: Colors
                                                .black,
                                          )),
                                    )
                                        : Container(),
                                    Card(
                                      elevation: 3,
                                      margin: EdgeInsets.only(
                                          left: 15,
                                          right: 10),
                                      child: Container(
                                        width: MediaQuery.of(
                                            context)
                                            .size
                                            .width,
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            left: 12,
                                            right: 6),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: 10),
                                            Row(
                                              children: [
                                                // assets/dummy_profile.png
                                                postList[pos][
                                                "repostData"]
                                                    .toString()
                                                    .contains(
                                                    "user_profile_image")
                                                    ? CircleAvatar(
                                                  radius:
                                                  18,
                                                  backgroundImage:
                                                  NetworkImage(AppConstant.profileImageURL + postList[pos]["repostData"]["user_profile_image"]),
                                                )
                                                    : CircleAvatar(
                                                  radius:
                                                  18,
                                                  backgroundImage:
                                                  AssetImage("assets/dummy_profile.png"),
                                                ),
                                                SizedBox(
                                                    width:
                                                    10),
                                                Expanded(
                                                    child:
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                            postList[pos]
                                                            [
                                                            "name"],
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily: "Poppins",
                                                                color: AppTheme.blueColor,
                                                                fontWeight: FontWeight.w500)),
                                                        Text(
                                                            timeago.format(DateTime.parse(postList[pos]["repostData"]
                                                            [
                                                            "created_at"])),
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
                                                    width:
                                                    10),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 5),
                                            Padding(
                                              padding: EdgeInsets
                                                  .only(
                                                  left:
                                                  15),
                                              child: Text(
                                                  postList[pos]
                                                  [
                                                  "repostData"]
                                                  [
                                                  "survey_title"],
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
                                            SizedBox(
                                                height: 5),
                                            ListView.builder(

                                                itemCount:
                                                radioItems
                                                    .length,
                                                shrinkWrap:
                                                true,
                                                scrollDirection:
                                                Axis
                                                    .vertical,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext
                                                context,
                                                    int index22) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      InkWell(
                                                        child:
                                                        Container(
                                                          padding:
                                                          EdgeInsets.symmetric(vertical: 5),
                                                          child:
                                                          Row(
                                                            children: [
                                                              selectedValue.toString().contains(pos.toString() + "," + index22.toString()) ? Icon(Icons.radio_button_on, color: AppTheme.themeColor) : Icon(Icons.radio_button_off),
                                                              SizedBox(width: 5),
                                                              Padding(
                                                                padding: EdgeInsets.only(left: 15),
                                                                child: Text(radioItems[index22],
                                                                    style: TextStyle(
                                                                      fontSize: 11.5,
                                                                      fontFamily: "Poppins",
                                                                      color: Colors.black,
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap:
                                                            () {

                                                        },
                                                      )
                                                    ],
                                                  );
                                                }),
                                            SizedBox(
                                                height: 8),
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                width: MediaQuery.of(context)
                                    .size
                                    .width,
                              )
                                  : Column(
                                children: [
                                  postList[pos]
                                      .toString()
                                      .contains(
                                      "description") &&
                                      postList[pos] !=
                                          null
                                      ? Padding(
                                    padding:
                                    EdgeInsets.only(
                                        left: 10,
                                        bottom: 8),
                                    child: Text(
                                        postList[pos][
                                        "description"]
                                            .toString(),
                                        style:
                                        TextStyle(
                                          fontSize:
                                          11.5,
                                          fontFamily:
                                          "Poppins",
                                          color: Colors
                                              .black,
                                        )),
                                  )
                                      : Container(),
                                  Card(
                                    elevation: 3,
                                    margin: EdgeInsets.only(
                                        left: 15, right: 10),
                                    child: Container(
                                      padding:
                                      const EdgeInsets
                                          .only(
                                          left: 12,
                                          right: 6),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                              height: 10),
                                          Row(
                                            children: [
                                              // assets/dummy_profile.png
                                              postList[pos][
                                              "repostData"]
                                                  .toString()
                                                  .contains(
                                                  "user_profile_image")
                                                  ? CircleAvatar(
                                                radius:
                                                18,
                                                backgroundImage:
                                                NetworkImage(AppConstant.profileImageURL +
                                                    postList[pos]["repostData"]["user_profile_image"]),
                                              )
                                                  : CircleAvatar(
                                                radius:
                                                18,
                                                backgroundImage:
                                                AssetImage("assets/dummy_profile.png"),
                                              ),
                                              SizedBox(
                                                  width: 10),
                                              Expanded(
                                                  child:
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                          postList[pos]
                                                          [
                                                          "name"],
                                                          style: TextStyle(
                                                              fontSize:
                                                              13,
                                                              fontFamily:
                                                              "Poppins",
                                                              color:
                                                              AppTheme.blueColor,
                                                              fontWeight: FontWeight.w500)),
                                                      Text(
                                                          timeago.format(DateTime.parse(postList[pos]["repostData"]
                                                          [
                                                          "created_at"])),
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
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          postList[pos]["repostData"]
                                          [
                                          "description"] !=
                                              "" &&
                                              postList[pos]["repostData"]
                                              [
                                              "description"] !=
                                                  null
                                              ? Row(
                                            children: [
                                              Expanded(
                                                child:
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 15),
                                                  child: Text(
                                                      postList[pos]["repostData"]["description"],
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
                                          postList[pos][
                                          "repostData"]
                                              .toString()
                                              .contains(
                                              "images")
                                              ? postList[pos]["repostData"]["images"]
                                              .length !=
                                              0
                                              ? SizedBox(
                                            //  width: MediaQuery.of(context).size.width,
                                            height:
                                            200,
                                            child: PageView.builder(
                                                itemCount: mediaFiles.length,
                                                pageSnapping: true,
                                                controller: _pageController,
                                                onPageChanged: (page) {
                                                  setState(() {
                                                    activePage = page;
                                                  });
                                                },
                                                itemBuilder: (context, pagePosition) {
                                                  bool active = pagePosition == activePage;
                                                  return slider(mediaFiles, pagePosition, active);
                                                }),
                                          )
                                              : Container()
                                              :

                                          /* postList[pos]["repostData"].toString().contains("video")?

                                                  postList[pos]["repostData"]["video"].length!=0 ?

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


                                                      :Container():*/
                                          Container(),
                                          postList[pos][
                                          "repostData"]
                                              .toString()
                                              .contains(
                                              "event_name")
                                              ? Container(
                                            margin: EdgeInsets
                                                .only(
                                                top:
                                                7),
                                            child:
                                            DottedBorder(
                                              borderType:
                                              BorderType
                                                  .RRect,
                                              radius: Radius
                                                  .circular(
                                                  2),
                                              dashPattern: [
                                                1,
                                                1
                                              ],
                                              color: Colors
                                                  .grey,
                                              strokeWidth:
                                              2,
                                              child:
                                              Card(
                                                color: AppTheme
                                                    .eveBgColor,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(2),
                                                ),
                                                child:
                                                Padding(
                                                  padding:
                                                  EdgeInsets.all(5),
                                                  child:
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(width: 5),

                                                            SizedBox(width: 15),

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
                                                          Image.asset("assets/loc_blue_ic.png", width: 13, color: AppTheme.blueColor, height: 13),
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                              child: Text(
                                                                postList[pos]["repostData"]["address"],
                                                                style: TextStyle(fontSize: 12, color: Colors.black),
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                              )
                                  : postList[pos]
                                  .toString()
                                  .contains("survey_title")
                                  ? Container(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    postList[pos]
                                        .toString()
                                        .contains(
                                        "description") &&
                                        postList[pos] !=
                                            null
                                        ? Padding(
                                      padding: EdgeInsets
                                          .only(
                                          left: 10,
                                          bottom:
                                          8),
                                      child: Text(
                                          postList[pos][
                                          "description"]
                                              .toString(),
                                          style:
                                          TextStyle(
                                            fontSize:
                                            11.5,
                                            fontFamily:
                                            "Poppins",
                                            color: Colors
                                                .black,
                                          )),
                                    )
                                        : Container(),
                                    Container(
                                      width: MediaQuery.of(
                                          context)
                                          .size
                                          .width,
                                      padding:
                                      const EdgeInsets
                                          .only(
                                          left: 12,
                                          right: 6),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                              height: 10),
                                          Padding(
                                            padding: EdgeInsets
                                                .only(
                                                left: 5),
                                            child: Text(
                                                postList[pos][
                                                "survey_title"],
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
                                          SizedBox(height: 5),

                                          /*  RadioGroup<String>.builder(
                                                              groupValue: selectedValue[pos],
                                                              onChanged: (value){
                                                                setState(() {
                                                                  selectedValue[pos] = value.toString().trim();
                                                                });

                                                                print("List values are "+selectedValue.toString());



                                                              },
                                                              items: radioItems,
                                                              itemBuilder: (item) => RadioButtonBuilder(
                                                                item,
                                                              ),
                                                            ),*/

                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount:
                                              radioItems
                                                  .length,
                                              shrinkWrap:
                                              true,
                                              scrollDirection:
                                              Axis
                                                  .vertical,
                                              itemBuilder:
                                                  (BuildContext
                                              context,
                                                  int index22) {
                                                return Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    InkWell(
                                                      child:
                                                      Container(
                                                        padding:
                                                        EdgeInsets.symmetric(vertical: 5),
                                                        child:
                                                        Row(
                                                          children: [
                                                            selectedValue.toString().contains(pos.toString() + "," + index22.toString())
                                                                ? Icon(Icons.radio_button_on, color: AppTheme.themeColor) : Icon(Icons.radio_button_off),
                                                            SizedBox(width: 5),
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 15),
                                                              child: Text(radioItems[index22],
                                                                  style: TextStyle(
                                                                    fontSize: 11.5,
                                                                    fontFamily: "Poppins",
                                                                    color: Colors.black,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap:
                                                          () {
                                                        print("Length of selected List" +
                                                            selectedValue.toString());

                                                        if (selectedValue.length !=
                                                            0) {
                                                          for (int i = 0;
                                                          i < selectedValue.length;
                                                          i++) {
                                                            if (selectedValue[i].substring(0, 1) == pos.toString()) {
                                                              selectedValue.removeAt(i);
                                                            }
                                                          }
                                                        }

                                                        selectedValue.add(pos.toString() +
                                                            "," +
                                                            index22.toString());





                                                        setState(
                                                                () {});

                                                        print(
                                                            "RADI GROUP VALUE");
                                                        print(
                                                            selectedValue.toString());
                                                      },
                                                    )
                                                  ],
                                                );
                                              }),
                                          SizedBox(height: 8),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                      ),
                                    ),
                                  ],
                                ),
                                width: MediaQuery.of(context)
                                    .size
                                    .width,
                              )
                                  : Container(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    SizedBox(height: 8),
                                    postList[pos]["description"] !=
                                        "" &&
                                        postList[pos][
                                        "description"] !=
                                            null
                                        ? Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets
                                              .only(
                                              left:
                                              10),
                                          child: Text(
                                              postList[pos]
                                              [
                                              "description"]
                                                  .toString(),
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
                                    )
                                        : Container(),
                                    SizedBox(height: 5),
                                    mediaFiles.length != 0
                                        ? Stack(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          height: 200,
                                          child: PageView
                                              .builder(
                                              itemCount: mediaFiles
                                                  .length,
                                              pageSnapping:
                                              true,
                                              controller:
                                              _pageController,
                                              onPageChanged:
                                                  (page) {
                                                setState(() {
                                                  activePage = page;
                                                });
                                              },
                                              itemBuilder:
                                                  (context, pagePosition) {
                                                bool
                                                active =
                                                    pagePosition == activePage;
                                                return slider(
                                                    mediaFiles,
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
                                                transform: Matrix4.translationValues(
                                                    0.0,
                                                    -10.0,
                                                    0.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: indicators(mediaFiles.length, activePage)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                        : Container(),
                                    postList[pos]
                                        .toString()
                                        .contains(
                                        "event_name")
                                        ? Container(
                                      padding: EdgeInsets
                                          .only(
                                          left: 15,
                                          right:
                                          15),
                                      margin: EdgeInsets
                                          .only(top: 7),
                                      child:
                                      DottedBorder(
                                        borderType:
                                        BorderType
                                            .RRect,
                                        radius: Radius
                                            .circular(
                                            2),
                                        dashPattern: [
                                          1,
                                          1
                                        ],
                                        color:
                                        Colors.grey,
                                        strokeWidth: 2,
                                        child: Card(
                                          color: AppTheme
                                              .eveBgColor,
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(2),
                                          ),
                                          child:
                                          Padding(
                                            padding:
                                            EdgeInsets
                                                .all(5),
                                            child:
                                            Column(
                                              children: [
                                                Container(
                                                  decoration:
                                                  BoxDecoration(color: Color(0xFFF1F1F5)),
                                                  child:
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 5),

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
                                                SizedBox(
                                                    height:
                                                    7),
                                                Row(
                                                  children: [
                                                    Image.asset("assets/loc_blue_ic.png",
                                                        width: 13,
                                                        color: AppTheme.blueColor,
                                                        height: 13),
                                                    SizedBox(width: 5),
                                                    Expanded(
                                                        child: Text(
                                                          postList[pos]["address"],
                                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                                        ))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height:
                                                  5,
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

                                    /*    postList[pos].toString().contains("video")?

                                                    postList[pos]["video"].length!=0 ?

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

                              Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 5),
                                child: Divider(),
                              ),
                              postList[pos]["like"].length == 0
                                  ? Container()
                                  : Row(
                                children: [
                                  SizedBox(width: 15),

                                  /*  Image.asset(
                                                  "assets/heart_red.png",
                                                  width: 14,
                                                  height: 14),*/

                                  Container(
                                    height: 15,
                                    child: ListView.builder(
                                        itemCount: postList[pos]
                                        ["like"]
                                            .length,
                                        scrollDirection:
                                        Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context,
                                            int pos22) {
                                          bool showEmojis = true;

                                          String currentEmoji =
                                          postList[pos]
                                          ["like"]
                                          [pos22]
                                          ["liked_type"];

                                          if (postList[pos]
                                          ["like"]
                                              .length >
                                              1) {
                                            print(
                                                pos22.toString());
                                            for (int i =
                                                pos22 - 1;
                                            i >= 0;
                                            i--) {
                                              if (postList[pos][
                                              "like"][i]
                                              [
                                              "liked_type"] ==
                                                  currentEmoji) {
                                                showEmojis =
                                                false;
                                                break;
                                              }
                                            }
                                          }

                                          return !showEmojis
                                              ? Container()
                                              : Align(
                                            widthFactor:
                                            0.7,
                                            child: Image.asset(
                                                postList[pos]["like"][pos22]["liked_type"] == "heart_emoji_count"
                                                    ? "assets/heart.png"
                                                    : postList[pos]["like"][pos22]["liked_type"] == "thumb_emoji_count"
                                                    ? 'assets/thumbs_up.png'
                                                    : postList[pos]["like"][pos22]["liked_type"] == "wow_emoji_count"
                                                    ? 'assets/wow.png'
                                                    : postList[pos]["like"][pos22]["liked_type"] == "sad_emoji_count"
                                                    ? 'assets/sad.png'
                                                    : postList[pos]["like"][pos22]["liked_type"] == "laugh_emoji_count"
                                                    ? 'assets/laughing.png'
                                                    : postList[pos]["like"][pos22]["liked_type"] == "namaste_emoji_count"
                                                    ? 'assets/namaste.png'
                                                    : "",
                                                width: 14,
                                                height: 14),
                                          );
                                        }),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                      "Liked by " +
                                          postList[pos]["like"]
                                              .length
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              SizedBox(height: 14),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        /* Image.asset(
                                                        "assets/heart_ic.png",
                                                        width: 17,
                                                        height: 17),*/

                                        postList[pos]["selfLikes"]
                                            .length !=
                                            0
                                            ? GestureDetector(
                                          child: Image.asset(
                                            postList[pos]["selfLikes"]
                                            [0][
                                            "liked_type"] ==
                                                "heart_emoji_count"
                                                ? "assets/heart.png"
                                                : postList[pos]["selfLikes"]
                                            [0][
                                            "liked_type"] ==
                                                "thumb_emoji_count"
                                                ? 'assets/thumbs_up.png'
                                                : postList[pos]["selfLikes"][0][
                                            "liked_type"] ==
                                                "wow_emoji_count"
                                                ? 'assets/wow.png'
                                                : postList[pos]["selfLikes"][0]["liked_type"] ==
                                                "sad_emoji_count"
                                                ? 'assets/sad.png'
                                                : postList[pos]["selfLikes"][0]["liked_type"] == "laugh_emoji_count"
                                                ? 'assets/laughing.png'
                                                : postList[pos]["selfLikes"][0]["liked_type"] == "namaste_emoji_count"
                                                ? 'assets/namaste.png'
                                                : "",
                                            width: 18,
                                            height: 18,
                                          ),
                                          onTap: () {
                                            likePost(
                                                postList[pos]
                                                ["_id"],
                                                postList[pos][
                                                "selfLikes"][0]
                                                [
                                                "liked_type"],
                                                "unlike",
                                                pos);
                                          },
                                        )
                                            : ReactionButtonToggle<
                                            String>(
                                          onReactionChanged:
                                              (String? value,
                                              bool
                                              isChecked) {
                                            debugPrint(
                                                'Selected value: $value, isChecked: $isChecked');

                                            print(value);

                                            if (value == null) {
                                              likePost(
                                                  postList[pos]
                                                  ["_id"],
                                                  postList[pos][
                                                  "selfLikes"][0]
                                                  [
                                                  "liked_type"],
                                                  "unlike",
                                                  pos);
                                            } else {
                                              likePost(
                                                  postList[pos]
                                                  ["_id"],
                                                  value
                                                      .toString(),
                                                  "like",
                                                  pos);
                                            }
                                          },

                                          reactions: example_data
                                              .reactions,
                                          initialReaction:
                                          Reaction<String>(
                                            value: null,
                                            icon: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(0.0),
                                              child: Image.asset(
                                                "assets/heart_ic.png",
                                                width: 18,
                                                height: 18,
                                              ),
                                            ),
                                          ),
                                          // selectedReaction: Example.reactions[1],

                                          boxDuration:
                                          const Duration(
                                              milliseconds:
                                              400),
                                          itemScaleDuration:
                                          const Duration(
                                              milliseconds:
                                              200),
                                          boxPadding:
                                          EdgeInsets.all(5),
                                          //  boxColor: Colors.redAccent.withOpacity(0.5),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                            postList[pos]["like"]
                                                .length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight:
                                              FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .bottomToTop,
                                                child: ViewPostScreen(
                                                    postList[pos],
                                                    mediaFiles,
                                                    AppConstant
                                                        .profileImageURL +
                                                        profileDetails[
                                                        "profile_image"])));
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/comments.png",
                                              width: 17,
                                              height: 17),
                                        /*  SizedBox(width: 5),
                                          Text(
                                              postList[pos][
                                              "is_comment_count"]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: Colors.black,
                                              )),*/
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResharePostWidget(
                                                        profileDetails[
                                                        "full_name"],
                                                        AppConstant
                                                            .profileImageURL +
                                                            profileDetails[
                                                            "profile_image"],
                                                        postList[pos],
                                                        mediaFiles,radioItems)));
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/repost_ic.png",
                                              width: 17,
                                              height: 17),
                                          SizedBox(width: 5),
                                          Text("4",
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                            "assets/share_ic.png",
                                            width: 17,
                                            height: 17),
                                        SizedBox(width: 5),
                                        /*  Text("14",
                                           style: TextStyle(
                                             fontSize: 11.5,
                                             fontWeight:
                                             FontWeight.w500,
                                             color: Colors.black,
                                           )),*/
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    );
                  }),


            ],
          ),
        ),
      ],
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 1.0, initialPage: 1);
    fetchPosts();
    fetchProfileDetails();
  }
  postOptionsBottomSheet() {
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
                                Text('Select Filter',
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
                          itemCount: moreList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context,int pos)
                          {
                            return Column(

                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [

                                      selectedMoreIndex==pos?
                                      Icon(Icons.radio_button_on,color: AppTheme.themeColor):
                                      GestureDetector(
                                        child: Icon(Icons.radio_button_off),
                                        onTap: (){
                                          dialogState(() {
                                            selectedMoreIndex=pos;
                                          });
                                        },


                                      ),





                                      SizedBox(width: 5),



                                      Text(
                                        moreList[pos],
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
                          }



                      ),





                      SizedBox(height: 27),
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

  fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getAllPostForUser",
      "data": {
        "page": 1,
        "limit": 10,
        "post_type":"event",
        "search_type":"",
        "slug": AppModel.slug,
        "event_type":"running",
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by":id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('getAllPostForUser', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    if(responseJSON['decodedData']['message']!="No post available")
      {
        postList = responseJSON['decodedData']['result']['allPost'];
      }


    setState(() {});
    print(responseJSON);
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
  likePost(String postID, String emojiType, String type, int pos) async {
    if (type == "like") {
      if (postList[pos]["selfLikes"].length == 0) {
        postList[pos]["selfLikes"].add({
          "_id": "64b63c6e2e5ef2592a7d6c55",
          "post_id": postID,
          "user_id": "61b9c5c64e85c44c9df8fa93",
          "liked_type": emojiType,
          "status": 1,
          "created_at": "2023-07-18T07:17:02.890Z",
          "updated_at": "2023-07-18T07:17:02.890Z"
        });
      } else {
        postList[pos]["selfLikes"][0] = {
          "_id": "64b63c6e2e5ef2592a7d6c55",
          "post_id": postID,
          "user_id": "61b9c5c64e85c44c9df8fa93",
          "liked_type": emojiType,
          "status": 1,
          "created_at": "2023-07-18T07:17:02.890Z",
          "updated_at": "2023-07-18T07:17:02.890Z"
        };
      }
    } else if (type == "unlike") {
      postList[pos]["selfLikes"].removeAt(0);
    }

    setState(() {});

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "manageNewLikeRecord",
      "data": {
        "user_id": id,
        "post_id": postID,
        "liked_type": emojiType,
        "new_liked_type": emojiType,
        "type": type,
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
        'manageNewLikeRecord', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']["status"] == "success") {}
    setState(() {});
    print(responseJSON);
  }
  fetchProfileDetails() async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "userProfileDetails",
      "data": {
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
        'userProfileDetails', requestModel, context);
    var responseJSON = json.decode(response.body);
    profileDetails = responseJSON['decodedData']['result'];
    setState(() {});
    print(responseJSON);
  }
}