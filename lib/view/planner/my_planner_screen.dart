import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/planner/add_assignment_screen.dart';
import 'package:klubba/view/planner/add_rest_day_screen.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/planner/assignment_detail_screen.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:klubba/view/notification/notification_screen.dart';
import 'package:klubba/view/planner/planner_success.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toast/toast.dart';

class MyPlannerScreen extends StatefulWidget {
  final bool showBackButton;

  MyPlannerScreen(this.showBackButton);

  MyPlannerState createState() => MyPlannerState();
}

class MyPlannerState extends State<MyPlannerScreen> {
  String currentYear = "2025";
  bool categoryExists = false;
  int scrollingIndex=0;
  List<String> yearList = [];
  String initialDropDownVal = "2025";
  bool firstTimefetch = true;
  int currentMonthCount = DateTime.now().month;
  int currentDaysCount = 0;
  bool userSubscribe = false;
  Map<String, dynamic>? copyPlannerData2;
  String startDateCopy = "";
  String endDateCopy = "";
  int selectedCategoryIndex = 9999;
  String imageUrl = '';
  List<dynamic> categoryList = [];
  String selectedColor = '';
  var remainderController = TextEditingController();
  DateTime dateTime = DateTime.now();
  List<dynamic> bookedSlotsList = [];
  List<dynamic> bookedSlotsListTailor = [];
  List<dynamic> tailorList = [];
  late ScrollOffsetController scrollOffsetController;
  late ItemPositionsListener itemPositionsListener;
  late ScrollOffsetListener scrollOffsetListener;
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
  String currentCategoryImageUrl = '';
  String? imageURL = '';

  List<dynamic> calenderList = [];
  bool tailorMode = false;
  int selectedColorIndex = 0;

  DateTime selectedDate = DateTime.now();

  // TO tracking date
  String currentMonthName = '';
  String previousMonthName = '';

  String currentCategoryID = '';
  String currentCategoryGroupID = '';
  String nextMonthName = '';
  int currentDateSelectedIndex = 0; //For Horizontal Date
  late ItemScrollController scrollController; //To Track Scroll of ListView

