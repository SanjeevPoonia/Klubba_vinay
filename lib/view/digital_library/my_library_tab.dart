import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/utils/filter_modal.dart';
import 'package:klubba/view/digital_library/add_video_screen.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/view/digital_library/library_tab.dart';
import 'package:klubba/view/digital_library/pdf_view_screen.dart';
import 'package:klubba/view/digital_library/vimeo_player_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

class MyLibraryTab extends StatefulWidget {
  final bool filterApplied;
  final bool categoryFilterApplied;


  MyLibraryTab(this.filterApplied,this.categoryFilterApplied);

  MyLibraryState createState() => MyLibraryState();
}

class MyLibraryState extends State<MyLibraryTab> {
  int selectedTabIndex = 1;
  int selectedRadioIndex = 0;
  bool isLoading = false;
  List<dynamic> videosList = [];
  List<dynamic> pdfList = [];
  List<dynamic> imageList = [];
  List<dynamic> trendingVideos = [];
  String academyBaseUrl = '';

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return isLoading
        ? Center(
            child: Loader(),
          )
        : ListView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = 1;
                          });
                        },
                        child: Container(
                          height: 47,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: selectedTabIndex == 1
                                  ? AppTheme.themeColor
                                  : Color(0xFFF6F6F6)),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              SizedBox(
                                height: 50,
                                child: Lottie.asset(
                                    'assets/library1_animation.json'),
                              ),
                              SizedBox(width: 5),
                              Container(
                                transform:
                                    Matrix4.translationValues(-10.0, 0.0, 0.0),
                                child: Text('Video',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      flex: 1),
                  SizedBox(width: 7),
                  Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = 2;
                          });
                          fetchDigitalLibraryImages(context, 'image');
                        },
                        child: Container(
                          height: 47,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: selectedTabIndex == 2
                                  ? AppTheme.themeColor
                                  : Color(0xFFF6F6F6)),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              SizedBox(
                                height: 50,
                                child: Lottie.asset(
                                    'assets/library2_animation.json'),
                              ),
                              SizedBox(width: 5),
                              Container(
                                transform:
                                    Matrix4.translationValues(-10.0, 0.0, 0.0),
                                child: Text('Image',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      flex: 1),
                  SizedBox(width: 7),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = 3;
                        });
                        fetchPDFFiles(context, 'pdf');
                      },
                      child: Container(
                        height: 47,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedTabIndex == 3
                                ? AppTheme.themeColor
                                : Color(0xFFF6F6F6)),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            SizedBox(
                              height: 50,
                              child: Lottie.asset(
                                  'assets/library3_animation.json'),
                            ),
                            SizedBox(width: 5),
                            Container(
                              transform:
                                  Matrix4.translationValues(-10.0, 0.0, 0.0),
                              child: Text('PDF',
                                  style: TextStyle(
                                      color: AppTheme.blueColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
              selectedTabIndex == 1
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('Recent ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.5)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text('Video',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.5)),
                                  Container(
                                    width: 35,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: AppTheme.themeColor),
                                  )
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddLibraryScreen("video")));
                                },
                                child: Image.asset(
                                  'assets/add_black_ic.png',
                                  width: 32,
                                  height: 32,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          trendingVideos.length != 0
                              ? trendingVideos[0]['video_thumb'] != null
                                  ? Container(
                                      height: 200,
                                      width: double.infinity,
                                      child: Container(
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    trendingVideos[0]
                                                        ['video_thumb']))),
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/video_ic.png'),
                                                    fit: BoxFit.cover)),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.play_circle_fill,
                                              color: AppTheme.themeColor,
                                              size: 65,
                                            )),
                                          ),
                                        ],
                                      ))
                              : Center(
                                  child: Text('No data found'),
                                ),
                          trendingVideos.length != 0
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 15),
                                  width: double.infinity,
                                  color: AppTheme.greyColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        transform: Matrix4.translationValues(
                                            0.0, -25.0, 0.0),
                                        height: 50,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 25),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: AppTheme.themeColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset('assets/player1.png',
                                                width: 15, height: 15),
                                            Image.asset('assets/player2.png',
                                                width: 12, height: 12),
                                            Image.asset('assets/player3.png',
                                                width: 15, height: 15),
                                            Image.asset('assets/player4.png',
                                                width: 12, height: 12),
                                            Image.asset('assets/player5.png',
                                                width: 15, height: 15),
                                          ],
                                        ),
                                      ),
                                      Text(trendingVideos[0]['category_name'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.blueColor)),
                                      SizedBox(height: 3),
                                      Text(trendingVideos[0]['title'],
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  'assets/person_ic.png',
                                                  width: 13,
                                                  height: 13),
                                              SizedBox(width: 5),
                                              Text(
                                                  trendingVideos[0]
                                                          ['user_name'] ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Image.asset('assets/calendar.png',
                                                  width: 13, height: 13),
                                              SizedBox(width: 5),
                                              Text(
                                                  trendingVideos[0]
                                                      ['created_at'],
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Image.asset('assets/eye_ic.png',
                                                  width: 13, height: 13),
                                              SizedBox(width: 5),
                                              Text(
                                                  trendingVideos[0]
                                                              ['view_count']
                                                          .toString() +
                                                      ' Views',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black)),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('Up ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.5)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text('Next',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.5)),
                                  Container(
                                    width: 35,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: AppTheme.themeColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          ListView.builder(
                              itemCount: videosList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int pos) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: AppTheme.greyColor),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    height: 67,
                                                    width: 105,
                                                    child: videosList[pos]
                                                                ['video_thumb'] !=
                                                            null
                                                        ? Stack(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: NetworkImage(
                                                                            videosList[pos]
                                                                                [
                                                                                'video_thumb']))),
                                                              ),
                                                              Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .play_circle,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 25),
                                                              )
                                                            ],
                                                          )
                                                        : Container(
                                                            height: 67,
                                                            width: 105,
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height: 67,
                                                                  width: 105,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(
                                                                              'assets/video_ic.png'),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                  ),
                                                                  child: Center(
                                                                      child: Icon(
                                                                    Icons
                                                                        .play_circle_fill,
                                                                    color: AppTheme
                                                                        .themeColor,
                                                                    size: 27,
                                                                  )),
                                                                ),
                                                              ],
                                                            ))),
                                                SizedBox(width: 10),
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              videosList[pos]
                                                                  ['category_name'],
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppTheme
                                                                      .blueColor)),
                                                          Spacer(),
                                                          /*    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedRadioIndex = pos;
                                                          });
                                                        },
                                                        child: selectedRadioIndex ==
                                                            pos
                                                            ? Icon(
                                                            Icons
                                                                .radio_button_checked,
                                                            color: AppTheme
                                                                .themeColor)
                                                            : Icon(Icons
                                                            .radio_button_off)),*/

                                                          GestureDetector(
                                                            onTap: (){

                                                              showDeleteDialog(videosList[pos]["_id"], "video");
                                                            },
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        right: 5),
                                                                child: Image.asset(
                                                                    'assets/delete_ic.png',
                                                                    height: 20,
                                                                    width: 16)),
                                                          ),
                                                          SizedBox(width: 8)
                                                        ],
                                                      ),
                                                      Text(videosList[pos]['title'],
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors.black)),
                                                      SizedBox(height: 3),
                                                    ]))
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      'assets/person_ic.png',
                                                      width: 13,
                                                      height: 13),
                                                  SizedBox(width: 5),
                                                  Text(
                                                      videosList[pos]
                                                              ['user_name'] ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset('assets/calendar.png',
                                                      width: 13, height: 13),
                                                  SizedBox(width: 5),
                                                  Text(
                                                      videosList[pos]['created_at']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset('assets/eye_ic.png',
                                                      width: 13, height: 13),
                                                  SizedBox(width: 5),
                                                  Text(
                                                      videosList[pos]['view_count']
                                                              .toString() +
                                                          ' Views',
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black)),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),


                                    videosList[pos]["is_approved"]==0?

                                    Align(
                                      child: Container(
                                        width: 70,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                        child: Center(
                                          child:  Text('Pending',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11)),
                                        ),
                                      ),
                                      alignment: Alignment.topLeft,
                                    ):Container()

                                  ],
                                );
                              })
                        ],
                      ),
                    )
                  : selectedTabIndex == 2
                      ? Container(
                          child: Column(
                            children: [
                              SizedBox(height: 15),

                              /*  StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,



                  children: [
                    StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 3,
                        child: Image.asset('assets/album1_dummy.png')
                    ),
                    StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 1.2,
                        child: Image.asset('assets/album2.png')
                    ),
                    StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 3,
                        child: Image.asset('assets/album3.png')
                    ),
                    StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: Image.asset('assets/album4.png')
                    ),
                    StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: Image.asset('assets/album4.png')
                    ),
                    StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 1.2,
                        child: Image.asset('assets/album2.png')
                    ),
                  ],
                )*/

                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddLibraryScreen("image")));
                                    },
                                    child: Image.asset(
                                      'assets/add_black_ic.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                  )
                                ],
                              ),


                              imageList.length==0?

                                  Container(
                                    height: 200,
                                    child: Center(
                                      child: Text("No data found"),
                                    ),
                                  ):


                              Container(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 5,
                                          crossAxisCount: 2,
                                          childAspectRatio: (2 / 2)),
                                  itemCount: imageList.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageView(academyBaseUrl +
                                                          imageList[index][
                                                              'digital_library_path'] +
                                                          "/" +
                                                          imageList[index]
                                                                  ['images'][0]
                                                              ['image'])));
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              // height: 80,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          academyBaseUrl +
                                                              imageList[index][
                                                                  'digital_library_path'] +
                                                              "/" +
                                                              imageList[index]
                                                                      ['images']
                                                                  [
                                                                  0]['image']))),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                onTap:(){
                                                  showDeleteDialog(imageList[index]["_id"], "image");

                                    },
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.only(right: 5),
                                                    child: Image.asset(
                                                        'assets/delete_ic.png',
                                                        height: 20,
                                                        width: 16)),
                                              ),
                                            ),

                                            imageList[index]["is_approved"]==0?

                                            Align(
                                              child: Container(
                                                width: 70,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius: BorderRadius.circular(4)
                                                ),
                                                child: Center(
                                                  child:  Text('Pending',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            ):Container()
                                          ],
                                        ));
                                    // Item rendering
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddLibraryScreen("pdf")));
                                    },
                                    child: Image.asset(
                                      'assets/add_black_ic.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                  )
                                ],
                              ),



                              pdfList.length==0?

                              Container(
                                height: 200,
                                child: Center(
                                  child: Text("No data found"),
                                ),
                              ):
                              Container(
                                child: ListView.builder(
                                    itemCount: pdfList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int pos) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => PDFView(
                                                      academyBaseUrl +
                                                          pdfList[pos][
                                                              'digital_library_path'] +
                                                          "/" +
                                                          pdfList[pos]['images']
                                                              [0]['image'])));
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: AppTheme.greyColor),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 8),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 67,
                                                        width: 105,
                                                        child: Center(
                                                          child: Image.asset(
                                                              'assets/pdf_ic.png',
                                                              width: 55,
                                                              height: 55),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    pdfList[pos][
                                                                        'category_name'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: AppTheme
                                                                            .blueColor)),
                                                                Spacer(),
                                                                /*  GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedRadioIndex = pos;
                                                            });
                                                          },
                                                          child: selectedRadioIndex ==
                                                              pos
                                                              ? Icon(
                                                              Icons
                                                                  .radio_button_checked,
                                                              color: AppTheme
                                                                  .themeColor)
                                                              : Icon(Icons
                                                              .radio_button_off)),*/

                                                                GestureDetector(
                                                                  onTap: (){

                                                                    showDeleteDialog(pdfList[pos]["_id"],"pdf");



                                                                  },
                                                                  child: Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              right:
                                                                                  5),
                                                                      child: Image.asset(
                                                                          'assets/delete_ic.png',
                                                                          height: 20,
                                                                          width: 16)),
                                                                ),
                                                                SizedBox(width: 8)
                                                              ],
                                                            ),
                                                            Text(
                                                                pdfList[pos]
                                                                    ['title'],
                                                                style: const TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black)),
                                                            SizedBox(height: 3),
                                                          ]))
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              'assets/person_ic.png',
                                                              width: 13,
                                                              height: 13),
                                                          SizedBox(width: 5),
                                                          Text('Klubba Admin',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize: 11,
                                                                      color: Colors
                                                                          .black)),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              'assets/calendar.png',
                                                              width: 13,
                                                              height: 13),
                                                          SizedBox(width: 5),
                                                          Text(
                                                              pdfList[pos]
                                                                  ['created_at'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize: 11,
                                                                      color: Colors
                                                                          .black)),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              'assets/eye_ic.png',
                                                              width: 13,
                                                              height: 13),
                                                          SizedBox(width: 5),
                                                          Text(
                                                              pdfList[pos][
                                                                          'view_count']
                                                                      .toString() +
                                                                  ' Views',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize: 11,
                                                                      color: Colors
                                                                          .black)),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            ),

                                            pdfList[pos]["is_approved"]==0?
                                            Align(
                                              child: Container(
                                                width: 70,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius: BorderRadius.circular(4)
                                                ),
                                                child: Center(
                                                  child:  Text('Pending',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            ):Container()
                                          ],
                                        ),
                                      );
                                    }),
                              ),
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
    fetchDigitalLibrary(context, 'video');
  }

  fetchDigitalLibrary(BuildContext context, String type) async {
    setState(() {
      isLoading = true;
    });

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getDigitalLibrary",
      "data": {
        "type": "video",
        "library_for": ["my"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 4,
        "filters": {
          "category": widget.filterApplied ? FilterModel.category : null,
          "learner_stages":
              widget.filterApplied ? FilterModel.learner_stages : "",
          "category_attribute":
              widget.filterApplied ? FilterModel.category_attribute : "",
          "category_sub_attribute": widget.filterApplied?FilterModel.category_sub_attribute:"",
        },
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
        await helper.postAPI('getDigitalLibrary', requestModel, context);
    isLoading = false;

    var responseJSON = json.decode(response.body);
    videosList = responseJSON['decodedData']['my']['data']['result'];
    trendingVideos = responseJSON['decodedData']['my']['data']['result'];
    setState(() {});
    print(responseJSON);
  }

  fetchDigitalLibraryImages(BuildContext context, String type) async {
    setState(() {
      isLoading = true;
    });

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getDigitalLibrary",
      "data": {
        "type": "image",
        "library_for": ["my"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 4,
        "filters": {
          "category": widget.filterApplied ? FilterModel.category : null,
          "learner_stages":
              widget.filterApplied ? FilterModel.learner_stages : "",
          "category_attribute":
              widget.filterApplied ? FilterModel.category_attribute : "",
          "category_sub_attribute": widget.filterApplied?FilterModel.category_sub_attribute:"",
        },
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
        await helper.postAPI('getDigitalLibrary', requestModel, context);
    isLoading = false;

    var responseJSON = json.decode(response.body);
    imageList = responseJSON['decodedData']['my']['data']['result'];
    academyBaseUrl = responseJSON['decodedData']['image_url'];
    setState(() {});
    print(responseJSON);
  }

  deleteFile(String fileID, String fileType) async {
    APIDialog.showAlertDialog(context, "Deleting file...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "deletePdfLibrary",
      "data": {
        "item_id": fileID,
        "type": fileType,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('deletePdfLibrary', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
      if(selectedTabIndex==1)
        {
          fetchDigitalLibrary(context, "video");
        }
      else if(selectedTabIndex==2)
        {
          fetchDigitalLibraryImages(context, "image");
        }
      else
        {
          fetchPDFFiles(context, "pdf");
        }


    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }

  fetchPDFFiles(BuildContext context, String type) async {
    setState(() {
      isLoading = true;
    });

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getDigitalLibrary",
      "data": {
        "type": "pdf",
        "library_for": ["my"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 4,
        "filters": {
          "category": widget.filterApplied ? FilterModel.category : null,
          "learner_stages":
              widget.filterApplied ? FilterModel.learner_stages : "",
          "category_attribute":
              widget.filterApplied ? FilterModel.category_attribute : "",
          "category_sub_attribute": widget.filterApplied?FilterModel.category_sub_attribute:"",
        },
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
        await helper.postAPI('getDigitalLibrary', requestModel, context);
    isLoading = false;

    var responseJSON = json.decode(response.body);
    pdfList = responseJSON['decodedData']['my']['data']['result'];
    //  academyBaseUrl=responseJSON['decodedData']['image_url'];
    setState(() {});
    print(responseJSON);
  }


  showDeleteDialog(String fileID,String type) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {

        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete",style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.blueColor
      ),),
      onPressed:  () {
        Navigator.pop(context);

        deleteFile(fileID, type);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete File?"),
      content: Text("Are you sure you want to delete ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
