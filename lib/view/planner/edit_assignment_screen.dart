import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/planner/add_rest_day_screen.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/digital_library/digital_library_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

class EditAssignmentScreen extends StatefulWidget {
  final String date;
  final Map<String,dynamic> calenderData;

  EditAssignmentScreen(this.date,this.calenderData);

  AssignmentState createState() => AssignmentState();
}

class AssignmentState extends State<EditAssignmentScreen> {
  bool defaultLayout = true;
  Map<String, dynamic>? fileData;
  String selectedColor = '';
  var remainderController = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool layout1 = false;
  bool layout2 = false;
  bool layout3 = false;
  int selectedColorIndex = 0;
  bool layout4 = false;
  int selectedIndex = 1;
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var assignmentTitleController = TextEditingController();
  var assignmentDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppTheme.themeColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_sharp,
                    color: Colors.black),
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
                      text: 'Edit ',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Assignment',
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
            body: defaultLayout
                ? ListView(
                    children: [
                   /*   SizedBox(height: 20),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(horizontal: 35),
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
                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddRestDayScreen()));

                                *//*  setState(() {
                                    defaultLayout = false;
                                    layout1 = true;
                                    layout2 = false;
                                    layout3 = false;
                                    layout4 = false;
                                  });*//*
                                },
                                child: Image.asset('assets/sub2.png',
                                    width: 30, height: 30),
                              ),
                              GestureDetector(
                                onTap: () {
                                  remainderController.text="";
                                  selectedColorIndex=0;
                                  _showRemainderDialog();
                                },
                                child: Image.asset('assets/sub1.png',
                                    width: 30, height: 30),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddRestDayScreen(widget.date)));
                                  *//*  setState(() {
                                defaultLayout = false;
                                layout1 = false;
                                layout2 = false;
                                layout3 = true;
                                layout4 = false;
                              });*//*
                                },
                                child: Image.asset('assets/sub3.png',
                                    width: 37, height: 37),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showCopyDialog();
                                },
                                child: Image.asset('assets/sub4.png',
                                    width: 30, height: 30),
                              )
                            ],
                          ),
                        ),
                      ),*/
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Title',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            validator: checkEmptyString,
                            controller: titleController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF6F6F6),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: 'Add Title...',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
                      ),
                      SizedBox(height: 25),
                    /*  Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Descrption',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            controller: descController,
                            validator: checkEmptyString,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xFFF6F6F6),
                                contentPadding:
                                    EdgeInsets.only(left: 5, top: 5),
                                hintText: 'Add Descrption...',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
                      ),*/
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: widget.calenderData['type'] ==
                                          'skill-set'
                                          ? AppTheme.themeColor
                                          : Color(0xFFF3F3F3)),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/skill_ic.png',
                                          width: 21, height: 18.17),
                                      SizedBox(width: 5),
                                      Text('Skill Set',
                                          style: TextStyle(
                                              color: widget.calenderData['type'] ==
                                                  'skill-set'
                                                  ? Colors.black
                                                  : Color(0xFF9A9CB8),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 7),
                            Expanded(
                                child: Container(
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color:
                                      widget.calenderData['type'] == 'fitness'
                                          ? AppTheme.themeColor
                                          : Color(0xFFF3F3F3)),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/fitness_ic.png',
                                          width: 22, height: 18.17),
                                      SizedBox(width: 5),
                                      Text('Fitness',
                                          style: TextStyle(
                                              color: widget.calenderData['type'] ==
                                                  'fitness'
                                                  ? Colors.black
                                                  : Color(0xFF9A9CB8),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 7),
                            Expanded(
                                child: Container(
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: widget.calenderData['type'] ==
                                          'nutrition'
                                          ? AppTheme.themeColor
                                          : Color(0xFFF3F3F3)),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/nutrition_ic.png',
                                          width: 22, height: 18.17),
                                      SizedBox(width: 5),
                                      Text('Nutrition',
                                          style: TextStyle(
                                              color: widget.calenderData['type'] ==
                                                  'nutrition'
                                                  ? Colors.black
                                                  : Color(0xFF9A9CB8),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.5)),
                                    ],
                                  ),
                                ),
                                flex: 1)
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Assignment Title (required)',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            validator: checkEmptyString,
                            controller: assignmentTitleController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF6F6F6),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 5),
                                hintText: 'Add Title...',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            GestureDetector(
                                onTap: () async {


                                   await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DigitalLibraryScreen(
                                                  false, "Select",1,false)));


                                   fileData=AppModel.fileData;
                                   setState(() {});
                                   print('Page Triggered');
                                   print(fileData);
                                },
                                child: fileData != null
                                    ? fileData!['library_type'] == "video"
                                        ? Image.asset('assets/title1.png',
                                            width: 35.8,
                                            height: 35.8,
                                            color: AppTheme.blueColor)
                                        : Image.asset('assets/title1.png',
                                            width: 35.8, height: 35.8)
                                    : Image.asset('assets/title1.png',
                                        width: 35.8, height: 35.8)),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () async {
                           await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DigitalLibraryScreen(
                                                false, "Select",3,false)));


                                fileData=AppModel.fileData;
                                setState(() {});
                                print('Page Triggered');
                                print(fileData);
                              },
                              child: fileData != null
                                  ? fileData!['library_type'] == "pdf"
                                  ? Image.asset('assets/title2.png',
                                  width: 35.8,
                                  height: 35.8,
                                  color: AppTheme.blueColor)
                                  :   Image.asset('assets/title2.png',
                                  width: 35.8, height: 35.8)
                                  :   Image.asset('assets/title2.png',
                                  width: 35.8, height: 35.8),




                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DigitalLibraryScreen(
                                                false, "Select",2,false)));


                                fileData=AppModel.fileData;
                                setState(() {});
                                print('Page Triggered');
                                print(fileData);
                              },
                              child: fileData != null
                                  ? fileData!['library_type'] == "image"
                                  ? Image.asset('assets/title3.png',
                                  width: 35.8,
                                  height: 35.8,
                                  color: AppTheme.blueColor)
                                  :   Image.asset('assets/title3.png',
                                  width: 35.8, height: 35.8)
                                  :   Image.asset('assets/title3.png',
                                  width: 35.8, height: 35.8),

                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Instructions, example',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF6F6F6),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            controller: assignmentDescController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            maxLines: 4,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 5, top: 5),
                                hintText: 'Add Instructions.',
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9A9CB8),
                                ))),
                      ),
                      SizedBox(height: 20),

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
                              _submitHandler(context);
                            }),
                      ),


                    ],
                  )
                        : Container()));
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
                          Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
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
                            style:
                            TextStyle(color: Color(0xFF9A9CB8), fontSize: 12)),
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
                                contentPadding: EdgeInsets.only(left: 5, top: 5),
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

  _showDeleteDialog() {
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
                  SizedBox(height: 25),
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
                  SizedBox(height: 25),
                  Center(
                    child: SizedBox(
                        height: 100,
                        child: OverflowBox(
                          minHeight: 180,
                          maxHeight: 180,
                          child: Lottie.asset('assets/delete_animation.json'),
                        )),
                  ),
                  SizedBox(height: 35),
                  Text('Delete This Activity From Planner ?',
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  SizedBox(height: 8),
                  Text('simply dummy text of the printing',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5)),
                  SizedBox(height: 38),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 25),
                            height: 50,
                            child: ElevatedButton(
                                child: Text('Yes',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.5)),
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
                                      borderRadius: BorderRadius.circular(4),
                                    ))),
                                onPressed: () => null),
                          ),
                          flex: 1,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 5, bottom: 25),
                              height: 50,
                              child: ElevatedButton(
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.5)),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ))),
                                  onPressed: () => null),
                            ),
                            flex: 1)
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
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

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Sort By',
                          style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/close_icc.png',
                          width: 20,
                          height: 20,
                          color: Colors.black,
                        )),
                    const SizedBox(width: 10)
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const SizedBox(width: 25),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1, color: AppTheme.themeColor),
                              borderRadius: BorderRadius.circular(5)),
                          height: 43,
                          child: const Center(
                            child: Text('Clear',
                                style: TextStyle(
                                    fontSize: 16, color: AppTheme.themeColor)),
                          )),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: AppTheme.themeColor,
                              borderRadius: BorderRadius.circular(5)),
                          height: 43,
                          child: const Center(
                            child: Text('Apply',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          )),
                    ),
                  ),
                  const SizedBox(width: 25),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        );
      }),
    );
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // All validations Passed

    saveMyCalender(context);
  }

  saveMyCalender(BuildContext context) async {
    APIDialog.showAlertDialog(context, "Please wait");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    String type = '';
    if (selectedIndex == 1) {
      type = 'skill-set';
    } else if (selectedIndex == 2) {
      type = 'fitness';
    } else {
      type = 'nutrition';
    }

    var data = {
      "data": {
        "calendar_token": "",
        "type": type,
        "start_date": widget.date,
        "end_date": widget.date,
        "start_time": "00:00",
        "end_time": "23:59",
        "is_off_day": 0,
        "is_all_day": 0,
        "title": titleController.text,
        "description": descController.text,
        "activities": [
          {
            "title": assignmentTitleController.text,
            "description": assignmentDescController.text,
            "type": null,
            "attchement": fileData!=null && fileData!['library_type']=="video"?{
              "video_id": fileData!['_id'],
              "slug": fileData!['slug'],
              "video_type": fileData!['video_type'],
              "video_url": fileData!['library_video_url'],
              "video_thumb":fileData!['video_thumb'],
              "view_count": fileData!['view_count']
            }:null,
            "attchement_image": fileData!=null? fileData!['library_type']=="image"?fileData!['_id']:null:null,
            "attchement_pdf":fileData!=null? fileData!['library_type']=="pdf"?fileData!['_id']:null:null,
            "attachment_type":
                fileData != null ? fileData!['library_type'] : null
          }
        ],
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
      AppModel.setFileData({});
      fileData={};
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,"refresh");
      Navigator.pop(context,"refresh");
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
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
        "start_date": widget.date,
        "end_date": widget.date,
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

  setInitialData(){
    titleController.text=widget.calenderData["title"];
    descController.text=widget.calenderData["description"];
    if(widget.calenderData["activities"].length!=0)
      {
        assignmentTitleController.text=widget.calenderData["activities"][0]["title"];
        assignmentDescController.text=widget.calenderData["activities"][0]["description"];
      }

   setState(() {

   });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("The Date is "+widget.date);
    setInitialData();
  }
}
