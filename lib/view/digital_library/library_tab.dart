import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/utils/filter_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/view/digital_library/library_tab.dart';
import 'package:klubba/view/digital_library/pdf_view_screen.dart';
import 'package:klubba/view/digital_library/vimeo_player_screen.dart';
import 'package:klubba/view/youtube_player.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:lottie/lottie.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class KlubbaLibraryTab extends StatefulWidget {
  final bool filterApplied;
  final bool categoryFilterApplied;
  final String operationType;
  final int selectedInnerTab;

  KlubbaLibraryTab(this.filterApplied, this.operationType,
      this.selectedInnerTab, this.categoryFilterApplied);

  TabState createState() => TabState();
}

class TabState extends State<KlubbaLibraryTab> {
  int selectedTabIndex = 1;
  int selectedRadioIndex = 0;
  bool isPagLoading = false;
  int _page = 1;
  bool loadMoreData = true;
  late ScrollController _scrollController;
  bool isLoading = false;
  List<dynamic> videosList = [];
  int selectedFileIndex = 9999;
  int selectedImageIndex = 9999;
  int selectedPDFIndex = 9999;
  List<dynamic> pdfList = [];
  List<dynamic> imageList = [];
  List<dynamic> trendingVideos = [];
  String academyBaseUrl = '';
  bool fileSelected = false;
  Map<String, dynamic> fileData = {};
  String? selectedFileType;