  List<String> listOfMonths = ["Nov"];

  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        leading: IconButton(
          icon: widget.showBackButton
              ? Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black)
              : Container(),
          onPressed: () {
            if (widget.showBackButton) {
              Navigator.of(context).pop();
            } else {
              print("No click");
            }
          },
        ),
        backgroundColor: AppTheme.themeColor,
        actions: [
          GestureDetector(
            onTap: () {
              _showCategoryDialog();
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border:
                      Border.all(width: 1.5, color: const Color(0xFFCEAC45))),
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
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen(false)));
            },
            child: Padding(
                padding: EdgeInsets.only(right: 13),
                child:
                    Icon(Icons.shopping_cart, color: Colors.black, size: 27)),
          ),
        ],
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'My ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Planner',
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
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : !categoryExists
              ? Container()
              :

              /* Column(
        children: [
          SizedBox(height: 15),
          Container(
            height: 48,
            margin: EdgeInsets.symmetric(horizontal: 60),
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppTheme.themeColor,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tailor Made Program',
                    style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                SizedBox(width: 15),
                Image.asset('assets/planner_header.png',
                    width: 25.18, height: 31.55),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 47,
            color: Color(0xFFF3F3F3),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios_new_sharp, size: 12),
                SizedBox(width: 3),
                Text('October',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                Expanded(
                    child: Center(
                        child: Text('November',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.blueColor)))),
                Text('December',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                SizedBox(width: 3),
                Icon(Icons.keyboard_arrow_right_outlined, size: 12),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 15),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int pos) {
                    return Column(
                      children: [
                        pos == 1
                            ? Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFF6F6F6)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Spacer(),
                                        Container(
                                          transform: Matrix4.translationValues(
                                              8.0, -25.0, 0.0),
                                          width: 85,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: AppTheme.themeColor,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Center(
                                            child: Text('01 Nov',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.5)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/sub2.png',
                                            width: 35, height: 35),
                                        SizedBox(width: 25),
                                        Image.asset(
                                          'assets/sub3.png',
                                          width: 35,
                                          height: 35,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(),
                                    SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Reminder',
                                                style: TextStyle(
                                                    color: AppTheme.blueColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12)),
                                            Row(
                                              children: [
                                                Text('No Remainder Set',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12)),
                                                SizedBox(width: 10),
                                                Image.asset('assets/sub1.png',
                                                    width: 30, height: 30)
                                              ],
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 41,
                                          child: ElevatedButton(
                                              child: Text('0 Assignment',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ))),
                                              onPressed: () => null),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFF6F6F6)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Title',
                                                  style: TextStyle(
                                                      color: AppTheme.blueColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12)),
                                              Text('Simple Dummy Text',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          transform: Matrix4.translationValues(
                                              8.0, -25.0, 0.0),
                                          width: 85,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: AppTheme.themeColor,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Center(
                                            child: Text('01 Nov',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.5)),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 25),
                                    Text('Description',
                                        style: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                    Text(
                                        'Simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12)),
                                    Divider(),
                                    SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Reminder',
                                                style: TextStyle(
                                                    color: AppTheme.blueColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12)),
                                            Text('01:00 PM',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 41,
                                          child: ElevatedButton(
                                              child: Text('2 Assignment',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ))),
                                              onPressed: () => null),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                        SizedBox(height: 35)
                      ],
                    );
                  }))
        ],
      ),*/

              Column(
                  children: [
                    const SizedBox(height: 15),
                    /* GestureDetector(
                  onTap: () {
                    if (!tailorMode) {
                      _tailorModeDialog();
                    } else {
                      _showRemoveProgramSheet();

                      // fetchMyCalender(context);
                    }
                  },
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            tailorMode
                                ? 'Remove Tailor Made'
                                : 'Tailor Made Program',
                            style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        SizedBox(width: 15),
                        Image.asset('assets/planner_header.png',
                            width: 25.18, height: 31.55),
                      ],
                    ),
                  ),
                ),*/

                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          height: 44,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_box,
                                  size: 18, color: Colors.grey),
                              SizedBox(width: 5),
                              Text('School',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 44,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_box,
                                  size: 18, color: Colors.grey),
                              SizedBox(width: 5),
                              Text('Planner',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 44,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: AppTheme.themeColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    followTMP();
                                  },
                                  child: tailorMode
                                      ? Icon(Icons.check_box,
                                          size: 18, color: Colors.blue)
                                      : Icon(Icons.check_box_outline_blank,
                                          size: 18)),
                              SizedBox(width: 5),
                              Text('Klubba',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 47,
                      color: Color(0xFFF3F3F3),
                      child: Row(
                        children: [


                          previousMonthName=="NA"?

                              SizedBox(width: 40):

                          Container(),


                          previousMonthName=="NA"?
                              Container():
                          Icon(Icons.arrow_back_ios_new_sharp, size: 12),
                          previousMonthName=="NA"?
                          Container():
                          SizedBox(width: 3),
                          previousMonthName=="NA"?
                          Container():
                          GestureDetector(
                            onTap: () {
                              _previousMonth();
                            },
                            child: Text(previousMonthName,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                          Expanded(
                              child: Center(
                                  child: Text(currentMonthName,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.blueColor)))),
                          GestureDetector(
                            onTap: () {
                              _nextMonth();
                            },
                            child: Text(nextMonthName,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                          const SizedBox(width: 3),
                          const Icon(Icons.keyboard_arrow_right_outlined,
                              size: 12),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Text(
                            "Select Year",
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 40,
                            width: 110,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0xFFF6F6F6)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                icon: Icon(Icons.keyboard_arrow_down_outlined,
                                    color: Colors.black),
                                hint: Text(
                                  'Select year',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: yearList
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: initialDropDownVal,
                                onChanged: (value) {
                                  setState(() {
                                    initialDropDownVal = value as String;
                                  });

                                  fetchMyCalender(context);
                                },
                                buttonHeight: 40,
                                buttonWidth: 140,
                                itemHeight: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    //To Show Current Date
                    /*   Container(
              height: 30,
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                selectedDate.day.toString() +
                    '-' +
                    listOfMonths[selectedDate.month - 1] +
                    ', ' +
                    selectedDate.year.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.indigo[700]),
              )),
          SizedBox(height: 10),*/
                    //To show Calendar Widget
                    Expanded(
                        child: Container(
                            child: ScrollablePositionedList.builder(
                      padding: EdgeInsets.only(bottom: 80, top: 20),
                      itemCount: currentDaysCount,
                      initialScrollIndex: scrollingIndex,
                      itemScrollController: scrollController,
                      scrollOffsetController: scrollOffsetController,
                      itemPositionsListener: itemPositionsListener,
                      scrollOffsetListener: scrollOffsetListener,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        List<dynamic> assignments = [];
                        bool hasData = false;
                        bool dateBefore = false;
                        int dataIndex = 0;

                        String currentDate = (index + 1).toString() +
                            "/" +
                            currentMonthCount.toString() +
                            "/" +
                            initialDropDownVal;
                        for (int i = 0; i < bookedSlotsList.length; i++) {
                          if (returnDateInFormat(
                                  bookedSlotsList[i]['end_date']) ==
                              currentDate) {
                            hasData = true;
                            dataIndex = i;
                            assignments.add(bookedSlotsList[i]);
                          }
                        }

                        String date = (index + 1).toString();
                        if (date.length == 1) {
                          date = "0" + date;
                        }
                        String monthCount = "";
                        if (currentMonthCount.toString().length == 1) {
                          monthCount = "0" + currentMonthCount.toString();
                        }

                        String currentDate22 = initialDropDownVal +
                            "-" +
                            monthCount +
                            "-" +
                            date +
                            " 04:33:26.380062";
                        if (DateTime.parse(currentDate22)
                            .isBefore(DateTime.now())) {
                          dateBefore = true;
                        }

                        return Column(
                          children: [
                            hasData
                                ? Column(
                                  children: [
                                    ListView.builder(
                                        itemCount: assignments.length,
                                        itemBuilder:
                                            (BuildContext context, int posX) {
                                          return Stack(
                                            children: [
                                              Container(
                                                // height: 179,
                                                margin: EdgeInsets.only(
                                                    left: 10,right: 10,top:posX == 0? 15:0),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                    color: const Color(0xFFF6F6F6)),
                                                child: Row(
                                                  children: [
                                                    assignments[posX]['color'] != null
                                                        ? Container(
                                                            height: 70,
                                                            color: assignments[posX]
                                                                        ['color'] ==
                                                                    'blue'
                                                                ? Colors.blue
                                                                : assignments[posX]
                                                                            ['color'] ==
                                                                        'red'
                                                                    ? Colors.red
                                                                    : assignments[posX][
                                                                                'color'] ==
                                                                            'green'
                                                                        ? Colors
                                                                            .greenAccent
                                                                        : assignments[posX]
                                                                                    [
                                                                                    'color'] ==
                                                                                'orange'
                                                                            ? Colors
                                                                                .orange
                                                                            : Colors
                                                                                .transparent,
                                                            width: 12,
                                                          )
                                                        : Container(),
                                                    SizedBox(width: 7),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 7),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('Title',
                                                                        style: TextStyle(
                                                                            color: AppTheme
                                                                                .blueColor,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w600,
                                                                            fontSize:
                                                                                12)),
                                                                    Text(
                                                                      assignments[posX]
                                                                          ['title'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          fontSize: 12),
                                                                      maxLines: 2,
                                                                    ),
                                                                    SizedBox(height: 5),




                                                                    assignments[posX][
                                                                    'category_attribute_name']==null?Container():



                                                                    Text('Attributes',
                                                                        style: TextStyle(
                                                                            color: AppTheme
                                                                                .blueColor,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w600,
                                                                            fontSize:
                                                                                11)),

                                                                    assignments[posX][
                                                                    'category_attribute_name']==null?Container():



                                                                    Text(
                                                                      assignments[posX][
                                                                                  'category_attribute_name'] !=
                                                                              null
                                                                          ? assignments[
                                                                                  posX][
                                                                              'category_attribute_name']
                                                                          : "NA",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          fontSize: 11),
                                                                      maxLines: 2,
                                                                    ),
                                                                    SizedBox(height: 5),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 5),

                                                            ],
                                                          ),
                                                          SizedBox(height: 25),
                                                          Row(
                                                            children: [
                                                              assignments[posX][
                                                                          'created_by'] ==
                                                                      "user"
                                                                  ? GestureDetector(
                                                                onTap:(){

                                                                  showAssignmentRemoveDialog(assignments[posX][
                                                                  '_id']);
                                                  },
                                                                    child: Icon(Icons.delete,
                                                                        color: AppTheme
                                                                            .blueColor),
                                                                  )
                                                                  : Container(),
                                                              Spacer(),
                                                              dateBefore
                                                                  ? Container()
                                                                  : GestureDetector(
                                                                      onTap: () async {
                                                                        int date =
                                                                            (index + 1);

                                                                        print('Current Month ' +
                                                                            currentMonthCount
                                                                                .toString());

                                                                        String selectedDate = date
                                                                                .toString() +
                                                                            "/" +
                                                                            currentMonthCount
                                                                                .toString() +
                                                                            "/" +
                                                                            initialDropDownVal;

                                                                        final data = await Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder:
                                                                                    (context) =>
                                                                                        AddAssignmentScreen(selectedDate)));
                                                                        if (data !=
                                                                            null) {
                                                                          fetchMyCalender(
                                                                              context);
                                                                        }
                                                                      },
                                                                      child: Image.asset(
                                                                          'assets/sub2.png',
                                                                          width: 20,
                                                                          height: 20),
                                                                    ),
                                                              dateBefore
                                                                  ? Container()
                                                                  : SizedBox(width: 10),
                                                              dateBefore
                                                                  ? Container()
                                                                  : AppModel.copyData
                                                                          .isEmpty
                                                                      ? Container()
                                                                      : GestureDetector(
                                                                          onTap: () {
                                                                            int date =
                                                                                (index +
                                                                                    1);

                                                                            print('Current Month ' +
                                                                                currentMonthCount
                                                                                    .toString());

                                                                            String selectedDate = date
                                                                                    .toString() +
                                                                                "/" +
                                                                                currentMonthCount
                                                                                    .toString() +
                                                                                "/" +
                                                                                initialDropDownVal;

                                                                            pasteItems(
                                                                                context,
                                                                                selectedDate);
                                                                          },
                                                                          child: Image.asset(
                                                                              'assets/sub4.png',
                                                                              width: 20,
                                                                              height:
                                                                                  20),
                                                                        ),
                                                              dateBefore
                                                                  ? Container()
                                                                  : AppModel.copyData
                                                                          .isEmpty
                                                                      ? Container()
                                                                      : SizedBox(
                                                                          width: 10),
                                                              assignments[posX][
                                                                          'is_completed'] ==
                                                                      1
                                                                  ? Stack(
                                                                      children: [
                                                                        Container(
                                                                            margin: EdgeInsets.only(
                                                                                right:
                                                                                    15),
                                                                            transform: Matrix4
                                                                                .translationValues(
                                                                                    0.0,
                                                                                    -40.0,
                                                                                    0.0),
                                                                            child: Image.asset(
                                                                                'assets/check_ic.png',
                                                                                width:
                                                                                    22,
                                                                                height:
                                                                                    22)),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            AppModel.setCopyData(
                                                                                assignments[
                                                                                    posX]);
                                                                            print("The data is " +
                                                                                assignments[posX]
                                                                                    .toString());

                                                                            setState(
                                                                                () {});
                                                                            _showCopyDialog();
                                                                          },
                                                                          child: Container(
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .copy)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : assignments[posX][
                                                                              'is_completed'] ==
                                                                          2
                                                                      ? Stack(
                                                                          children: [
                                                                            Container(
                                                                                margin: EdgeInsets.only(
                                                                                    right:
                                                                                        15),
                                                                                transform: Matrix4.translationValues(
                                                                                    0.0,
                                                                                    -40.0,
                                                                                    0.0),
                                                                                child: Image.asset(
                                                                                    'assets/cross_ic.png',
                                                                                    width:
                                                                                        22,
                                                                                    height:
                                                                                        22)),
                                                                            GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                AppModel.setCopyData(
                                                                                    assignments[posX]);
                                                                                print("The data is " +
                                                                                    assignments[posX].toString());
                                                                                setState(
                                                                                    () {});
                                                                                _showCopyDialog();
                                                                              },
                                                                              child: Container(
                                                                                  child:
                                                                                      Icon(Icons.copy)),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap: () {
                                                                            AppModel.setCopyData(
                                                                                assignments[
                                                                                    posX]);
                                                                            print("The data is " +
                                                                                assignments[posX]
                                                                                    .toString());
                                                                            setState(
                                                                                () {});

                                                                            _showCopyDialog();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            child: Icon(
                                                                                Icons
                                                                                    .copy),
                                                                            margin: EdgeInsets.only(
                                                                                right:
                                                                                    15),
                                                                          ),
                                                                        ),
                                                            ],
                                                          ),
                                                          Divider(),
                                                          SizedBox(height: 7),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  assignments[posX][
                                                                              'title'] ==
                                                                          'Reminder'
                                                                      ? Text('Reminder',
                                                                          style: TextStyle(
                                                                              color: AppTheme
                                                                                  .blueColor,
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .w600,
                                                                              fontSize:
                                                                                  12))
                                                                      : Container(),
                                                                  assignments[posX][
                                                                              'title'] ==
                                                                          'Reminder'
                                                                      ? Row(
                                                                          children: [
                                                                            Text(
                                                                                _returnDateFormat(assignments[posX]['start_time']
                                                                                    .toString()),
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.black,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: 12)),
                                                                            SizedBox(
                                                                                width:
                                                                                    5),
                                                                            Image.asset(
                                                                                'assets/sub1.png',
                                                                                width:
                                                                                    30,
                                                                                height:
                                                                                    30),
                                                                          ],
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              assignments[posX][
                                                                              'activities']
                                                                          .length ==
                                                                      0
                                                                  ? Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                              right:
                                                                                  10),
                                                                      child: Text(
                                                                          "No assignments"),
                                                                    )
                                                                  : Container(
                                                                      height: 41,
                                                                      child:
                                                                          ElevatedButton(
                                                                              child: Text(
                                                                                  assignments[posX]['activities'].length.toString() +
                                                                                      ' Assignment',
                                                                                  style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 11.5)),
                                                                              style: ButtonStyle(
                                                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(4),
                                                                                  ))),
                                                                              onPressed: () async {
                                                                                /* if(bookedSlotsList[dataIndex]['activities'].length!=0)
                                                                              {*/
                                                                                int date =
                                                                                    (index +
                                                                                        1);

                                                                                print('Current Month ' +
                                                                                    currentMonthCount.toString());

                                                                                String selectedDate2 = date.toString() +
                                                                                    "/" +
                                                                                    currentMonthCount.toString() +
                                                                                    "/" +
                                                                                    initialDropDownVal;



                                                                                final data = await Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(builder: (context) => AssignmentDetailScreen(selectedDate2, assignments[posX], tailorMode, dateBefore ? "view" : "edit")));
                                                                                if (data !=
                                                                                    null) {
                                                                                  fetchMyCalender(
                                                                                      context);
                                                                                }
                                                                                /* }
                                                                            else
                                                                              {
                                                                                Toast.show("No assignment found !!",
                                                                                    duration: Toast.lengthShort,
                                                                                    gravity: Toast.bottom,
                                                                                    backgroundColor: Colors.red);
                                                                              }
                                              */
                                                                              }),
                                                                    )
                                                            ],
                                                          ),
                                                          posX == assignments.length - 1
                                                              ? Container(
                                                                  margin:
                                                                      EdgeInsets.only(
                                                                          top: 10),
                                                                )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(top: 8),
                                                                  child: Divider(),
                                                                ),
                                                          SizedBox(height: 5),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              posX == 0
                                                  ? Row(
                                                    children: [
                                                      Spacer(),
                                                      Container(

                                                        margin: EdgeInsets.only(right: 10),

                                                                                                  width: 85,
                                                                                                  height: 30,
                                                                                                  decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .themeColor,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            4)),
                                                                                                  child: Center(
                                                      child: Text(
                                                          (index + 1)
                                                              .toString() +
                                                              " " +
                                                              currentMonthName
                                                                  .substring(0,
                                                                  3),
                                                          style: TextStyle(
                                                              color: (index+1)==DateTime.now().day?

                                                              Colors.blue:




                                                              Colors
                                                                  .black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              fontSize:
                                                              12.5)),
                                                                                                  ),
                                                                                                ),
                                                    ],
                                                  )
                                                  : Container(),
                                            ],
                                          );
                                        },
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                      ),

                                    hasData?SizedBox(height: 20):Container()
                                  ],
                                )
                                : Stack(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 30,top: 15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: const Color(0xFFF6F6F6)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            SizedBox(height: 20),

                                            dateBefore
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          int date = (index + 1);

                                                          print('Current Month ' +
                                                              currentMonthCount
                                                                  .toString());

                                                          String selectedDate = date
                                                                  .toString() +
                                                              "/" +
                                                              currentMonthCount
                                                                  .toString() +
                                                              "/" +
                                                              initialDropDownVal;

                                                          final data = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      AddAssignmentScreen(
                                                                          selectedDate)));
                                                          if (data != null) {
                                                            fetchMyCalender(
                                                                context);
                                                          }
                                                        },
                                                        child: Image.asset(
                                                            'assets/sub2.png',
                                                            width: 35,
                                                            height: 35),
                                                      ),
                                                      SizedBox(width: 15),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          int date = (index + 1);

                                                          print('Current Month ' +
                                                              currentMonthCount
                                                                  .toString());

                                                          String selectedDate = date
                                                                  .toString() +
                                                              "/" +
                                                              currentMonthCount
                                                                  .toString() +
                                                              "/" +
                                                              initialDropDownVal;

                                                          final data = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      AddRestDayScreen(
                                                                          selectedDate)));
                                                          if (data != null) {
                                                            fetchMyCalender(
                                                                context);
                                                          }
                                                        },
                                                        child: Image.asset(
                                                          'assets/sub3.png',
                                                          width: 35,
                                                          height: 35,
                                                        ),
                                                      ),
                                                      SizedBox(width: 15),
                                                      AppModel.copyData.isEmpty
                                                          ? Image.asset(
                                                              'assets/sub4.png',
                                                              width: 26,
                                                              height: 26,
                                                              color: Colors.grey
                                                                  .withOpacity(0.5),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                int date =
                                                                    (index + 1);

                                                                print('Current Month ' +
                                                                    currentMonthCount
                                                                        .toString());

                                                                String selectedDate = date
                                                                        .toString() +
                                                                    "/" +
                                                                    currentMonthCount
                                                                        .toString() +
                                                                    "/" +
                                                                    initialDropDownVal;

                                                                pasteItems(context,
                                                                    selectedDate);
                                                              },
                                                              child: Image.asset(
                                                                  'assets/sub4.png',
                                                                  width: 26,
                                                                  height: 26),
                                                            ),
                                                    ],
                                                  ),
                                            const SizedBox(height: 10),
                                            const Divider(),
                                            const SizedBox(height: 7),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    bookedSlotsList.length != 0 &&
                                                            bookedSlotsList[
                                                                        dataIndex]
                                                                    ['title'] ==
                                                                'Reminder'
                                                        ? Text(
                                                            'Reminder',
                                                            style: TextStyle(
                                                                color: AppTheme
                                                                    .blueColor,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                fontSize: 12))
                                                        : Container(),
                                                    bookedSlotsList.length != 0
                                                        ? bookedSlotsList[dataIndex]
                                                                    ['title'] ==
                                                                'Reminder'
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                      bookedSlotsList[
                                                                                  dataIndex]
                                                                              [
                                                                              'start_time']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          fontSize:
                                                                              12)),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Image.asset(
                                                                      'assets/sub1.png',
                                                                      width: 30,
                                                                      height: 30),
                                                                ],
                                                              )
                                                            : Container()
                                                        : Container()
                                                  ],
                                                ),
                                                Spacer(),
                                                Text("No assignments")
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    Row(
                                      children: [
                                        Spacer(),
                                        Container(

                                          margin: EdgeInsets.only(right: 10),

                                          width: 85,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: AppTheme
                                                  .themeColor,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  4)),
                                          child: Center(
                                            child: Text(
                                                (index + 1)
                                                    .toString() +
                                                    " " +
                                                    currentMonthName
                                                        .substring(0,
                                                        3),
                                                style: TextStyle(
                                                    color: (index+1)==DateTime.now().day?

                                                    Colors.blue:




                                                    Colors
                                                        .black,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize:
                                                    12.5)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                          ],
                        );
                      },
                    ))),
                  ],
                ),
    );
  }

  fetchMyCalender(BuildContext context) async {
    if (bookedSlotsList.length != 0) {
      bookedSlotsList.clear();
    }

    if (calenderList.length != 0) {
      calenderList.clear();
    }
    isLoading = true;
    setState(() {});
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    String startingDate = '';
    if (currentMonthCount.toString().length == 1) {
      startingDate = '0' + currentMonthCount.toString();
    } else {
      startingDate = currentMonthCount.toString();
    }
    var data = {
      "method_name": "getMyCalendar",
      "data": {
        "start_date": "01/" + startingDate + "/" + initialDropDownVal,
        "end_date": currentDaysCount.toString() +
            "/" +
            startingDate +
            "/" +
            initialDropDownVal,
        "type": [
          "reminder",
          "activity",
          "rest-day",
          "fitness",
          "skill-set",
          "nutrition"
        ],
        "category_id": currentCategoryID,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": currentCategoryID,
        "action_performed_by": id
      }
    };

    /*{
      "method_name":"getMyCalendar",
      "data":{
        "start_date":"01/03/2024",
        "end_date":"31/03/2024",
        "type":[
          "reminder",
          "activity",
          "rest-day",
          "fitness",
          "skill-set",
          "nutrition"
        ],
        "category_id":"5fb757cb1ef04d04dc54270e",
        "slug":"chandra-testing-2",
        "current_role":"5d4d4f960fb681180782e4f4",
        "current_category_id":"5fb757cb1ef04d04dc54270e",
        "action_performed_by":"63da608fc957843af112042d"
      }
    };*/
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    print(responseJSON);
    if (responseJSON["decodedData"]["status"] == "success") {
      //is_tmp_follow

      if(responseJSON["decodedData"]["message"]!="Calendar Data Not Found")
        {
          if (responseJSON["decodedData"]["is_tmp_follow"] == 1) {
            tailorMode = true;
            setState(() {});
          } else {
            tailorMode = false;
          }
        }

      calenderList = responseJSON['decodedData']['result'];

      if (calenderList.length == 0 && userSubscribe == false && tailorMode && currentMonthCount>=DateTime.now().month) {
        /* Toast.show(responseJSON["decodedData"]["message"],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);*/
        _fetchCategoryList(context, true);
        userSubscribe = true;
      }

      _updateCalenderValues("normal");
    } else {
      _updateCalenderValues("normal");
      /*  Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);*/
    }

    setState(() {});
  }

  subscribeUser() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "saveMyTMPCalendar",
      "data": {
        "tm_program_id": tailorList[0]['tm_program_id'],
        "category_id": currentCategoryID,
        "user_id": id,
        "category_group_id": currentCategoryGroupID,
        "stage": "Beginner",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": currentCategoryID,
        "action_performed_by": id
      }
    };

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('saveMyTMPCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show("Subscribed successfully !!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      MyUtils.saveSharedPreferences('tmp', "subscribed");
      fetchMyCalender(context);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  followTMP() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "followTMP",
      "data": {
        "user_id": id,
        "mode": tailorMode ? false : true,
        "created_by": "TMP",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": currentCategoryID,
        "action_performed_by": id
      }
    };
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('followTMP', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show(responseJSON["decodedData"]["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      setState(() {
        tailorMode = !tailorMode;
      });
      fetchMyCalender(context);
      /* Navigator.push(context,
          MaterialPageRoute(builder: (context) => PlannerSuccessScreen('')));*/
    } else {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  _showRemoveProgramSheet() {
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
                      Center(
                        child: SizedBox(
                            height: 220,
                            child:
                                Lottie.asset('assets/remove_animation.json')),
                      ),
                      SizedBox(height: 15),
                      Text('Are you sure want to unsubscribe ?',
                          style: TextStyle(
                              color: AppTheme.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                      SizedBox(height: 5),
                      Text('You will be able to edit and remove!',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                      SizedBox(height: 25),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  height: 55,
                                  child: ElevatedButton(
                                      child: Text('No, Don\'t Want',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5)),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppTheme.blueColor),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppTheme.blueColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                                flex: 1),
                            SizedBox(width: 15),
                            Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  height: 55,
                                  child: ElevatedButton(
                                      child: Text('Yes',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5)),
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          tailorMode = !tailorMode;
                                        });

                                        fetchMyCalender(context);
                                      }),
                                ),
                                flex: 1)
                          ],
                        ),
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

  fetchTailorMadeProgram(BuildContext context) async {
    isLoading = true;
    setState(() {});
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    String startingDate = '';
    print("Tailor Data");
    print(startingDate.toString());
    print(currentMonthCount.toString());
    if (currentMonthCount.toString().length == 1) {
      startingDate = '0' + currentMonthCount.toString();
    } else {
      startingDate = currentMonthCount.toString();
    }
    print("Tailor Data");
    print(startingDate.toString());
    var data = {
      "method_name": "getTailorMadeProgramActivity",
      "data": {
        "start_date": "01/" + startingDate + "/" + initialDropDownVal,
        "end_date": currentDaysCount.toString() +
            "/" +
            startingDate +
            "/" +
            initialDropDownVal,
        "type": [
          "reminder",
          "activity",
          "rest-day",
          "fitness",
          "skill-set",
          "nutrition"
        ],
        "category_id": currentCategoryID,
        "user_id": id,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "category_group_id": currentCategoryGroupID,
        "stage": "Beginner",
        "current_category_id": currentCategoryID,
        "action_performed_by": id
      }
    };

    /*  var data = {
      "method_name": "getTailorMadeProgramActivity",
      "data": {
        "start_date": "01/03/2024",
        "end_date": "31/03/2024",
        "type": [
          "reminder",
          "activity",
          "rest-day",
          "fitness",
          "skill-set",
          "nutrition"
        ],
        "category_id": "5da82b8753f9777a94999710",
        "user_id": "63da608fc957843af112042d",
        "slug": "chandra-testing-2",
        "current_role": "5d4d4f960fb681180782e4f4",
        "category_group_id": "5d496bcde67f81784a9ddc36",
        "stage": "Beginner",
        "current_category_id": "5da82b8753f9777a94999710",
        "action_performed_by": "63da608fc957843af112042d"
      }
    };*/
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getTailorMadeProgramActivity', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      tailorList = responseJSON['decodedData']['result'];
      print("TAILOR LIST IS " + tailorList.length.toString());

      subscribeUser();

      // _updateCalenderValues("tailor");
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
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

  String returnDateInFormatTailor(String date) {
    final dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.d();
    final DateFormat monthFormatter = DateFormat.yM();
    String dayAsString = dayFormatter.format(dateTime);
    String monthString = monthFormatter.format(dateTime);

    String finalString = dayAsString + "/" + monthString;
    print(finalString);
    return finalString;
  }

  _updateCalenderValues(String type) {
    /* if (type == "tailor") {
      if (bookedSlotsListTailor.length != 0) {
        bookedSlotsListTailor.clear();
      }
      for (int i = 0; i < tailorList.length; i++) {
        if (_returnTailorMonthCount(tailorList[i]['end_date']) ==
            currentMonthCount) {
          print("TAILOR DATA " + i.toString());
          bookedSlotsListTailor.add(tailorList[i]);
        }
      }
    }*/
    if (bookedSlotsList.length != 0) {
      bookedSlotsList.clear();
    }
    for (int i = 0; i < calenderList.length; i++) {
      if (_returnMonthCount(calenderList[i]['end_date']) == currentMonthCount) {
        bookedSlotsList.add(calenderList[i]);
      }
    }

    print('CURRENT MONTH');
    log("**" + bookedSlotsList.toString() + "**");
    setState(() {});

    if (firstTimefetch || currentMonthCount==DateTime.now().month) {
      scrollListView();


    }
    else
      {
        scrollingIndex=0;
      }
  }

  _fetchCurrentMonthDaysCount() {
    print("Current month count is " + currentMonthCount.toString());
    DateTime x1 =
        DateTime(int.parse(initialDropDownVal), currentMonthCount, 0).toUtc();
    int y1 = DateTime(int.parse(initialDropDownVal), currentMonthCount + 1, 0)
        .toUtc()
        .difference(x1)
        .inDays;
    print('Selected Days Count ' + y1.toString());
    currentDaysCount = y1;

    setState(() {});
  }

  _fetchCategoryList(BuildContext context, bool tailorModeee) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getLearnerCategoryList",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "asc",
        "current_role": currentRole,
        "current_category_id": "5d498615ee90fb3fb1a59b9e",
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
      for (int i = 0; i < categoryList.length; i++) {
        if (catId == categoryList[i]['category_id']) {
          selectedCategoryIndex = i;
          currentCategoryImageUrl =
              imageUrl + categoryList[i]['category_image'];
          currentCategoryID = categoryList[i]['category_id'];
          currentCategoryGroupID = categoryList[i]['category_group_id'];
          categoryExists = true;
          break;
        }
      }

      setState(() {
        isLoading = false;
      });
      if (categoryExists) {
        if (tailorModeee) {
          fetchTailorMadeProgram(context);
        } else {
          fetchMyCalender(context);
        }
      } else {
        Toast.show("Please select a category !",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    }

    //  fetchTailorMadeProgram(context);
    setState(() {});
    print(responseJSON);
  }

  _fetchHorizontalList() {
    currentMonthCount = DateTime.now().month;
    currentMonthName = monthName[currentMonthCount];
    print('Current month Name');
    previousMonthName = monthName[currentMonthCount - 1];
    nextMonthName = monthName[currentMonthCount + 1];
    _fetchCurrentMonthDaysCount();
    setState(() {});
  }

  _nextMonth() {
    currentMonthCount = currentMonthCount + 1;
    currentMonthName = monthName[currentMonthCount];
    previousMonthName = monthName[currentMonthCount - 1];
    nextMonthName = monthName[currentMonthCount + 1];
    setState(() {});
    _fetchCurrentMonthDaysCount();
    /*  if (tailorMode) {
      fetchTailorMadeProgram(context);
    } else {
      fetchMyCalender(context);
    }*/
    fetchMyCalender(context);
  }

  _previousMonth() {
    if (currentMonthName != "January") {
      print("previous");
      currentMonthCount = currentMonthCount - 1;
      currentMonthName = monthName[currentMonthCount];
      previousMonthName = monthName[currentMonthCount - 1];
      nextMonthName = monthName[currentMonthCount + 1];
      setState(() {});
      _fetchCurrentMonthDaysCount();
      fetchMyCalender(context);
    }
  }

  int _returnMonthCount(String date) {
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    var dateTime22 = format.parse(date, true);
    final DateFormat monthCount = DateFormat.M();
    String count = monthCount.format(dateTime22);
    return int.parse(count);
  }

  int _returnTailorMonthCount(String date) {
    final dateTime = DateTime.parse(date);
    final DateFormat monthCount = DateFormat.M();
    String count = monthCount.format(dateTime);
    return int.parse(count);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ItemScrollController();
    scrollOffsetController = ScrollOffsetController();
    itemPositionsListener = ItemPositionsListener.create();
    scrollOffsetListener = ScrollOffsetListener.create();
    checkForCategory();
  }

  checkForCategory() async {
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    print("Current CAT is " + catId.toString());
    if (catId == null) {
      Toast.show("Please select a category !",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      fetchJoinedDate();
      _fetchHorizontalList();
      _fetchCategoryList(context, false);
    }
  }

  scrollListView() {
    String currentDate = DateTime.now().day.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        initialDropDownVal;
    print("Current Date is ");
    print(currentDate);

    int index = DateTime.now().day;
    scrollingIndex=index-1;
    // index=index-1;
   /* scrollController.scrollTo(
        index: index - 1,
        duration: const Duration(milliseconds: 2),
        curve: Curves.bounceIn);*/


    firstTimefetch = false;
    setState(() {});
  }

  fetchJoinedDate() async {
    String? currentCat = await MyUtils.getSharedPreferences("joined_date");

    if (currentCat != null) {
      DateTime date = DateTime.parse(currentCat.toString());
      yearList.add(date.year.toString());
      if (date.year != DateTime.now().year) {
        yearList.add(DateTime.now().year.toString());
      }
      setState(() {});
    } else {
      yearList.add(DateTime.now().year.toString());
    }
  }

  addRemainder(String date) async {
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
        "start_date": date,
        "end_date": date,
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
      fetchMyCalender(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  deleteAssignment(String calenderID) async {
    APIDialog.showAlertDialog(context, "Please wait");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "data": {
        "calendar_token": calenderID,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      },
      "method_name": "deleteMyCalendar"
    };

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('deleteMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    //calenderList = responseJSON['decodedData']['result'];

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      fetchMyCalender(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
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
                        onPressed: () => Navigator.pop(context)),
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

  _showCategoryDialog() {
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
                              padding: EdgeInsets.only(bottom: 5),
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
                                                ),
                                                textAlign: TextAlign.center)
                                            : Text(
                                                categoryList[index]['category'],
                                                style: const TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center)),
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
                              MyUtils.saveSharedPreferences(
                                  'current_category_id',
                                  categoryList[selectedCategoryIndex]
                                      ['category_id']);
                              print(categoryList[selectedCategoryIndex]
                                  ['category_id']);
                              Navigator.pop(context);
                              currentCategoryImageUrl = imageUrl +
                                  categoryList[selectedCategoryIndex]
                                      ['category_image'];
                              updateScreen();
                              currentCategoryID =
                                  categoryList[selectedCategoryIndex]
                                      ['category_id'];
                              currentCategoryGroupID =
                                  categoryList[selectedCategoryIndex]
                                      ['category_group_id'];

                              categoryExists = true;

                              //fetchTailorMadeProgram(context);
                              fetchMyCalender(context);
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
          position: Tween(begin: Offset(0, true ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  updateScreen() {
    setState(() {});
  }

  String _returnDateFormat(String date) {
    print("THE DAT IS " + date);
    final format = DateFormat('HH:mm:ssZ', 'en-US');
    var dateTime22 = format.parse(date);
    final DateFormat monthCount = DateFormat.jm();
    String count = monthCount.format(dateTime22);
    return count;
  }

  pasteItems(BuildContext context, String date) async {
    startDateCopy = AppModel.copyData["start_date"];
    endDateCopy = AppModel.copyData["end_date"];

    Map<String, dynamic>? copyPlannerData = AppModel.copyData;
    copyPlannerData['start_date'] = date;
    copyPlannerData['end_date'] = date;

    APIDialog.showAlertDialog(context, "Please wait");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    copyPlannerData['slug'] = AppModel.slug;
    copyPlannerData['current_role'] = currentRole;
    copyPlannerData['current_category_id'] = catId;
    copyPlannerData['action_performed_by'] = id;
    var data = {
      "id": copyPlannerData["_id"],
      "title": copyPlannerData["title"],
      "description": copyPlannerData["description"],
      "type": copyPlannerData["type"],
      "allDay": copyPlannerData["is_all_day"],
      "restDay": 0,
      "start": startDateCopy,
      "end": endDateCopy,
      "activities": copyPlannerData["activities"],
      "categoryData": copyPlannerData["category_attribute_name"],
      "subCategoryData": copyPlannerData["subcategory_attribute_name"],
      "meta": copyPlannerData,
      "bgcolor": copyPlannerData["bgcolor"],
      "method_name": "saveMyCalendar",
      "data": copyPlannerData
    };

    print("Payload is ");
    log(data.toString());

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('saveMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    //calenderList = responseJSON['decodedData']['result'];

    if (responseJSON['decodedData']['status'] == 'success') {
      AppModel.setCopyData({});
      setState(() {});
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      fetchMyCalender(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }


  showAssignmentRemoveDialog(String calenderID) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);

      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        Navigator.pop(context);
        deleteAssignment(calenderID);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Assignment?",style: TextStyle(
        fontSize: 18
      ),),
      content: Text("Are you sure you want to delete this assignment ?"),
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
