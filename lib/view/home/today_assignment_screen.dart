import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/planner/assignment_detail_screen.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/view/digital_library/pdf_view_screen.dart';
import 'package:klubba/view/digital_library/vimeo_player_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

class TodayAssignmentScreen extends StatefulWidget {
  final int tabIndex;

  TodayAssignmentScreen(this.tabIndex);

  TodayState createState() => TodayState();
}

class TodayState extends State<TodayAssignmentScreen> {
  int selectedTabIndex = 0;
  int selectedTab = 1;
  String startDate = "";
  String endDate = "";
  List<dynamic> dataList = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                text: 'Today\'s ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Assignments',
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
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 0
                              ? AppTheme.themeColor
                              : Color(0xFFFFFAEA),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Lottie.asset("assets/dashboard_1.json"),
                            Text('School',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: selectedTabIndex == 0
                                        ? Colors.white
                                        : AppTheme.themeColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    flex: 1),
                SizedBox(width: 10),
                Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 1
                              ? AppTheme.themeColor
                              : Color(0xFFFFFAEA),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Lottie.asset("assets/dashboard_2.json"),
                            Expanded(
                              child: Text('Academy / Coach',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: selectedTabIndex == 1
                                          ? Colors.white
                                          : AppTheme.themeColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    flex: 1),
              ],
            ),
          ),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = 2;
                        });
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 2
                              ? AppTheme.themeColor
                              : Color(0xFFFFFAEA),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Lottie.asset("assets/dashboard_3.json"),
                            Text('Klubba',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: selectedTabIndex == 2
                                        ? Colors.white
                                        : AppTheme.themeColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    flex: 1),
                SizedBox(width: 10),
                Expanded(
                    child:

                    Container(),


                    /*Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: selectedTabIndex == 3
                            ? AppTheme.themeColor
                            : Color(0xFFFFFAEA),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 6,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/dashboard_4.json"),
                          SizedBox(width: 15),
                          Text('Self',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: selectedTabIndex == 3
                                      ? Colors.white
                                      : AppTheme.themeColor,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),*/
                    flex: 1),
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(child:
          isLoading ?
          Center(
            child: Loader(),
          ) :


          ListView(children: [

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
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
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: selectedTab == 1
                                        ? AppTheme.themeColor
                                        : Color(0xFFF3F3F3)),
                                child: Row(
                                  children: [
                                    Image.asset('assets/skill_ic.png',
                                        width: 21, height: 18.17),
                                    SizedBox(width: 5),
                                    Text('Skill Set',
                                        style: TextStyle(
                                            color: selectedTab == 1
                                                ? Colors.black
                                                : Color(0xFF9A9CB8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.5)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedTab = 1;
                                });
                                fetchTodayCalender(context, "skill-set");
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedTab = 2;
                                });

                                fetchTodayCalender(context, "fitness");
                              },
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: selectedTab == 2
                                        ? AppTheme.themeColor
                                        : Color(0xFFF3F3F3)),
                                child: Row(
                                  children: [
                                    Image.asset('assets/fitness_ic.png',
                                        width: 22, height: 18.17),
                                    SizedBox(width: 5),
                                    Text('Fitness',
                                        style: TextStyle(
                                            color: selectedTab == 2
                                                ? Colors.black
                                                : Color(0xFF9A9CB8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.5)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedTab = 3;
                                });

                                fetchTodayCalender(context, "nutrition");
                              },
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: selectedTab == 3
                                        ? AppTheme.themeColor
                                        : Color(0xFFF3F3F3)),
                                child: Row(
                                  children: [
                                    Image.asset('assets/nutrition_ic.png',
                                        width: 22, height: 18.17),
                                    SizedBox(width: 5),
                                    Text('Nutrition',
                                        style: TextStyle(
                                            color: selectedTab == 3
                                                ? Colors.black
                                                : Color(0xFF9A9CB8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.5)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    dataList.length==0?


                        Container(
                          height: 120,
                          child: Center(
                            child: Text("No assignments available!"),
                          ),
                        ):



                    ListView.builder(
                        itemCount: dataList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int pos) {
                          return

                            selectedTabIndex == 0 ?

                            dataList[pos]['created_by'] == 'school' && dataList[pos]["is_completed"]!=2 ?
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFfF6F6F6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text('Title',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 12)),
                                                  SizedBox(height: 3),
                                                  Text(dataList[pos]["title"],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize: 14)),
                                                ],
                                              )),
                                         /* Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              Text('Reminder',
                                                  style: TextStyle(
                                                      color: AppTheme.blueColor,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 12)),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.alarm,
                                                    color: AppTheme.blueColor,
                                                    size: 13,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text('01:00 PM',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Text('Instructions, Example',
                                          style: TextStyle(
                                              color: AppTheme.blueColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      SizedBox(height: 3),
                                      Text(
                                          dataList[pos]['activities'][0]['description'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                      SizedBox(height: 15),
                                      Row(
                                          children: [
                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "video" &&
                                                dataList[pos]['activities'][0]['attchement']
                                                    .isNotEmpty ?
                                            GestureDetector(
                                              onTap: () {
                                                if (dataList[pos]['activities'][0]['attchement']
                                                    .toString()
                                                    .contains("video_url")) {
                                                  String videoID = dataList[pos]['activities'][0]['attchement']['video_url']
                                                      .split('/')
                                                      .last;
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VimeoPlayer22(
                                                                  videoID)));
                                                }
                                                else {
                                                  fetchLibraryByID(
                                                      dataList[pos]["program_id"],
                                                      "video",pos);
                                                }
                                              },

                                              child: Image.asset(
                                                  'assets/play_ic.png',
                                                  width: 32, height: 32),
                                            ) :

                                            Image.asset(
                                                'assets/play_ic.png',
                                                width: 32,
                                                height: 32,
                                                color: Colors.grey),

                                            SizedBox(width: 10),
                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "pdf" &&
                                                dataList[pos]['activities'][0]['attchement_pdf']
                                                    .isNotEmpty ?
                                            GestureDetector(
                                              onTap: () {
                                                print("Tap Triggered");

                                                fetchLibraryByID(
                                                    dataList[pos]["program_id"],
                                                    "pdf",pos);
                                              },
                                              child: Image.asset(
                                                  'assets/title2.png',
                                                  width: 32,
                                                  height: 32,
                                                  color: AppTheme.blueColor),
                                            ) :

                                            Image.asset('assets/title2.png',
                                                width: 32, height: 32),
                                            SizedBox(width: 10),

                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "image" &&
                                                dataList[pos]['activities'][0]['attchement_image']
                                                    .isNotEmpty ?

                                            GestureDetector(
                                              child: Image.asset(
                                                  'assets/title3.png',
                                                  width: 32,
                                                  height: 32,
                                                  color: AppTheme.blueColor),
                                              onTap: () {
                                                fetchLibraryByID(
                                                    dataList[pos]["program_id"],
                                                    "image",pos);
                                              },
                                            ) :

                                            Image.asset('assets/title3.png',
                                                width: 32, height: 32),

                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AssignmentDetailScreen(
                                                                startDate,
                                                                dataList[pos],
                                                                false,"view")));
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blueColor,
                                                  borderRadius: BorderRadius
                                                      .circular(27),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text('VIEW',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            fontSize: 14)),
                                                    SizedBox(width: 5),
                                                    Icon(Icons
                                                        .arrow_forward_ios_rounded,
                                                        color: Colors.white,
                                                        size: 15)
                                                  ],
                                                ),
                                              ),
                                            )


                                          ]),

                                    ],
                                  ),

                                ),

                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          height: 50,
                                          child: ElevatedButton(
                                              child: Text('Mark As Missed',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Color(0xFFFF0038)),
                                                  shape: MaterialStateProperty
                                                      .all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {
                                                markEvent(context, 1,
                                                    dataList[pos]["_id"]);
                                              }),
                                        ),
                                        flex: 1),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Container(
                                          height: 50,
                                          child: ElevatedButton(
                                              child: Text('Mark As Complete',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Color(0xFF1D963A)),
                                                  shape: MaterialStateProperty
                                                      .all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {
                                                markEvent(context, 2,
                                                    dataList[pos]["_id"]);
                                              }),
                                        ),
                                        flex: 1),
                                  ],
                                )


                              ],
                            ) :

                            Container() :


                            selectedTabIndex == 1 ?

                            dataList[pos]['created_by'] == 'coach' && dataList[pos]["is_completed"]!=2 ?

                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFfF6F6F6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text('Title',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 12)),
                                                  SizedBox(height: 3),
                                                  Text(dataList[pos]["title"],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize: 14)),
                                                ],
                                              )),
                                       /*   Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              Text('Reminder',
                                                  style: TextStyle(
                                                      color: AppTheme.blueColor,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 12)),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.alarm,
                                                    color: AppTheme.blueColor,
                                                    size: 13,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text('01:00 PM',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Text('Instructions, Example',
                                          style: TextStyle(
                                              color: AppTheme.blueColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      SizedBox(height: 3),
                                      Text(
                                          dataList[pos]['activities'][0]['description'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                      SizedBox(height: 15),
                                      Row(
                                          children: [
                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "video" &&
                                                dataList[pos]['activities'][0]['attchement']
                                                    .isNotEmpty ?
                                            GestureDetector(
                                              onTap: () {
                                                if (dataList[pos]['activities'][0]['attchement']
                                                    .toString()
                                                    .contains("video_url")) {
                                                  String videoID = dataList[pos]['activities'][0]['attchement']['video_url']
                                                      .split('/')
                                                      .last;
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VimeoPlayer22(
                                                                  videoID)));
                                                }
                                                else {
                                                  fetchLibraryByID(
                                                      dataList[pos]["program_id"],
                                                      "video",pos);
                                                }
                                              },

                                              child: Image.asset(
                                                  'assets/play_ic.png',
                                                  width: 32, height: 32),
                                            ) :

                                            Image.asset(
                                                'assets/play_ic.png',
                                                width: 32,
                                                height: 32,
                                                color: Colors.grey),

                                            SizedBox(width: 10),
                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "pdf" &&
                                                dataList[pos]['activities'][0]['attchement_pdf']
                                                    .isNotEmpty ?
                                            GestureDetector(
                                              onTap: () {
                                                print("Tap Triggered");

                                                fetchLibraryByID(
                                                    dataList[pos]["program_id"],
                                                    "pdf",pos);
                                              },
                                              child: Image.asset(
                                                  'assets/title2.png',
                                                  width: 32,
                                                  height: 32,
                                                  color: AppTheme.blueColor),
                                            ) :

                                            Image.asset('assets/title2.png',
                                                width: 32, height: 32),
                                            SizedBox(width: 10),

                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "image" &&
                                                dataList[pos]['activities'][0]['attchement_image']
                                                    .isNotEmpty ?

                                            GestureDetector(
                                              child: Image.asset(
                                                  'assets/title3.png',
                                                  width: 32,
                                                  height: 32,
                                                  color: AppTheme.blueColor),
                                              onTap: () {
                                                fetchLibraryByID(
                                                    dataList[pos]["program_id"],
                                                    "image",pos);
                                              },
                                            ) :

                                            Image.asset('assets/title3.png',
                                                width: 32, height: 32),

                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AssignmentDetailScreen(
                                                                startDate,
                                                                dataList[pos],
                                                                false,"view")));
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blueColor,
                                                  borderRadius: BorderRadius
                                                      .circular(27),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text('VIEW',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            fontSize: 14)),
                                                    SizedBox(width: 5),
                                                    Icon(Icons
                                                        .arrow_forward_ios_rounded,
                                                        color: Colors.white,
                                                        size: 15)
                                                  ],
                                                ),
                                              ),
                                            )


                                          ]),

                                    ],
                                  ),

                                ),

                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          height: 50,
                                          child: ElevatedButton(
                                              child: Text('Mark As Missed',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Color(0xFFFF0038)),
                                                  shape: MaterialStateProperty
                                                      .all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {
                                                markEvent(context, 1,
                                                    dataList[pos]["_id"]);
                                              }),
                                        ),
                                        flex: 1),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Container(
                                          height: 50,
                                          child: ElevatedButton(
                                              child: Text('Mark As Complete',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Color(0xFF1D963A)),
                                                  shape: MaterialStateProperty
                                                      .all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {
                                                markEvent(context, 2,
                                                    dataList[pos]["_id"]);
                                              }),
                                        ),
                                        flex: 1),
                                  ],
                                )


                              ],
                            ) :
                            Container() :


                            selectedTabIndex == 2 ?

                            dataList[pos]['created_by'] == 'TMP' && dataList[pos]["is_completed"]!=2?


                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFfF6F6F6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text('Title',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 12)),
                                                  SizedBox(height: 3),
                                                  Text(dataList[pos]["title"],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize: 14)),
                                                ],
                                              )),
                                         /* Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              Text('Reminder',
                                                  style: TextStyle(
                                                      color: AppTheme.blueColor,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 12)),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.alarm,
                                                    color: AppTheme.blueColor,
                                                    size: 13,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text('01:00 PM',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ],
                                          )*/
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Text('Instructions, Example',
                                          style: TextStyle(
                                              color: AppTheme.blueColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      SizedBox(height: 3),
                                      Text(
                                          dataList[pos]['activities'][0]['description'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                      SizedBox(height: 15),
                                      Row(
                                          children: [
                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "video" &&
                                                dataList[pos]['activities'][0]['attchement']
                                                    .isNotEmpty ?
                                            GestureDetector(
                                              onTap: () {
                                                if (dataList[pos]['activities'][0]['attchement']
                                                    .toString()
                                                    .contains("video_url")) {
                                                  String videoID = dataList[pos]['activities'][0]['attchement']['video_url']
                                                      .split('/')
                                                      .last;
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VimeoPlayer22(
                                                                  videoID)));
                                                }
                                                else {
                                                  fetchLibraryByID(
                                                      dataList[pos]["program_id"],
                                                      "video",pos);
                                                }
                                              },

                                              child: Image.asset(
                                                  'assets/play_ic.png',
                                                  width: 32, height: 32),
                                            ) :

                                            Image.asset(
                                                'assets/play_ic.png',
                                                width: 32,
                                                height: 32,
                                                color: Colors.grey),

                                            SizedBox(width: 10),
                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "pdf" &&
                                                dataList[pos]['activities'][0]['attchement_pdf']
                                                    .isNotEmpty ?
                                            GestureDetector(
                                              onTap: () {
                                                print("Tap Triggered");

                                                fetchLibraryByID(
                                                    dataList[pos]["program_id"],
                                                    "pdf",pos);
                                              },
                                              child: Image.asset(
                                                  'assets/title2.png',
                                                  width: 32,
                                                  height: 32,
                                                  color: AppTheme.blueColor),
                                            ) :

                                            Image.asset('assets/title2.png',
                                                width: 32, height: 32),
                                            SizedBox(width: 10),

                                            dataList[pos]['activities'][0]['attachment_type'] ==
                                                "image" &&
                                                dataList[pos]['activities'][0]['attchement_image']
                                                    .isNotEmpty ?

                                            GestureDetector(
                                              child: Image.asset(
                                                  'assets/title3.png',
                                                  width: 32,
                                                  height: 32,
                                                  color: AppTheme.blueColor),
                                              onTap: () {
                                                fetchLibraryByID(
                                                    dataList[pos]["program_id"],
                                                    "image",pos);
                                              },
                                            ) :

                                            Image.asset('assets/title3.png',
                                                width: 32, height: 32),

                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AssignmentDetailScreen(
                                                                startDate,
                                                                dataList[pos],
                                                                false,"view")));
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.blueColor,
                                                  borderRadius: BorderRadius
                                                      .circular(27),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text('VIEW',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            fontSize: 14)),
                                                    SizedBox(width: 5),
                                                    Icon(Icons
                                                        .arrow_forward_ios_rounded,
                                                        color: Colors.white,
                                                        size: 15)
                                                  ],
                                                ),
                                              ),
                                            )


                                          ]),

                                    ],
                                  ),

                                ),

                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Center(
                                        child: Container(
                                          height: 50,
                                          child: ElevatedButton(
                                              child: Text('Mark As Complete',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Color(0xFF1D963A)),
                                                  shape: MaterialStateProperty
                                                      .all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {
                                                markEvent(context, 2,
                                                    dataList[pos]["_id"]);
                                              }),
                                        ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(child: Container(),flex: 1),


                                  /*  Expanded(
                                        child:
                                        dataList[pos]["is_completed"]==1?Container():

                                        Container(
                                          height: 50,
                                          child: ElevatedButton(
                                              child: Text('Mark As Missed',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                      Color(0xFFFF0038)),
                                                  shape: MaterialStateProperty
                                                      .all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {
                                                markEvent(context, 1,
                                                    dataList[pos]["_id"]);
                                              }),
                                        ),
                                        flex: 1),*/


                                  ],
                                ),

                                SizedBox(height: 15),
                              ],
                            ) :
                            Container() :


                            Container()


                          ;
                        }),

                    SizedBox(height: 15)


                  ]
              ),
            ),

          ],))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTabIndex = widget.tabIndex;
    startDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    endDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fetchTodayCalender(context, "skill-set");
  }

  fetchTodayCalender(BuildContext context, String type) async {
    if (dataList.length != 0) {
      dataList.clear();
    }
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getMyCalendar",
      "data": {
        "end_date": startDate,
        "start_date": endDate,
        "type": [type],
        "category_id": catId,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    isLoading = false;
    dataList = responseJSON['decodedData']['result'];
    setState(() {});
  }

  markEvent(BuildContext context, int operation, String id22) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    var data = {
      "method_name": "markCompleteCalendarEvent",
      "data": {
        "calendar_token": id22,
        "is_completed": operation == 1 ? 1 : 2,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'markCompleteCalendarEvent', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      if (operation == 1) {
        fetchTodayCalender(context, "skill-set");
        Toast.show('Successfully marked as missed !!',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
      else {
        Toast.show('Successfully marked as complete !!',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.greenAccent);
        fetchTodayCalender(context, "skill-set");

      }
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }

  fetchLibraryByID(String libraryID, String type,int poss) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    var data = {
      "method_name": "getDigitalLibraryById",
      "data": {
        "id": libraryID,
        "index":poss,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getDigitalLibraryById', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    Map<String, dynamic> libraryData = responseJSON['decodedData']['result'][0];
    if (type == "video") {
      String videoID = libraryData['library_video_url']
          .split('/')
          .last;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => VimeoPlayer22(videoID)));
    }
    else if (type == "pdf") {
      //Check base url path
      print("PDF");
      String pdfUrl = AppConstant.digitalLibraryStagingBaseURL +
          libraryData['digital_library_path'] + "/" +
          libraryData['images'][0]['image'];
      print("PDF URL Is " + pdfUrl);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PDFView(pdfUrl)));
    }
    else {
      String imageUrl = AppConstant.digitalLibraryStagingBaseURL +
          libraryData['digital_library_path'] + "/" +
          libraryData['images'][0]['image'];
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImageView(imageUrl)));
    }
  }
}