  @override
  Widget build(BuildContext context) {
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
                                child: Text('Trendy ',
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
                            ],
                          ),
                          SizedBox(height: 5),
                          trendingVideos.length != 0
                              ? trendingVideos[0]['video_thumb'] != null
                                  ? InkWell(
                                      onTap: () {
                                        String videoID = trendingVideos[0]
                                                ['library_video_url']
                                            .split('/')
                                            .last;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VimeoPlayer22(videoID)));
                                      },
                                      child: Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 200,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          trendingVideos[0][
                                                              'video_thumb']))),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                  child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 55,
                                              )),
                                            ),
                                          ],
                                        ),
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
                                  child: Text('No Data found'),
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
                          videosList.length == 0
                              ? Container(
                                  height: 250,
                                  child: Center(
                                    child: Text("No data found"),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: videosList.length,
                                  controller: _scrollController,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int pos) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (videosList[pos]['video_type'] ==
                                            "youtube") {
                                          //library_video_url
                                          //    Navigator.push(context, MaterialPageRoute(builder: (context)=>YoutubePlayerScreen(videosList[pos]['library_video_url'])));
                                        } else {
                                          String videoID = videosList[pos]
                                                  ['library_video_url']
                                              .split('/')
                                              .last;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VimeoPlayer22(videoID)));
                                        }
                                      },
                                      child: Container(
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
                                                    child: videosList[pos][
                                                                'video_thumb'] !=
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
                                                                        image: NetworkImage(videosList[pos]
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
                                                                            .circular(5),
                                                                  ),
                                                                  child: Center(
                                                                      child:
                                                                          Icon(
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
                                                              videosList[pos][
                                                                  'category_name'],
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppTheme
                                                                      .blueColor)),
                                                          Spacer(),
                                                          widget.operationType ==
                                                                  "Select"
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    updateFileStatus(
                                                                        "video",
                                                                        videosList[
                                                                            pos]);
                                                                    setState(
                                                                        () {
                                                                      selectedFileIndex =
                                                                          pos;
                                                                    });
                                                                  },
                                                                  child: selectedFileIndex ==
                                                                          pos
                                                                      ? Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 10),
                                                                          child: Icon(
                                                                              Icons.radio_button_checked_rounded,
                                                                              color: AppTheme.themeColor),
                                                                        )
                                                                      : Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 10),
                                                                          child:
                                                                              Icon(Icons.radio_button_off),
                                                                        ))
                                                              : Container()
                                                        ],
                                                      ),
                                                      Text(
                                                          videosList[pos]
                                                              ['title'],
                                                          style:
                                                              const TextStyle(
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
                                                    Text(
                                                        videosList[pos]
                                                                ['user_name'] ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black)),
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
                                                        videosList[pos]
                                                                ['created_at']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black)),
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
                                                        videosList[pos][
                                                                    'view_count']
                                                                .toString() +
                                                            ' Views',
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                          isPagLoading
                              ? Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Center(
                                    child: Loader(),
                                  ),
                                )
                              : videosList.length == 0
                                  ? Container()
                                  :

                           loadMoreData && videosList.length>3?
                          Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            _page++;
                                            if (loadMoreData) {
                                              setState(() {
                                                isPagLoading = true;
                                              });
                                              paginateVideos(context, _page);
                                            }
                                          },
                                          child: Icon(
                                            Icons.refresh,
                                            size: 32,
                                            color: AppTheme.blueColor,
                                          ))):Container()
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

                              imageList.length == 0
                                  ? Container(
                                      height: 250,
                                      child: Center(
                                        child: Text("No data found"),
                                      ),
                                    )
                                  : Container(
                                      //height: 400,
                                      child: GridView.builder(
                                        shrinkWrap: true,
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
                                          print(academyBaseUrl +
                                              imageList[index]
                                                  ['digital_library_path'] +
                                              "/" +
                                              imageList[index]['images'][0]
                                                  ['image']);
                                          return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageView(academyBaseUrl +
                                                                imageList[index]
                                                                    [
                                                                    'digital_library_path'] +
                                                                "/" +
                                                                imageList[index]
                                                                        [
                                                                        'images'][0]
                                                                    [
                                                                    'image'])));
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    // height: 80,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(academyBaseUrl +
                                                                imageList[index]
                                                                    [
                                                                    'digital_library_path'] +
                                                                "/" +
                                                                imageList[index]
                                                                        [
                                                                        'images'][0]
                                                                    [
                                                                    'image']))),
                                                  ),
                                                  widget.operationType ==
                                                          "Select"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            updateFileStatus(
                                                                "image",
                                                                imageList[
                                                                    index]);
                                                            setState(() {
                                                              selectedImageIndex =
                                                                  index;
                                                            });
                                                          },
                                                          child:
                                                              selectedImageIndex ==
                                                                      index
                                                                  ? Align(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                10),
                                                                        child: Icon(
                                                                            Icons
                                                                                .radio_button_checked_rounded,
                                                                            color:
                                                                                AppTheme.themeColor),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                    )
                                                                  : Align(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                10),
                                                                        child: Icon(
                                                                            Icons.radio_button_off),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                    ))
                                                      : Container()
                                                ],
                                              ));
                                          // Item rendering
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : pdfList.length == 0
                          ? Container(
                              height: 250,
                              child: Center(
                                child: Text("No data found"),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 15),
                              child: ListView.builder(
                                  itemCount: pdfList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int pos) {
                                    return InkWell(
                                      onTap: () {
                                        print( academyBaseUrl +
                                            pdfList[pos][
                                            'digital_library_path'] +
                                            "/" +
                                            pdfList[pos]['images']
                                            [0]['image']);
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
                                      child: Container(
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
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppTheme
                                                                      .blueColor)),
                                                        ],
                                                      ),
                                                      Text(
                                                          pdfList[pos]['title'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black)),
                                                      SizedBox(height: 3),
                                                    ])),
                                                widget.operationType == "Select"
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          updateFileStatus(
                                                              "pdf",
                                                              pdfList[pos]);
                                                          setState(() {
                                                            selectedPDFIndex =
                                                                pos;
                                                          });
                                                        },
                                                        child:
                                                            selectedPDFIndex ==
                                                                    pos
                                                                ? Align(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                      child: Icon(
                                                                          Icons
                                                                              .radio_button_checked_rounded,
                                                                          color:
                                                                              AppTheme.themeColor),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                  )
                                                                : Align(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                      child: Icon(
                                                                          Icons
                                                                              .radio_button_off),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                  ))
                                                    : Container()
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
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black)),
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
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black)),
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
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
              fileSelected
                  ? InkWell(
                      onTap: () {
                        print('SELECTED FILE DATA');
                        print(fileData.toString());
                        AppModel.setFileData(fileData);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text('Proceed',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.5)),
                        ),
                      ),
                    )
                  : Container()
            ],
          );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.selectedInnerTab.toString() + "****");
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    if (widget.selectedInnerTab == 1) {
      fetchDigitalLibrary(context, 'video');
    } else if (widget.selectedInnerTab == 2) {
      selectedTabIndex = widget.selectedInnerTab;
      fetchDigitalLibraryImages(context, "image");
    } else if (widget.selectedInnerTab == 3) {
      selectedTabIndex = widget.selectedInnerTab;
      fetchPDFFiles(context, "pdf");
    }
    setState(() {});
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
        "library_for": ["trending", "coaches", "shared", "latest"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 4,
        "filters": {
          "category": widget.filterApplied ? FilterModel.category : catId,
          "learner_stages":
              widget.filterApplied ? FilterModel.learner_stages : "",
          "category_attribute":
              widget.filterApplied ? FilterModel.category_attribute : "",
          "category_sub_attribute":
              widget.filterApplied ? FilterModel.category_sub_attribute : "",
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
    videosList = responseJSON['decodedData']['latest']['data']['result'];
    trendingVideos = responseJSON['decodedData']['trending']['data']['result'];
    setState(() {});
    print(responseJSON);
  }

  paginateVideos(BuildContext context, int page) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getDigitalLibrary",
      "data": {
        "type": "video",
        "library_for": ["trending", "coaches", "shared", "latest"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": page,
        "pageSize": 4,
        "filters": {
          "category": widget.filterApplied ? FilterModel.category : catId,
          "learner_stages":
              widget.filterApplied ? FilterModel.learner_stages : "",
          "category_attribute":
              widget.filterApplied ? FilterModel.category_attribute : "",
          "category_sub_attribute":
              widget.filterApplied ? FilterModel.category_sub_attribute : "",
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
    isPagLoading = false;
    var responseJSON = json.decode(response.body);
    /*videosList=responseJSON['decodedData']['latest']['data']['result'];
    trendingVideos=responseJSON['decodedData']['trending']['data']['result'];*/

    List<dynamic> newVideos =
        responseJSON['decodedData']['latest']['data']['result'];
    if (newVideos.length == 0) {
      loadMoreData = false;
    } else {
      List<dynamic> combo = videosList + newVideos;
      videosList = combo;
    }

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
        "library_for": ["trending", "coaches", "shared", "latest"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 4,
        "filters": {
          "category": widget.filterApplied ? FilterModel.category : catId,
          "learner_stages":
              widget.filterApplied ? FilterModel.learner_stages : "",
          "category_attribute":
              widget.filterApplied ? FilterModel.category_attribute : "",
          "category_sub_attribute":
              widget.filterApplied ? FilterModel.category_sub_attribute : "",
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
    imageList = responseJSON['decodedData']['latest']['data']['result'];
    academyBaseUrl = responseJSON['decodedData']['image_url'];
    setState(() {});
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
        "library_for": ["trending", "coaches", "shared", "latest"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 4,
        "filters": {
          "category": widget.filterApplied?FilterModel.category:null,
          "learner_stages": widget.filterApplied?FilterModel.learner_stages:"",
          "category_attribute":widget.filterApplied?FilterModel.category_attribute:"",
          "category_sub_attribute": widget.filterApplied?FilterModel.category_sub_attribute:"",
        },
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by":id
      }
    };

   /* var data = {
      "method_name": "getDigitalLibrary",
      "data": {
        "type": "pdf",
        "library_for": ["trending", "coaches", "shared", "latest"],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 12,
        "filters": {
          "category": "5d498615ee90fb3fb1a59b9e",
          "learner_stages": "5d496c2de67f81784a9ddc39",
          "category_attribute": "",
          "category_sub_attribute": ""
        },
        "slug": "nirveeka-learner",
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": "5d498615ee90fb3fb1a59b9e",
        "action_performed_by": "61b9c5c64e85c44c9df8fa93"
      }
    };*/

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getDigitalLibrary', requestModel, context);
    isLoading = false;

    var responseJSON = json.decode(response.body);
    pdfList = responseJSON['decodedData']['latest']['data']['result'];
      academyBaseUrl=responseJSON['decodedData']['image_url'];
    setState(() {});
    print(responseJSON);
  }

  void showVideoDialog(String videoID) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 200,
            child: SizedBox.expand(
              child: Container(
                height: 200,
                child: VimeoPlayer(
                  videoId: videoID,
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
          ),
        );
      },
      /*  transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },*/
    );
  }

  updateFileStatus(String fileType, Map<String, dynamic> fileDataMap) {
    fileSelected = true;
    fileData = fileDataMap;
    fileType = fileType;
    setState(() {});
  }
}
