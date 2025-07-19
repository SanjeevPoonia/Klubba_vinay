import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/category/add_category_screen.dart';

import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/local_video_screen.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:klubba/view/planner/my_planner_screen.dart';
import 'package:klubba/view/my_profile/my_profile_screen.dart';
import 'package:klubba/view/notification/notification_screen.dart';
import 'package:klubba/view/digital_library/pdf_view_screen.dart';
import 'package:klubba/view/home/pending_assignments.dart';
import 'package:klubba/view/home/progress_picture_view.dart';
import 'package:klubba/view/home/today_assignment_screen.dart';
import 'package:klubba/view/home/upload_progress_pictures.dart';
import 'package:klubba/view/digital_library/vimeo_player_screen.dart';
import 'package:klubba/widgets/new_bottom.dart';
import 'package:klubba/widgets/video_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class HomeScreen2 extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeScreen2> with SingleTickerProviderStateMixin {
  String name = '';
  int goalPage = 0;
  int notesPage = 0;
  int limitationsPage = 0;
  double nutritionSlider = 0;
  double fitnessSlider = 0;
  late TutorialCoachMark tutorialCoachMark;
  ScrollController _scrollController = new ScrollController();
  double skillSetSlider = 0;
  String totalDays = '0';
  int equipmentPage = 0;
  String currentDate = '';
  int currentMonthCount = DateTime.now().month;
  int currentDaysCount = 0;
  String currentMonthName = '';
  var remainderController = TextEditingController();
  DateTime dateTime = DateTime.now();
  String spaceConsumed = '';
  int? currentCalenderDate;
  Map<String, dynamic> selfData = {};
  Map<String, dynamic> percentageData = {};
  Map<String, dynamic> coachData = {};
  int selectedColorIndex = 0;

  bool hasData = false;
  int dataIndex = 0;
  String? imageURL = '';
  int currentDateSelectedIndex = 9999;
  List<dynamic> bannerList = [];
  DateTime endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 5, 30);
  DateTime? startDate = DateTime(DateTime.now().year, DateTime.now().month - 5);
  List<String> goalList = ["\"goal\""];
  String currentCategoryImageUrl = '';
  DateTime selectedDate = DateTime.now();
  final _formKeyGoal = GlobalKey<FormState>();
  List<dynamic> goalsList = [];
  List<dynamic> categoryList = [];
  List<dynamic> notesList = [];
  String imageUrl = '';
  String bannerImageUrl = '';
  List<dynamic> limitationList = [];
  List<dynamic> equipmentsList = [];
  int selectedTab = 1;
  int selectedCategoryIndex = 9999;
  List<dynamic> textList = [];
  String totalSpace = '';
  String remainingSpace = '';
  int spacePercentage = 0;
  String progressivePictureBase = '';
  List<dynamic> progressList = [];
  List<dynamic> plannerList = [];
  List<dynamic> fitnessList = [];
  List<dynamic> nutritionList = [];
  var goalController = TextEditingController();
  var notesController = TextEditingController();
  var limitationsController = TextEditingController();
  var equipmentsController = TextEditingController();
  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();
  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<String> monthName = [
    "NA",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  List<String> categoryName = [
    'Cricket',
    'Basketball',
    'Yoga',
    'Gym',
    'Boxing',
    'Swimming',
    'Painting',
    'Drawing',
  ];
  List<String> categoryIcons = [
    'assets/cat1.png',
    'assets/cat3.png',
    'assets/cat2.png',
    'assets/cat4.png',
    'assets/cat5.png',
    'assets/cat6.png',
    'assets/cat7.png',
    'assets/cat8.png',
  ];
  int _tabIndex = 1;
  bool _fromTop = true;

  int get tabIndex => _tabIndex;

  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentCalenderDate = DateTime.now().day;
    _fetchCurrentMonth();
    pageController = PageController(initialPage: _tabIndex);
    checkCategory();
    _fetchName();
    fetchBanners(context);
    fetchProgressivePictures(context);
    fetchPlanner(context);
    getLevelOfParticipation();
    fetchPercentage();
   // fetchSpaceUtilizations(context);
    _fetchCategoryList(context);
    fetchProfileDetails();
  /*  Future.delayed(Duration.zero,
            () async {
          _showHintDialog();
         // AppModel.setHintValue(false);
        });
*/

    showHints();

  }

  showHints() async {
    if(AppModel.showHint)
    {

      String? currentcatId=await MyUtils.getSharedPreferences("current_category_id");
      if(currentcatId!='' && currentcatId!=null)
      {
        Future.delayed(Duration.zero,
                () async {
              _showHintDialog();
              AppModel.setHintValue(false);
            });
      }
    }

  }

  refreshHomeScreenData(String currentCatId, String catImage) {
    MyUtils.saveSharedPreferences('current_category_id', currentCatId);
    setState(() {
      currentCategoryImageUrl = catImage;
    });
    fetchGoals(context);
    /* fetchNotes(context);
    fetchLimitations(context);
    fetchEquipments(context);*/
    fetchProgressivePictures(context);
   // fetchSpaceUtilizations(context);
  }

  _fetchName() async {
    name = (await MyUtils.getSharedPreferences('name'))!;
    imageURL = await MyUtils.getSharedPreferences('profile_image') ?? null;
    setState(() {});
    fetchGoals(context);
    /*  fetchNotes(context);
    fetchLimitations(context);
    fetchEquipments(context);*/
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: ListView(
            physics: ClampingScrollPhysics(),
            controller: _scrollController,
            children: [
              Container(
                //height: 210,
                child: Stack(
                  children: [
                    /*   Container(
                      // transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                      //height: 210,
                      decoration: BoxDecoration(
                          color: Colors.white,I
                          image: DecorationImage(
                              image: AssetImage('assets/home_bg.png'))),
                    ),*/

                    Image.asset('assets/home_bg.png'),
                    Column(
                      children: [
                        /*   Container(
                       height: 22,
                       color: Colors.black,
                     ),*/

                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationScreen()));
                                    },
                                    child: Image.asset('assets/not_ic.png',
                                        width: 21.53, height: 24.67),
                                  ),
                                  SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen(false)));
                                    },
                                    child: Image.asset('assets/cart_ic.png',
                                        width: 23.56, height: 22.09),
                                  ),
                                  SizedBox(width: 15)
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Image.asset('assets/app_logo.png',
                                    width: 108, height: 30),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 35),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfileScreen()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 35),
                              imageURL == '' || imageURL == null
                                  ? Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              width: 1.5, color: Colors.white),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/dummy_profile.png'))),
                                    )
                                  : Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            width: 1.5, color: Colors.white),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: imageURL!,
                                        fit: BoxFit.fill,
                                        width: 45,
                                        height: 45,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                                "assets/dummy_profile.png"),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                "assets/dummy_profile.png"),
                                      ),
                                    ),

                              /* imageURL == '' || imageURL==null?
                                   Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              width: 1.5, color: Colors.white),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/dummy_profile.png'))),
                                    )
                                  :*/ /*Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              width: 1.5, color: Colors.white),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(imageURL!))),
                                    ),*/
                              SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Hi, ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 12)
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Stack(
                                children: [

                                  SizedBox(
                                    key: keyBottomNavigation1,
                                    height: 40,
                                    width: 40,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      _showCategoryDialog();

                                      //_showHintDialog();

                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1.5,
                                              color: const Color(0xFFCEAC45))),
                                      child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: currentCategoryImageUrl != ''
                                                ? Image.network(
                                                    currentCategoryImageUrl,
                                                  )
                                                : Container()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              bannerList.length == 0
                  ? Container()
                  : Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 15),
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: bannerList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int pos) {
                            return Row(
                              children: [
                                Container(
                                  height: 200,
                                  child:
                               bannerList[pos]["banner"]=="video"?

                                   GestureDetector(
                                     onTap: (){
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>LocalVideoScreen()));
                                     },
                                     child: Stack(
                                       children: [

                                         Container(
                                           width:
                                           MediaQuery.of(context).size.width * 0.9,
                                           height: 200,
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(15),
                                               image: DecorationImage(
                                                   fit: BoxFit.cover,
                                                   image:
                                                   AssetImage("assets/video_thumb.png"))),
                                         ),



                                         Container(
                                           height: 200,
                                           width:
                                           MediaQuery.of(context).size.width * 0.9,
                                           child: Center(
                                             child: Icon(Icons.play_arrow_sharp,color: Colors.white,size: 55),
                                           ),
                                         )

                                       ],
                                     ),
                                   ):



                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                            NetworkImage(bannerImageUrl +
                                                bannerList[pos]
                                                    ['mobile_banner']))),
                                  ),
                                ),
                                SizedBox(width: 15)
                              ],
                            );
                          }),
                    ),
              bannerList.length == 0 ? Container() : SizedBox(height: 20),
              /* Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('My ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text('Planner',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
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
                    Container(
                      width: 103,
                      height: 39,
                      child: ElevatedButton(
                          child: Text('View All',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.5)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyPlannerScreen(true)));
                          }),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 12),
                  GestureDetector(
                      onTap: () async {
                        */ /* final picked = await showDateRangePicker(
                          context: context,
                          lastDate:endDate,
                          firstDate: DateTime(2023),
                        );
                        if (picked != null && picked != null) {
                          print(picked);
                          setState(() {
                            startDate = picked.start;
                            endDate = picked.end;
                                picked.start.toIso8601String();
                                picked.end
                                    .add(Duration(hours: 24))
                                    .toIso8601String();
                          });
                        }*/ /*
                      },
                      child: Image.asset('assets/calendar_ic.png',
                          width: 17, height: 17)),

                  SizedBox(width: 8),
                  Text('From: ',
                      style:
                          TextStyle(color: Color(0xFF7994A8), fontSize: 12.5)),
                  Text("01 " + currentMonthName,
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5)),
                  SizedBox(width: 15),
                  //7994A8
                  Text('To: ',
                      style:
                          TextStyle(color: Color(0xFF7994A8), fontSize: 12.5)),
                  Text(currentDaysCount.toString() + " " + currentMonthName,
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5)),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 85,
                margin: EdgeInsets.only(left: 12),
                child: ListView.builder(
                    itemCount: currentDaysCount,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int pos) {
                      int date = pos + 1;
                      String dateSTR = date.toString() +
                          "/" +
                          currentMonthCount.toString() +
                          "/" +
                          DateTime.now().year.toString();
                      if (date.bitLength == 1) {
                        String dateAsString = "0" + date.toString();
                        date = int.parse(dateAsString);
                      }

                      return Row(
                        children: [
                          InkWell(
                            child: date > DateTime.now().day
                                ? Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 4,
                                    color: currentDateSelectedIndex == pos
                                        ? Colors.black
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Container(
                                      width: 49,
                                      height: 77,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 15),
                                          Container(
                                            height: 1,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            color:
                                                currentDateSelectedIndex == pos
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          SizedBox(height: 10),
                                          Text(date.toString(),
                                              style: TextStyle(
                                                  color:
                                                      currentDateSelectedIndex ==
                                                              pos
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17)),
                                          Text(fetchDayName(dateSTR),
                                              style: TextStyle(
                                                  color:
                                                      currentDateSelectedIndex ==
                                                              pos
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 49,
                                    height: 77,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: date == currentCalenderDate ||
                                                currentDateSelectedIndex == pos
                                            ? Colors.black
                                            : AppTheme.themeColor),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5),
                                        Image.asset('assets/smiley_ic.png',
                                            width: 21.93, height: 21.93),
                                        Text(date.toString(),
                                            style: TextStyle(
                                                color: date ==
                                                            currentCalenderDate ||
                                                        currentDateSelectedIndex ==
                                                            pos
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17)),
                                        Text(fetchDayName(dateSTR),
                                            style: TextStyle(
                                                color: date ==
                                                            currentCalenderDate ||
                                                        currentDateSelectedIndex ==
                                                            pos
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ),
                            onTap: () {
                              currentCalenderDate = 100;
                              hasData = false;
                              dataIndex = 0;
                              currentDateSelectedIndex = pos;
                              setState(() {});
                              updatePlannerData(date);
                            },
                          ),
                          SizedBox(width: 8),
                        ],
                      );
                    }),
              ),
              SizedBox(height: 23),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 11),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Container(
                                height: 30,
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
                              },
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedTab = 2;
                                });
                              },
                              child: Container(
                                height: 30,
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
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedTab = 3;
                                });
                              },
                              child: Container(
                                height: 30,
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
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  remainderController.text = "";
                                  selectedColorIndex = 0;
                                  _showRemainderDialog();
                                },
                                child: Image.asset('assets/sub1.png',
                                    width: 37, height: 37),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final data = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddAssignmentScreen(
                                                  currentDate)));
                                  if (data != null) {
                                    fetchPlanner(context);
                                  }
                                },
                                child: Image.asset('assets/sub2.png',
                                    width: 30, height: 30),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final data = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddRestDayScreen(currentDate)));
                                  if (data != null) {
                                    fetchPlanner(context);
                                  }
                                },
                                child: Image.asset('assets/sub3.png',
                                    width: 37, height: 37),
                              ),
                              hasData
                                  ? GestureDetector(
                                      onTap: () {
                                        AppModel.setCopyData(
                                            plannerList[dataIndex]);

                                        _showCopyDialog();
                                      },
                                      child: Icon(Icons.copy,
                                          color: AppTheme.blueColor))
                                  : Icon(Icons.copy, color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      hasData
                          ? Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text('Title',
                                  style: TextStyle(
                                      color: AppTheme.blueColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            )
                          : Container(),
                      SizedBox(height: 5),
                      hasData
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(plannerList[dataIndex]['title'],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                            )
                          : Container(),
                      SizedBox(height: 15),
                      hasData
                          ? ListView.builder(
                              itemCount:
                                  plannerList[dataIndex]['activities'].length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int pos) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Text(
                                          plannerList[dataIndex]['activities']
                                              [pos]['title'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(height: 10),

                                    */ /*     Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Image.asset('assets/play_ic.png',
                                          width: 35, height: 35),
                                    ),*/ /*

                                    Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                */ /*  Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DigitalLibraryScreen(false)));*/ /*
                                              },
                                              child: plannerList[dataIndex]
                                                                  ['activities']
                                                              [pos]
                                                          ['attachment_type'] ==
                                                      "video"
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        if (plannerList[dataIndex]
                                                                        [
                                                                        'activities']
                                                                    [pos]
                                                                ['attchement']
                                                            .toString()
                                                            .contains(
                                                                "video_url")) {
                                                          String videoID =
                                                              plannerList[dataIndex]['activities']
                                                                              [
                                                                              pos]
                                                                          [
                                                                          'attchement']
                                                                      [
                                                                      'video_url']
                                                                  .split('/')
                                                                  .last;
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      VimeoPlayer22(
                                                                          videoID)));
                                                        } else {
                                                          fetchLibraryByID(
                                                              plannerList[dataIndex]
                                                                          [
                                                                          'activities']
                                                                      [pos][
                                                                  'attchement'],
                                                              "video");
                                                        }
                                                      },
                                                      child: Image.asset(
                                                          'assets/play_ic.png',
                                                          width: 32,
                                                          height: 32),
                                                    )
                                                  : Image.asset(
                                                      'assets/play_ic.png',
                                                      width: 32,
                                                      height: 32,
                                                      color: Colors.grey)),
                                          SizedBox(width: 10),
                                          plannerList[dataIndex]['activities']
                                                          [pos]
                                                      ['attachment_type'] ==
                                                  "pdf"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    print("Tap Triggered");

                                                    fetchLibraryByID(
                                                        plannerList[dataIndex][
                                                                    'activities']
                                                                [pos]
                                                            ['attchement_pdf'],
                                                        "pdf");
                                                  },
                                                  child: Image.asset(
                                                      'assets/title2.png',
                                                      width: 32,
                                                      height: 32,
                                                      color:
                                                          AppTheme.blueColor),
                                                )
                                              : Image.asset('assets/title2.png',
                                                  width: 32, height: 32),
                                          SizedBox(width: 10),
                                          plannerList[dataIndex]['activities']
                                                          [pos]
                                                      ['attachment_type'] ==
                                                  "image"
                                              ? GestureDetector(
                                                  child: Image.asset(
                                                      'assets/title3.png',
                                                      width: 32,
                                                      height: 32,
                                                      color:
                                                          AppTheme.blueColor),
                                                  onTap: () {
                                                    fetchLibraryByID(
                                                        plannerList[dataIndex][
                                                                    'activities']
                                                                [pos][
                                                            'attchement_image'],
                                                        "image");
                                                  },
                                                )
                                              : Image.asset('assets/title3.png',
                                                  width: 32, height: 32),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text('Instructions, Example',
                                          style: TextStyle(
                                              color: AppTheme.blueColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(height: 5),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                          plannerList[dataIndex]['activities']
                                              [pos]['description'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
                                    SizedBox(height: 25)
                                  ],
                                );
                              })
                          : Container(
                              // height: 25,
                              padding: EdgeInsets.only(bottom: 24),
                              child: Center(
                                child: Text('No Data found!!'),
                              ),
                            )
                    ],
                  ),
                ),
              ),*/

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Assignments',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(' To Do',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
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
              ),
              SizedBox(height: 10),
              Stack(
                children: [


                  Container(
                    key: keyBottomNavigation2,
                    height: 200,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),

                  ),



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
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: AppTheme.themeColor,
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/tab1_assignment.png"),
                                      SizedBox(width: 15),
                                      Text('Today',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 10),
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PendingAssignments()));
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xFfF3F3F3),
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/tab2_assignment.png"),
                                        SizedBox(width: 15),
                                        Text('Pending',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFf9A9CB8),
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                                flex: 1),
                          ],
                        ),
                        SizedBox(height: 13),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TodayAssignmentScreen(0)));
                                  },
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [






                                        Lottie.asset('assets/dashboard_1.json'),


                                        Text('School',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.themeColor,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 10),
                            Expanded(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TodayAssignmentScreen(1)));
                                  },
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                                  color: AppTheme.themeColor,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                flex: 1),
                          ],
                        ),
                        SizedBox(height: 17),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TodayAssignmentScreen(2)));
                                  },
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                                color: AppTheme.themeColor,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 10),
                            Expanded(
                                child: Container()
                                /* Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                            color: AppTheme.themeColor,
                                            fontWeight:
                                            FontWeight.bold)),






                                  ],
                                ),



                              )*/
                                ,
                                flex: 1),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Level',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(' Of Participation',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
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
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    key: keyBottomNavigation3,
                    height: 170,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),

                  ),


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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(totalDays+' Days Assignment Level of Participation',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Container(
                              width:60,
                              child: Text('Nutrition',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13)),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: Colors.black,
                                activeColor: AppTheme.themeColor,
                                inactiveColor: Color(0xFF9A9CB8).withOpacity(0.11),
                                min: 0,
                                /* setState(() {
                              30 = value;
                            });*/
                                max: 100,
                                value: nutritionSlider,
                                onChanged: (value) {},
                              ),
                            ),
                            Text(nutritionSlider.toString()+'%',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width:60,
                              child: Text('Fitness',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13)),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: Colors.black,
                                activeColor: AppTheme.themeColor,
                                inactiveColor: Color(0xFF9A9CB8).withOpacity(0.11),
                                min: 0,
                                /* setState(() {
                              30 = value;
                            });*/
                                max: 100,
                                value: fitnessSlider,
                                onChanged: (value) {},
                              ),
                            ),
                            Text(fitnessSlider.toString()+'%',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width:60,
                              child: Text('Skills',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13)),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: Colors.black,
                                activeColor: AppTheme.themeColor,
                                inactiveColor: Color(0xFF9A9CB8).withOpacity(0.11),
                                min: 0,
                                /* setState(() {
                              30 = value;
                            });*/
                                max: 100,
                                value: skillSetSlider,
                                onChanged: (value) {},
                              ),
                            ),
                            Text(skillSetSlider.toString()+'%',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                  ),




                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Skill ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text('Performance Meter',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        Container(
                          width: 35,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: AppTheme.themeColor),
                        )
                      ],
                    ),
                    /*  Spacer(),
                    Container(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                          child: Text('View All',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.5)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          onPressed: () => null),
                    )*/
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: Colors.white,
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                          Container(
                                padding: EdgeInsets.only(left: 5),
                                child: CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 16.0,
                                  animation: true,
                                  percent:

                                  percentageData.isEmpty?0.0:

                                      percentageData["self"] ==
                                          null
                                      ? 0.0
                                      :
                                      percentageData["self"]>100?1.0:


                                      double.parse(percentageData["self"]
                                              .toString()) /
                                          100,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        percentageData.isEmpty?"0%":
                                        percentageData["self"] ==
                                            null
                                            ? "0%"
                                            : percentageData["self"]
                                                    .toStringAsFixed(2) +
                                                "%",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: AppTheme.blueColor),
                                      ),
                                      /*   Text(
                                  "Excellent",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                      color: AppTheme.blueColor),
                                ),*/
                                    ],
                                  ),
                                  footer: Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Self",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: AppTheme.themeColor,
                                ),
                              ),
                       Container(
                                padding: EdgeInsets.only(right: 5),
                                child: CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 16.0,
                                  animation: true,
                                  percent:
                                  percentageData.isEmpty?0.0:

                                  percentageData["coach"] ==
                                         null
                                      ? 0.0
                                      :
                                  percentageData["coach"]>100?1.0:
                                  double.parse(percentageData["coach"]
                                                  .toString()) /
                                              100,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        percentageData.isEmpty?"0%":


                                        percentageData["coach"] ==
                                            null
                                            ? "0%"
                                            : percentageData["coach"].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: AppTheme.blueColor),
                                      ),
                                      /*  Text(
                                  "Excellent",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                      color: AppTheme.blueColor),
                                ),*/
                                    ],
                                  ),
                                  footer: Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Coach",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: AppTheme.themeColor,
                                ),
                              )

                      ],
                    )),
              ),
              SizedBox(height: 35),
              Card(
                color: Colors.white,
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Goal',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          GestureDetector(
                            onTap: () {
                              goalController.text = "";
                              _showGoalBottomSheet("Add", {});
                            },
                            child: Image.asset('assets/sub2.png',
                                width: 20, height: 20),
                          )
                        ],
                      ),
                      Divider(),
                      goalsList.length != 0
                          ? ListView.builder(
                              itemCount: goalsList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int pos) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(goalsList[pos]['description'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Spacer(),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/delete_ic.png',
                                              width: 15,
                                              height: 17),
                                          onTap: () {
                                            showGoalRemoveDialog(
                                                'goal', goalsList[pos]['_id']);
                                          },
                                        ),
                                        SizedBox(width: 18),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/edit_ic.png',
                                              width: 15,
                                              height: 17),
                                          onTap: () {
                                            goalController.text =
                                                goalsList[pos]['description'];
                                            _showGoalBottomSheet(
                                                "Update", goalsList[pos]);
                                          },
                                        ),
                                        SizedBox(width: 5)
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                );
                              })
                          : Container(
                              height: 70,
                              child: Center(
                                child: Text('No goals found'),
                              ),
                            ),
                      goalsList.length > 2
                          ? GestureDetector(
                              onTap: () {
                                goalPage++;
                                fetchPaginatedData(context, "goal");
                              },
                              child: Text('View More',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14)),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Notes',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          GestureDetector(
                              onTap: () {
                                notesController.text = "";
                                _addNotesBottomSheet('Add', {});
                              },
                              child: Image.asset('assets/sub2.png',
                                  width: 20, height: 20))
                        ],
                      ),
                      Divider(),
                      notesList.length != 0
                          ? ListView.builder(
                              itemCount: notesList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int pos) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(notesList[pos]['description'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Spacer(),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/delete_ic.png',
                                              width: 15,
                                              height: 17),
                                          onTap: () {
                                            showGoalRemoveDialog(
                                                'notes', notesList[pos]['_id']);
                                          },
                                        ),
                                        SizedBox(width: 18),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/edit_ic.png',
                                              width: 15,
                                              height: 17),
                                          onTap: () {
                                            notesController.text =
                                                notesList[pos]['description'];
                                            _addNotesBottomSheet(
                                                "Update", notesList[pos]);
                                          },
                                        ),
                                        SizedBox(width: 5)
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                );
                              })
                          : Container(
                              height: 70,
                              child: const Center(
                                child: Text('No notes found'),
                              ),
                            ),
                      notesList.length > 2
                          ? GestureDetector(
                              onTap: () {
                                notesPage++;
                                fetchPaginatedData(context, "notes");
                              },
                              child: Text('View More',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14)),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Limitations',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          GestureDetector(
                            onTap: () {
                              limitationsController.text = "";

                              _addLimitationsBottomSheet('Add', {});
                            },
                            child: Image.asset('assets/sub2.png',
                                width: 20, height: 20),
                          )
                        ],
                      ),
                      const Divider(),
                      limitationList.length != 0
                          ? ListView.builder(
                              itemCount: limitationList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int pos) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            limitationList[pos]
                                                        ['description'] !=
                                                    null
                                                ? limitationList[pos]
                                                    ['description']
                                                : "NA",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Spacer(),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/delete_ic.png',
                                              width: 15,
                                              height: 17),
                                          onTap: () {
                                            showGoalRemoveDialog('limitations',
                                                limitationList[pos]['_id']);
                                          },
                                        ),
                                        SizedBox(width: 18),
                                        GestureDetector(
                                          onTap: () {
                                            limitationsController.text =
                                                limitationList[pos]
                                                    ['description'];
                                            _addLimitationsBottomSheet(
                                                "Update", limitationList[pos]);
                                          },
                                          child: Image.asset(
                                              'assets/edit_ic.png',
                                              width: 15,
                                              height: 17),
                                        ),
                                        SizedBox(width: 5)
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                );
                              })
                          : Container(
                              height: 70,
                              child: Center(
                                child: Text('No limitations found'),
                              ),
                            ),
                      Divider(),
                      limitationList.length > 2
                          ? GestureDetector(
                              onTap: () {
                                limitationsPage++;
                                fetchPaginatedData(context, "limitations");
                              },
                              child: Text('View More',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14)),
                            )
                          : Container(),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Equipments',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          GestureDetector(
                            onTap: () {
                              equipmentsController.text = "";
                              _addEquipmentsBottomSheet('Add', {});
                            },
                            child: Image.asset('assets/sub2.png',
                                width: 20, height: 20),
                          )
                        ],
                      ),
                      Divider(),
                      equipmentsList.length != 0
                          ? ListView.builder(
                              itemCount: equipmentsList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int pos) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(equipmentsList[pos]['description'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Spacer(),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/delete_ic.png',
                                              width: 15,
                                              height: 17),
                                          onTap: () {
                                            showGoalRemoveDialog('equipments',
                                                equipmentsList[pos]['_id']);
                                          },
                                        ),
                                        SizedBox(width: 18),
                                        GestureDetector(
                                          child: Image.asset(
                                              'assets/edit_ic.png',
                                              width: 15,
                                              height: 17),
                                          onTap: () {
                                            equipmentsController.text =
                                                equipmentsList[pos]
                                                    ['description'];
                                            _addEquipmentsBottomSheet(
                                                "Update", equipmentsList[pos]);
                                          },
                                        ),
                                        SizedBox(width: 5)
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                );
                              })
                          : Container(
                              height: 70,
                              child: Center(
                                child: Text('No equipments found'),
                              ),
                            ),
                      equipmentsList.length > 2
                          ? GestureDetector(
                              onTap: () {
                                equipmentPage++;
                                fetchPaginatedData(context, "equipments");
                              },
                              child: Text('View More',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14)),
                            )
                          : Container(),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Progress ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text('Pictures',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
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
                    InkWell(
                      onTap: () async {
                        final data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProgressPictures()));
                        if (data != null) {
                          print("Refresh Screen");
                          fetchProgressivePictures(context);
                        }
                      },
                      child: Image.asset(
                        'assets/add_black_ic.png',
                        width: 42,
                        height: 42,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: progressList.length != 0
                        ? ListView.builder(
                            itemCount: progressList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int pos) {
                              return Row(
                                children: [
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        progressivePictureBase +
                                                            progressList[pos][
                                                                'progressive_image']))),
                                          ),
                                          onTap: () async {
                                            final data = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProgressPictureView(
                                                            progressList[pos]
                                                                ['images'],
                                                            progressivePictureBase,
                                                            progressList[pos]
                                                                ['title'],
                                                            progressList[pos][
                                                                'taken_on_date'],
                                                            progressList[pos]
                                                                ["_id"])));
                                            if (data != null) {
                                              fetchProgressivePictures(context);
                                            }
                                          },
                                        ),
                                        SizedBox(height: 8),
                                        Text(progressList[pos]['title'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                        SizedBox(height: 3),
                                        Text(progressList[pos]['taken_on_date'],
                                            style: TextStyle(
                                                color: Color(0xFF9A9CB8),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10)
                                ],
                              );
                            })
                        : Center(
                            child: Text('No images found'),
                          )),
              ),
              SizedBox(height: 15),
            /*  Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('App ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text('Space Utilizations',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        SizedBox(height: 3),
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
              ),*/
           /*   SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                elevation: 5,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: CircularPercentIndicator(
                          radius: 55.0,
                          lineWidth: 14.0,
                          animation: true,
                          percent:
                              double.parse(spacePercentage.toString()) / 100,
                          center: Text(
                            spacePercentage.toStringAsFixed(2) + "%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: AppTheme.blueColor),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: AppTheme.themeColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Total Space",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Color(0xFF01345B)),
                            ),
                          ),
                          SizedBox(height: 2),
                          Center(
                            child: Text(
                              // totalSpace,
                              totalSpace + "MB",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.0,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Space Consumed : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    color: Color(0xFF01345B)),
                              ),
                              Text(
                                spaceConsumed + "MB",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Space Available    : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    color: Color(0xFF01345B)),
                              ),
                              Text(
                                remainingSpace + "MB",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ),*/
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  _logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginOTPScreen()),
        (Route<dynamic> route) => false);
  }

  _showCategoryDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, dialogState) {
          return Align(
            alignment: Alignment.bottomCenter,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Select ',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text('Category',
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
                    SizedBox(height: 16),
                    Divider(),


               /*     Row(
                      children: [

                        Spacer(),
                        Icon(Icons.add,color: AppTheme.blueColor),
                        SizedBox(width: 10,)
                      ],
                    ),*/

                    SizedBox(height: 16),
                    Container(
                      height: 250,
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                crossAxisCount: 3,
                                childAspectRatio: (2 / 2.4)),
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              dialogState(() {
                                selectedCategoryIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedCategoryIndex == index
                                    ? AppTheme.blueColor
                                    : Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  selectedCategoryIndex == index
                                      ? Row(
                                          children: [
                                            Spacer(),
                                            Container(
                                                transform:
                                                    Matrix4.translationValues(
                                                        -5.0, 5.0, 0.0),
                                                child: Image.asset(
                                                    'assets/check_ic.png',
                                                    width: 20,
                                                    height: 22))
                                          ],
                                        )
                                      : const SizedBox(height: 15),
                                  selectedCategoryIndex == index
                                      ? Image.network(
                                          imageUrl +
                                              categoryList[index]
                                                  ['category_image'],
                                          width: 45,
                                          height: 45,
                                          color: AppTheme.themeColor)
                                      : Image.network(
                                          imageUrl +
                                              categoryList[index]
                                                  ['category_image'],
                                          width: 45,
                                          height: 45),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: selectedCategoryIndex == index
                                            ? Text(
                                                categoryList[index]['category'],
                                                style: const TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppTheme.themeColor,
                                                ),textAlign: TextAlign.center)
                                            : Text(
                                                categoryList[index]['category'],
                                                style: const TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),textAlign: TextAlign.center)),
                                  ),
                                ],
                              ),
                            ),
                          );
                          // Item rendering
                        },
                      ),
                    ),
                    SizedBox(height: 27),
                    Container(
                      margin: EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 25),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Update',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.5)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          onPressed: () {
                            if (selectedCategoryIndex != 9999) {
                            MyUtils.saveSharedPreferences('current_category_id',categoryList[selectedCategoryIndex]
                            ['category_id']);
                              print(categoryList[selectedCategoryIndex]
                                  ['category_id']);
                              Navigator.pop(context);

                              refreshHomeScreenData(
                                  categoryList[selectedCategoryIndex]
                                      ['category_id'],
                                  imageUrl +
                                      categoryList[selectedCategoryIndex]
                                          ['category_image']);
                            }
                          }),
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 22),
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



  _showHintDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, dialogState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Row(
                      children: [
                        Spacer(),

                       GestureDetector(
                           onTap: (){
                             Navigator.pop(context);
                           },

                           child: Image.asset("assets/cross_ic.png",width: 27,height:27)),

                        SizedBox(width: 15)

                      ],
                    ),


                    Container(
                     // transform: Matrix4.translationValues(80.0, -200.0, 0.0),
                      child: Row(
                        children: [

                          SizedBox(width: 40),


                          Expanded(child: Container(


                              child: Image.asset("assets/tour_1.png",height: 200))),


                        ],
                      ),
                    ),


                    SizedBox(height: 5),





                    Container(
                    //  transform: Matrix4.translationValues(10.0, -220.0, 0.0),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Text("Welcome\nOnboard! ",
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 140,
                     // transform: Matrix4.translationValues(10.0, -200.0, 0.0),
                      child: Scrollbar(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Row(
                              children: [

                                SizedBox(width: 15),
                                Expanded(
                                  child: Text("Embark on a journey of seamless connectivity and personalized experiences. Join us to experience firsthand how Klubba revolutionizes the way you engage in your favorite sports and hobbies. From seamless team coordination to personalized scheduling, Klubba is your go-to companion for optimizing your sports and extracurricular experiences. Discover the power of streamlined communication, effortless event planning, and a vibrant community, all in the palm of your hand. Let Klubba be your partner in making every moment count in the world of sports and extracurricular & adventures!",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      )),
                                ),

                                SizedBox(width: 15),
                              ],
                            ),
                          ],
                        ),
                      )
                    ),


                    SizedBox(height: 25),



                    Container(
                      margin: EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 25),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Start Tour',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.5,fontWeight: FontWeight.w700)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFfFF0038)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ))),
                          onPressed: () {
                            Navigator.pop(context);

                            createTutorial();
                            showTutorial();

                          }),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
                margin: EdgeInsets.only(top: 15),
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





  /* verifyUserOTP(BuildContext context, Map<String, dynamic> requestModel) async {
    var response =
    await helper.postAPI('OtpVerifiaction', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['status'] == 1) {
      // success
      Route route = MaterialPageRoute(builder: (context) => const SignUpSuccess());
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
      Toast.show('OTP verified successfully !',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
    } else {
      ToastContext().init(context);
      Toast.show(responseJSON['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }*/

  fetchGoals(BuildContext context) async {
    if (goalsList.length != 0) {
      goalsList.clear();
    }

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getUserDashboardActivities",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 2,
        "current_role": "5d9f36d40a57e8022e67f3fb",
        "type": [
          "goal",
          "notes",
          "limitations",
          "equipments",
          "skill-set",
          "nutrition",
          "fitness",
          "self-performance",
          "coach-performance"
        ],
        "current_category_id": catId,
        "action_performed_by": id
      },
      "action_performed_by": id
    };

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getUserDashboardActivities', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    goalsList = responseJSON['decodedData']['result'][0]['goal']['result'];
    notesList = responseJSON['decodedData']['result'][1]['notes']['result'];
    limitationList =
        responseJSON['decodedData']['result'][2]['limitations']['result'];
    equipmentsList =
        responseJSON['decodedData']['result'][3]['equipments']['result'];
    setState(() {});
  }

  fetchPaginatedData(BuildContext context, String type) async {
    APIDialog.showAlertDialog(context, 'Please wait...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getUserDashboardActivities",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": type == "goal"
            ? goalPage
            : type == "notes"
                ? notesPage
                : type == "limitations"
                    ? limitationsPage
                    : equipmentPage,
        "pageSize": 2,
        "current_role": "5d9f36d40a57e8022e67f3fb",
        "type": [type],
        "current_category_id": catId,
        "action_performed_by": id
      },
      "action_performed_by": id
    };

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getUserDashboardActivities', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    List<dynamic> latestData = [];

    if (type == "goal") {
      responseJSON['decodedData']['result'][0]["goal"]['result'];
    } else if (type == "notes") {
      responseJSON['decodedData']['result'][0]["notes"]['result'];
    } else if (type == "limitations") {
      responseJSON['decodedData']['result'][0]["limitations"]['result'];
    } else {
      responseJSON['decodedData']['result'][0]["equipments"]['result'];
    }

    if (latestData.length == 0) {
      Toast.show("No data Found !!",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    if (type == "goal") {
      goalsList = goalsList + latestData;
    } else if (type == "notes") {
      notesList = notesList + latestData;
    } else if (type == "limitations") {
      limitationList = limitationList + latestData;
    } else {
      equipmentsList = equipmentsList + latestData;
    }

    setState(() {});
  }

  fetchNotes(BuildContext context) async {
    if (notesList.length != 0) {
      notesList.clear();
    }
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getMyCalendar",
      "data": {
        "slug": AppModel.slug,
        "type": ["notes"],
        "pageNumber": 0,
        "pageSize": 2,
        "orderColumn": "created",
        "orderDir": "desc",
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
    notesList = responseJSON['decodedData']['result'];
    setState(() {});
  }

  fetchEquipments(BuildContext context) async {
    if (equipmentsList.length != 0) {
      equipmentsList.clear();
    }
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getMyCalendar",
      "data": {
        "slug": AppModel.slug,
        "type": ["equipments"],
        "pageNumber": 0,
        "pageSize": 2,
        "orderColumn": "created",
        "orderDir": "desc",
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
    equipmentsList = responseJSON['decodedData']['result'];
    setState(() {});
  }

  fetchLimitations(BuildContext context) async {
    if (limitationList.length != 0) {
      limitationList.clear();
    }
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getMyCalendar",
      "data": {
        "slug": AppModel.slug,
        "type": ["limitations"],
        "pageNumber": 0,
        "pageSize": 2,
        "orderColumn": "created",
        "orderDir": "desc",
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
    limitationList = responseJSON['decodedData']['result'];
    setState(() {});
  }

  _fetchCategoryList(BuildContext context) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    print("CATTT "+catId.toString());

    var data = {
      "method_name": "getLearnerCategoryList",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "asc",
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getLearnerCategoryList', requestModel, context);
    var responseJSON = json.decode(response.body);
    categoryList = responseJSON['decodedData']['result'];
    imageUrl = responseJSON['decodedData']['image_url'];
    if (categoryList.length != 0) {
      for(int i=0;i<categoryList.length;i++)
        {
          if(catId==categoryList[i]['category_id'])
            {
              print("Element Found");
              selectedCategoryIndex=i;
              currentCategoryImageUrl = imageUrl + categoryList[i]['category_image'];
              break;
            }
        }
    }
    setState(() {});
    print(responseJSON);
  }


  checkCategory() async {
    String? currentcatId=await MyUtils.getSharedPreferences("current_category_id");
    if(currentcatId=='' || currentcatId==null)
      {
        Toast.show("Please add a category to continue!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => AddCategoryScreen()));
      }

  }

  fetchSpaceUtilizations(BuildContext context) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getUtilizations",
      "data": {
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
        await helper.postAPI('getUtilizations', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    double total = responseJSON['decodedData']['result']['total_space'] / 1024;
    totalSpace = total.toStringAsFixed(0);

    double remaining =
        responseJSON['decodedData']['result']['remaining_space'] / 1024;
    remainingSpace = remaining.toStringAsFixed(0);

    double spaceUsed = total - remaining;
    spaceConsumed = spaceUsed.toStringAsFixed(2);

    spacePercentage = responseJSON['decodedData']['result']['space_percentage'];
    setState(() {});
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  //getPromotionalOffersDetails
  fetchBanners(BuildContext context) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getSliderList",
      "data": {
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getSliderList', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    print('BANNERS');

    bannerList = responseJSON['decodedData']['result'];
    bannerImageUrl = responseJSON['decodedData']['image_url'];


    bannerList.insert(0,{
      "_id": "6486b703fc5e4e49d891be88",
      "banner": "video",
      "description": "",
      "mobile_banner": "JUN2023/1686550275517-Picture1.png"
    });




    setState(() {});
  }

  fetchProgressivePictures(BuildContext context) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getProgressivePicture",
      "data": {
        "slug": AppModel.slug,
        "orderDir": "desc",
        "orderColumn": "created",
        "pageNumber": 0,
        "pageSize": 10,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getProgressivePicture', requestModel, context);
    var responseJSON = json.decode(response.body);

    print(responseJSON);
    progressivePictureBase = responseJSON['decodedData']['image_url'];
    progressList = responseJSON['decodedData']['result'];

    setState(() {});
  }

  editGoals(String editType, String description,
      Map<String, dynamic> goalData) async {
    APIDialog.showAlertDialog(context, 'Updating...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "editMyCalendar",
      "data": {
        "type": editType,
        "start_date": goalData['start_date'],
        "end_date": goalData['end_date'],
        "start_time": "00:00",
        "end_time": "23:59",
        "is_off_day": goalData['is_off_day'],
        "is_all_day": goalData['is_all_day'],
        "title": editType,
        "description": description,
        "calendar_token": goalData['_id'],
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
        await helper.postAPI('editMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      fetchGoals(context);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  showGoalRemoveDialog(String type, String calenderID) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Remove",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        deleteGoals(type, calenderID);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove?"),
      content: Text("Are you sure you want to remove ?"),
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

  deleteGoals(String type, String calenderID) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "deleteMyCalendar",
      "data": {
        "calendar_token": calenderID,
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
        await helper.postAPI('deleteMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      fetchGoals(context);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _showGoalBottomSheet(String type, Map<String, dynamic> goalData) {
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Your ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Goal',
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
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(type == 'Add' ? 'Add Goal' : 'Update Goal',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF6F6F6),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            controller: goalController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 5, top: 5),
                                hintText: 'Descriptions(Max 50 Characters)*',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
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
                              if (goalController.text.isEmpty) {
                                Toast.show('Description cannot be blank',
                                    duration: Toast.lengthShort,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              } else {
                                Navigator.pop(context);
                                if (type == 'Add') {
                                  _addGoals('goal', goalController.text);
                                } else {
                                  editGoals(
                                      'goal', goalController.text, goalData);
                                }
                              }
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

  _addGoals(String type, String description) async {
    APIDialog.showAlertDialog(context, 'Please wait');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveMyCalendar",
      "data": {
        "type": type,
        "start_date": "05/01/2024",
        "end_date": "05/01/2024",
        "start_time": "00:00",
        "end_time": "23:59",
        "is_off_day": 0,
        "is_all_day": 0,
        "title": type,
        "description": description,
        "slug": AppModel.slug,
        "current_role": role,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('saveMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      fetchGoals(context);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  _addNotesBottomSheet(String type, Map<String, dynamic> notesData) {
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Add ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Notes',
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
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                            type == 'Add' ? 'Add Notes' : 'Update Notes',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF6F6F6),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            controller: notesController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 5, top: 5),
                                hintText: 'Descriptions(Max 50 Characters)*',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
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
                              if (notesController.text.isEmpty) {
                                Toast.show('Description cannot be blank',
                                    duration: Toast.lengthShort,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              } else {
                                Navigator.pop(context);
                                if (type == 'Add') {
                                  _addGoals('notes', notesController.text);
                                } else {
                                  editGoals(
                                      'notes', notesController.text, notesData);
                                }
                              }
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

  _addLimitationsBottomSheet(
      String type, Map<String, dynamic> limitationsData) {
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Add ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Limitations',
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
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                            type == 'Add'
                                ? 'Add Limitations'
                                : 'Update Limitations',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF6F6F6),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            controller: limitationsController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 5, top: 5),
                                hintText: 'Descriptions(Max 50 Characters)*',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
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
                              if (limitationsController.text.isEmpty) {
                                Toast.show('Description cannot be blank',
                                    duration: Toast.lengthShort,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              } else {
                                Navigator.pop(context);
                                if (type == 'Add') {
                                  _addGoals('limitations',
                                      limitationsController.text);
                                } else {
                                  editGoals(
                                      'limitations',
                                      limitationsController.text,
                                      limitationsData);
                                }
                              }
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

  _addEquipmentsBottomSheet(String type, Map<String, dynamic> equipData) {
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Add ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Equipments',
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
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                            type == 'Add'
                                ? 'Add Equipments'
                                : 'Update Equipments',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF6F6F6),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            controller: equipmentsController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 5, top: 5),
                                hintText: 'Descriptions(Max 50 Characters)*',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
                      ),
                      SizedBox(height: 27),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, top: 5, bottom: 25),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
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
                              if (equipmentsController.text.isEmpty) {
                                Toast.show('Description cannot be blank',
                                    duration: Toast.lengthShort,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              } else {
                                Navigator.pop(context);

                                if (type == 'Add') {
                                  _addGoals(
                                      'equipments', equipmentsController.text);
                                } else {
                                  editGoals('equipments',
                                      equipmentsController.text, equipData);
                                }
                              }
                            },
                            child: Text('Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.5))),
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

  fetchPlanner(BuildContext context) async {
    print('API Planner');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getUserDashboardActivities",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 10,
        "current_role": currentRole,
        "type": [
          "skill-set",
          "nutrition",
          "fitness",
          "self-performance",
          "coach-performance"
        ],
        "current_category_id": catId,
        "action_performed_by": id
      },
      "action_performed_by": id
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getUserDashboardActivities', requestModel, context);
    var responseJSON = json.decode(response.body);
    plannerList =
        responseJSON['decodedData']['result'][4]['skill-set']['result'];
    nutritionList =
        responseJSON['decodedData']['result'][5]['nutrition']['result'];
    fitnessList = responseJSON['decodedData']['result'][6]['fitness']['result'];
    selfData = responseJSON['decodedData']['result'][7]['self-performance'];
    coachData = responseJSON['decodedData']['result'][8]['coach-performance'];
    print(responseJSON);
    setState(() {});
    updatePlannerData(DateTime.now().day);
    currentDate = DateTime.now().day.toString() +
        '/' +
        currentMonthCount.toString() +
        "/2024";
    print("Current Date is" + DateTime.now().day.toString());
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

    String? joinedDate=responseJSON['decodedData']["result"]['joined_date'];
    if(joinedDate!=null)
      {
        print("Joinded Date Saved");
        MyUtils.saveSharedPreferences("joined_date", joinedDate);
      }
    setState(() {});

  }
  getLevelOfParticipation() async {
    print('API Planner');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getLevelOfParticipation",
      "data": {
        "user_id": id,
        "current_category_id": catId,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getLevelOfParticipation', requestModel, context);
    var responseJSON = json.decode(response.body);

    nutritionSlider= double.parse(responseJSON['decodedData']['result']['nutrition'].toString());
    fitnessSlider= double.parse(responseJSON['decodedData']['result']['fitness'].toString());
    skillSetSlider= double.parse(responseJSON['decodedData']['result']['skill'].toString());
    totalDays= responseJSON['decodedData']['result']['total_days'].toString();


    setState(() {

    });
  }
  fetchPercentage() async {
    print('API Planner');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getAssessmentPercentage",
      "data": {
        "user_id": id,
        "current_category_id": catId,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getAssessmentPercentage', requestModel, context);
    var responseJSON = json.decode(response.body);

    percentageData= responseJSON['decodedData']['result'];


    setState(() {

    });
  }
  updatePlannerData(int date) {
    print("Selected Date " + date.toString());
    currentDate =
        date.toString() + '/' + currentMonthCount.toString() + "/2024";
    print("Current Date is" + currentDate);
    print(plannerList.length);
    for (int i = 0; i < plannerList.length; i++) {
      print(returnDateInFormat(plannerList[i]['end_date']));
      if (returnDateInFormat(plannerList[i]['end_date']) == currentDate) {
        hasData = true;
        dataIndex = i;
      }
    }
  }

  _fetchCurrentMonth() {
    currentMonthCount = DateTime.now().month;
    currentMonthName = monthName[currentMonthCount];
    print('Current month Name ' + currentMonthName);
    _fetchCurrentMonthDaysCount();
    setState(() {});
  }

  _fetchCurrentMonthDaysCount() {
    print("Current month count is " + currentMonthCount.toString());
    DateTime x1 = DateTime(2024, currentMonthCount, 0).toUtc();
    int y1 =
        DateTime(2024, currentMonthCount + 1, 0).toUtc().difference(x1).inDays;
    print('Selected Days Count ' + y1.toString());
    currentDaysCount = y1;

    setState(() {});
  }

  String returnDateInFormat(String date) {
    final format = new DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    var dateTime22 = format.parse(date, true);
    final DateFormat dayFormatter = DateFormat.d();
    final DateFormat monthFormatter = DateFormat.yM();
    String dayAsString = dayFormatter.format(dateTime22);
    String monthString = monthFormatter.format(dateTime22);
    String finalString = dayAsString + "/" + monthString;
    print(finalString);
    return finalString;
  }

  String returnDateInFormat2(String date) {
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    var dateTime22 = format.parse(date, true);
    final DateFormat dayFormatter = DateFormat.yMMMd();
    String dayAsString = dayFormatter.format(dateTime22);
    return dayAsString;
  }

  String fetchDayName(String date) {
    final format = DateFormat('dd/MM/yyyy');
    final dateTime = format.parse(date);
    final DateFormat format1 = DateFormat('EEE');
    String dayName = format1.format(dateTime);
    return dayName;
  }

  _showRemainderDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 600),
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
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: [
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 80, height: 3, color: Color(0xFFAAAAAA)),
                        ],
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
                            Text('Add ',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Remainder',
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
                      SizedBox(height: 12),
                      Center(
                        child: Text('(Only visible to you)',
                            style: TextStyle(
                                color: Color(0xFF9A9CB8), fontSize: 12)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Divider(),
                      ),
                      TimePickerSpinner(
                        is24HourMode: false,
                        normalTextStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAFAFAF)),
                        highlightedTextStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        spacing: 35,
                        itemHeight: 40,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            dateTime = time;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF6F6F6),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                            controller: remainderController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 5, top: 5),
                                hintText: 'Descriptions(Max 50 Characters)*',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
                      ),
                      SizedBox(height: 12),
                      Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              Text('Select Reminder Color',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          )),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          SizedBox(width: 12),
                          GestureDetector(
                              onTap: () {
                                dialogState(() {
                                  selectedColorIndex = 0;
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xFF5AA6F2)),
                                  ),
                                  selectedColorIndex == 0
                                      ? Container(
                                          width: 45,
                                          height: 45,
                                          padding:
                                              EdgeInsets.only(right: 3, top: 3),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Image.asset(
                                                'assets/check_ic.png',
                                                width: 17,
                                                height: 17),
                                          ),
                                        )
                                      : Container()
                                ],
                              )),
                          SizedBox(width: 10),
                          GestureDetector(
                              onTap: () {
                                dialogState(() {
                                  selectedColorIndex = 1;
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xFFF2717A)),
                                  ),
                                  selectedColorIndex == 1
                                      ? Container(
                                          width: 45,
                                          height: 45,
                                          padding:
                                              EdgeInsets.only(right: 3, top: 3),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Image.asset(
                                                'assets/check_ic.png',
                                                width: 17,
                                                height: 17),
                                          ),
                                        )
                                      : Container()
                                ],
                              )),
                          SizedBox(width: 10),
                          GestureDetector(
                              onTap: () {
                                dialogState(() {
                                  selectedColorIndex = 2;
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xFF5DDFB6)),
                                  ),
                                  selectedColorIndex == 2
                                      ? Container(
                                          width: 45,
                                          height: 45,
                                          padding:
                                              EdgeInsets.only(right: 3, top: 3),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Image.asset(
                                                'assets/check_ic.png',
                                                width: 17,
                                                height: 17),
                                          ),
                                        )
                                      : Container()
                                ],
                              )),
                          SizedBox(width: 10),
                          GestureDetector(
                              onTap: () {
                                dialogState(() {
                                  selectedColorIndex = 3;
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xFFFCB36E)),
                                  ),
                                  selectedColorIndex == 3
                                      ? Container(
                                          width: 45,
                                          height: 45,
                                          padding:
                                              EdgeInsets.only(right: 3, top: 3),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Image.asset(
                                                'assets/check_ic.png',
                                                width: 17,
                                                height: 17),
                                          ),
                                        )
                                      : Container()
                                ],
                              )),
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.only(
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
                              if (remainderController.text.isEmpty) {
                                Toast.show('Description cannot be blank !!',
                                    duration: Toast.lengthShort,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              } else {
                                Navigator.pop(context);
                                addRemainder();
                              }
                            }),
                      ),
                      SizedBox(height: 10),
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

  _showCopyDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
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
                  Center(
                    child: Lottie.asset('assets/copy.json'),
                  ),
                  SizedBox(height: 35),
                  Text('You have Successfully Activity Copied',
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  SizedBox(height: 38),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Back',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.5)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ))),
                        onPressed: () => null),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              margin: EdgeInsets.only(top: 22),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, true ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  addRemainder() async {
    APIDialog.showAlertDialog(context, "Please wait");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    String formattedTime = DateFormat.Hms().format(dateTime);

    String color = '';
    if (selectedColorIndex == 0) {
      color = 'blue';
    } else if (selectedColorIndex == 1) {
      color = 'red';
    } else if (selectedColorIndex == 2) {
      color = 'green';
    } else if (selectedColorIndex == 3) {
      color = 'orange';
    }

    var data = {
      "data": {
        "type": "reminder",
        "start_date": currentDate,
        "end_date": currentDate,
        "start_time": formattedTime,
        "end_time": "23:59",
        "title": "Reminder",
        "description": remainderController.text,
        "color": color,
        "calendar_token": "",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      },
      "method_name": "saveMyCalendar"
    };

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('saveMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    //calenderList = responseJSON['decodedData']['result'];

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  fetchLibraryByID(String libraryID, String type) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getDigitalLibraryById",
      "data": {
        "id": libraryID,
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
        await helper.postAPI('getDigitalLibraryById', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    Map<String, dynamic> libraryData = responseJSON['decodedData']['result'][0];
    if (type == "video") {
      String videoID = libraryData['library_video_url'].split('/').last;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => VimeoPlayer22(videoID)));
    } else if (type == "pdf") {
      //Check base url path
      print("PDF");
      String pdfUrl = AppConstant.digitalLibraryStagingBaseURL +
          libraryData['digital_library_path'] +
          "/" +
          libraryData['images'][0]['image'];
      print("PDF URL Is " + pdfUrl);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PDFView(pdfUrl)));
    } else {
      String imageUrl = AppConstant.digitalLibraryStagingBaseURL +
          libraryData['digital_library_path'] +
          "/" +
          libraryData['images'][0]['image'];
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImageView(imageUrl)));
    }
  }
  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }
  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return  Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[



                  Container(
                    height: 165,
                    margin: EdgeInsets.only(right: 50,bottom: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 20),

                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF1A1A1A),
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Select ',
                                  style: const TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Category',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),

                          Text('Select your category in a single click.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),

                          SizedBox(height: 20),

                          Row(
                            children: [

                              GestureDetector(
                                child: Container(
                                  width: 85,
                                  height: 39,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0056D6),
                                    borderRadius: BorderRadius.circular(4)
                                  ),

                                  child: Center(
                                    child:  Text('Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ),
                                onTap: (){
                                  tutorialCoachMark.goTo(1);
                                },
                              ),


                              SizedBox(width: 10),

                              InkWell(
                                onTap: (){
                                  tutorialCoachMark.finish();
                                },
                                child: Container(
                                  width: 85,
                                  height: 39,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFED2F59),
                                      borderRadius: BorderRadius.circular(4)
                                  ),

                                  child: Center(
                                    child:  Text('Exit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ),
                              )



                            ],
                          )



                        ],
                      ),
                    ),




                  )

                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return  Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[



                  Container(
                    height: 165,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 20),

                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF1A1A1A),
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Assignments ',
                                  style: const TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'To Do',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),

                          Text('Stay organized and on top of your tasks with Klubba.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),

                          SizedBox(height: 20),

                          Row(
                            children: [


                              GestureDetector(
                                child: Container(
                                  width: 92,
                                  height: 39,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF9A9CB8),
                                      borderRadius: BorderRadius.circular(4)
                                  ),

                                  child: Center(
                                    child:  Text('Previous',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ),
                                onTap: (){
                                  tutorialCoachMark.goTo(0);
                                },
                              ),


                              SizedBox(width: 10),

                              GestureDetector(
                                onTap: (){
                                  _scrollController.animateTo(_scrollController.position.minScrollExtent+400, duration: const Duration(milliseconds: 510), curve: Curves.easeOut);
                                  setState(() {

                                  });
                                  tutorialCoachMark.goTo(2);
                                },
                                child: Container(
                                  width: 85,
                                  height: 39,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF0056D6),
                                      borderRadius: BorderRadius.circular(4)
                                  ),

                                  child: Center(
                                    child:  Text('Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ),
                              ),


                              SizedBox(width: 10),

                              InkWell(
                                onTap: (){
                                  tutorialCoachMark.finish();
                                },
                                child: Container(
                                  width: 85,
                                  height: 39,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFED2F59),
                                      borderRadius: BorderRadius.circular(4)
                                  ),

                                  child: Center(
                                    child:  Text('Exit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ),
                              )



                            ],
                          )



                        ],
                      ),
                    ),




                  )

                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: keyBottomNavigation3,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return  Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[



                  Container(
                    height: 165,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 20),

                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF1A1A1A),
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Level ',
                                  style: const TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Of Participation ',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),

                          Text('Elevate your engagement by checking where you stand.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),

                          SizedBox(height: 20),

                          Row(
                            children: [


                              GestureDetector(
                                child: Container(
                                  width: 92,
                                  height: 39,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF9A9CB8),
                                      borderRadius: BorderRadius.circular(4)
                                  ),

                                  child: Center(
                                    child:  Text('Previous',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ),
                                onTap: (){
                                  _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 510), curve: Curves.easeOut);
                                  setState(() {

                                  });
                                  tutorialCoachMark.goTo(1);
                                },
                              ),


                              SizedBox(width: 10),

                              InkWell(
                                onTap: (){
                                  tutorialCoachMark.finish();
                                },
                                child: Container(
                                  width: 85,
                                  height: 39,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFED2F59),
                                      borderRadius: BorderRadius.circular(4)
                                  ),

                                  child: Center(
                                    child:  Text('Exit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                ),
                              )



                            ],
                          )



                        ],
                      ),
                    ),




                  )

                ],
              );
            },
          ),
        ],
      ),
    );


    return targets;
  }
  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }
}
