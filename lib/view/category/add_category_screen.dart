import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:toast/toast.dart';

class AddCategoryScreen extends StatefulWidget {
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<AddCategoryScreen> {
  int selectedCategoryGroupindex = 9999;
  List<dynamic> addedCategoryList = [];
  int selectedCategoryIndex = 9999;
  String selectedGroupID = '';
  List<String> categoryNames = [];
  int selectedStageIndex = 9999;
  List<dynamic> categoryGroupList = [];
  List<dynamic> categoryList = [];
  List<dynamic> stagesList = [];
  String dropValue1 = 'Select Category Group';
  String dropValue2 = 'Select Category';
  String dropValue3 = 'Select Stage';

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*  leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),*/
        backgroundColor: AppTheme.themeColor,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Add ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Category',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text('Category Group*',
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 6),
          InkWell(
            onTap: () {
              _showCategoryGroupDialog();
            },
            child: Container(
                height: 48,
                width: double.infinity,
                padding: EdgeInsets.only(left: 5, right: 10 /*,top: 15*/),
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xFFF6F6F6)),
                child: Row(
                  children: [
                    Text(dropValue1,
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black, size: 32),
                  ],
                )),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text('Category*',
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              if (categoryList.length != 0) {
                _showCategoryDialog();
              }
            },
            child: Container(
                height: 48,
                width: double.infinity,
                padding: EdgeInsets.only(left: 5, right: 10 /*,top: 15*/),
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xFFF6F6F6)),
                child: Row(
                  children: [
                    Text(dropValue2,
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black, size: 32),
                  ],
                )),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text('Stage*',
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              _showStageDialog();
            },
            child: Container(
                height: 48,
                width: double.infinity,
                padding: EdgeInsets.only(left: 5, right: 10 /*,top: 15*/),
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xFFF6F6F6)),
                child: Row(
                  children: [
                    Text(dropValue3,
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black, size: 32),
                  ],
                )),
          ),
          SizedBox(height: 38),
          Container(
            width: double.infinity,
            height: 52,
            margin: EdgeInsets.symmetric(horizontal: 35),
            child: ElevatedButton(
                child: Text('Add',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ))),
                onPressed: () {
                  if (dropValue1 == 'Select Category Group') {
                    Toast.show('Please select a Category Group',
                        duration: Toast.lengthLong,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.red);
                  } else if (dropValue2 == 'Select Category') {
                    Toast.show('Please select a Category',
                        duration: Toast.lengthLong,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.red);
                  } else if (dropValue3 == 'Select Stage') {
                    Toast.show('Please select a Stage',
                        duration: Toast.lengthLong,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.red);
                  } else if (categoryNames.toString().contains(dropValue2)) {
                    Toast.show('This category is already added !!',
                        duration: Toast.lengthLong,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.red);
                  } else {
                    _addCategory(context);
                  }
                }),
          ),
          addedCategoryList.length == 0
              ? Container()
              : Container(
            width: double.infinity,
            height: 52,
            margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: ElevatedButton(
                child: Text('Proceed',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ))),
                onPressed: () {

                  if(selectedCategoryIndex==9999)
                    {
                      MyUtils.saveSharedPreferences(
                          "current_category_id", addedCategoryList[0]['category_id']);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LandingScreen()));
                    }
                  else
                    {

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LandingScreen()));
                    }

                }),
          ),
          SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
                  itemCount: addedCategoryList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int pos) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF3F3F3),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: AppTheme.themeColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomLeft: Radius.circular(4))),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 13),
                                    Text('Category Group',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        addedCategoryList[pos]
                                        ['category_group'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 8),
                                    Text('Stage',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 5),
                                    Text(addedCategoryList[pos]['stage'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 15),
                                  ],
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 13),
                                    Text('Category',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500)),
                                    Text(addedCategoryList[pos]['category'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 10),
                                    Text('Action',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () {
                                        showCategoryRemoveDialog(
                                            addedCategoryList[pos]
                                            ['category_id']);
                                      },
                                      child: Image.asset('assets/delete_ic.png',
                                          width: 18, height: 18),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15)
                      ],
                    );
                  }))
        ],
      ),
    ),   onWillPop: () {
      return Future.value(false);
    });
  }

  _showCategoryGroupDialog() {
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
                margin: EdgeInsets.only(top: 22),
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
                              Text('Category Group',
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
                    SizedBox(height: 7),
                    Divider(),
                    ListView.builder(
                        itemCount: categoryGroupList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int pos) {
                          return GestureDetector(
                            onTap: () {
                              dialogState(() {
                                selectedCategoryGroupindex = pos;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  pos == selectedCategoryGroupindex
                                      ? Icon(Icons.radio_button_checked,
                                          size: 25, color: AppTheme.themeColor)
                                      : Icon(Icons.radio_button_off,
                                          size: 25, color: Color(0xFF707070)),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: Text(
                                          categoryGroupList[pos]['text'],
                                          style: TextStyle(
                                              fontSize: 14.5,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600))),
                                  SizedBox(width: 5),
                                ],
                              ),
                            ),
                          );
                        }),
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
                            if (selectedCategoryGroupindex != 9999) {
                              dropValue1 =
                                  categoryGroupList[selectedCategoryGroupindex]
                                      ['text'];
                              setState(() {});

                              Navigator.pop(context);
                              _fetchCategory();
                            }
                          }),
                    )
                  ],
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
                margin: EdgeInsets.only(top: 22),
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
                    SizedBox(height: 7),
                    Divider(),
                    Container(
                      height: categoryList.length>4?250:180,
                      child: ListView.builder(
                          itemCount: categoryList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int pos) {
                            return GestureDetector(
                              onTap: () {
                                dialogState(() {
                                  selectedCategoryIndex = pos;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    pos == selectedCategoryIndex
                                        ? Icon(Icons.radio_button_checked,
                                            size: 25,
                                            color: AppTheme.themeColor)
                                        : Icon(Icons.radio_button_off,
                                            size: 25, color: Color(0xFF707070)),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Text(categoryList[pos]['text'],
                                            style: TextStyle(
                                                fontSize: 14.5,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600))),
                                    SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            );
                          }),
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
                              dropValue2 =
                                  categoryList[selectedCategoryIndex]['text'];
                              setState(() {});
                              Navigator.pop(context);
                            }
                          }),
                    )
                  ],
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

  _showStageDialog() {
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
                margin: EdgeInsets.only(top: 22),
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
                              Text('Stage',
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
                    SizedBox(height: 7),
                    Divider(),
                    ListView.builder(
                        itemCount: stagesList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int pos) {
                          return GestureDetector(
                            onTap: () {
                              dialogState(() {
                                selectedStageIndex = pos;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  pos == selectedStageIndex
                                      ? Icon(Icons.radio_button_checked,
                                          size: 25, color: AppTheme.themeColor)
                                      : Icon(Icons.radio_button_off,
                                          size: 25, color: Color(0xFF707070)),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: Text(stagesList[pos]['text'],
                                          style: TextStyle(
                                              fontSize: 14.5,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600))),
                                  SizedBox(width: 5),
                                ],
                              ),
                            ),
                          );
                        }),
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
                            if (selectedStageIndex != 9999) {
                              dropValue3 =
                                  stagesList[selectedStageIndex]['text'];
                              setState(() {});
                              Navigator.pop(context);
                            }
                          }),
                    )
                  ],
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

  _fetchCategoryGroup(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please wait...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

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
    Navigator.pop(context);
    categoryGroupList =
        responseJSON['decodedData']['dropdowns']['category_groups'];
    stagesList = responseJSON['decodedData']['dropdowns']['learner_stages'];
    addedCategoryList = responseJSON['decodedData']['result'];
    if (addedCategoryList.length != 0) {
      categoryNames.clear();
    }
    for (int i = 0; i < addedCategoryList.length; i++) {
      categoryNames.add(addedCategoryList[i]['category']);
    }
    print(addedCategoryList.length.toString() + '****');
    categoryGroupList.removeAt(0);
    stagesList.removeAt(0);
    setState(() {});
    print(responseJSON);
  }

  _addCategory(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please wait...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');


    var data = {
      "method_name": "saveLearnerCategory",
      "data": {
        "categories": [
          {
            "category_group_id": categoryGroupList[selectedCategoryGroupindex]
            ['id'],
            "category_id":categoryList[selectedCategoryIndex]['id'],
            "category":  categoryGroupList[selectedCategoryGroupindex]['text'],
            "sub_category": categoryList[selectedCategoryIndex]['text'],
            "stage_id": stagesList[selectedStageIndex]['id'],
          }
        ],
        "slug":
        AppModel.slug,
        "current_role": currentRole,
        "current_category_id": "5d498615ee90fb3fb1a59b9e",
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('saveLearnerCategory', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);

    if (responseJSON['decodedData']['status'] == 'success') {
      MyUtils.saveSharedPreferences(
          "current_category_id", categoryList[selectedCategoryIndex]['id']);
     /* MyUtils.saveSharedPreferences('tmp',
          "not subscribed");*/
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      dropValue1 = 'Select Category Group';
      dropValue2 = 'Select Category';
      dropValue3 = 'Select Stage';
      categoryList.clear();
      setState(() {

      });
      _fetchCategoryGroup(context);
      /* categoryGroupList.clear();

      */
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    }

    print(responseJSON);
  }

  _fetchCategory() async {
    selectedGroupID = categoryGroupList[selectedCategoryGroupindex]['id'];
    APIDialog.showAlertDialog(context, 'Please wait...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name": "getCategoriesByCategoryGroup",
      "data": {
        "category_group_id": selectedGroupID,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": "5d498615ee90fb3fb1a59b9e",
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getCategoriesByCategoryGroup', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (categoryList.length != 0) {
      categoryList.clear();
    }
    categoryList = responseJSON['decodedData']['result'];
    categoryList.removeAt(0);
    print(responseJSON);
    setState(() {});
  }

  showCategoryRemoveDialog(String catId) {
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
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
        _deleteCategory(catId);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Category?"),
      content: Text("Are you sure you want to remove this category ?"),
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

  _deleteCategory(String catID) async {
    APIDialog.showAlertDialog(context, 'Removing category');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name": "deleteLearnerCategory",
      "data": {
        "slug": AppModel.slug,
        "learner_category_id": catID,
        "current_role": currentRole,
        "current_category_id": "5d498615ee90fb3fb1a59b9e",
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('deleteLearnerCategory', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    }
    print(responseJSON);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchCategoryGroup(context);
      displayToast();
    });
  }

  displayToast() {
    Toast.show("Please add a category to continue !!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);
  }
}
