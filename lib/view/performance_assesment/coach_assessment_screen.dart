import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/heading_text_widget.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class CoachAssessmentScreen extends StatefulWidget{
  _coachAssessment createState()=> _coachAssessment();
}
class _coachAssessment extends State<CoachAssessmentScreen>{
  int selectedWeekIndex = 0;
  bool noData=false;
  List<dynamic> assesmentList = [];
  bool isLoading=false;
  String errorMessage="";
  List<dynamic> draftMap=[];
  Map<String,dynamic> attributes={};
  String currentCategoryImageUrl = '';
  int selectedCategoryIndex = 9999;
  List<dynamic> categoryList = [];
  String imageURL = '';

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
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              //  _logOut();
              _showCategoryDialog();
            },
            child: Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                      width: 1.5,
                      color: Color(0xFFCEAC45))),
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
        backgroundColor: AppTheme.themeColor,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Coach ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Assessment',
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
      body:
      isLoading?

      Center(
        child: Loader(),
      ):

          noData?

              Center(
                child: Text(errorMessage,textAlign: TextAlign.center),
              ):



      Column(
        children: [
          SizedBox(height: 5),
          HeadingTextWidget('Weekly ', 'Performance Assessment'),
          SizedBox(height: 15),

          assesmentList.length==0?
          Container(
            height: 100,
            child: Center(
              child: Text('No weeks found'),
            ),
          ):

          Container(
            height: 78,
            margin: EdgeInsets.only(left: 12),
            child: ListView.builder(
                itemCount: assesmentList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int pos) {
                  return Row(
                    children: [
                      InkWell(
                        child: Container(
                          width: 49,
                          height: 77,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: pos == selectedWeekIndex
                                  ? Colors.black
                                  : AppTheme.themeColor),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Image.asset('assets/smiley_ic.png',
                                  width: 21.93, height: 21.93),
                              Text(assesmentList[pos]['week_number'].toString(),
                                  style: TextStyle(
                                      color: pos == selectedWeekIndex
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17)),
                              Text('Week',
                                  style: TextStyle(
                                      color: pos == selectedWeekIndex
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedWeekIndex = pos;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                    ],
                  );
                }),
          ),
          SizedBox(height: 35),
          assesmentList.length==0?
          Container(
            height: 100,
            child: Center(
              child: Text('No data found'),
            ),
          ):
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFFF3F3F3)),
            child: Row(
              children: [
                Container(
                  color: Colors.orange,
                  width: 5,
                  height: 70,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Attributes',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                                Text(attributes.values.toString().substring(1,attributes.values.toString().length-1),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            transform:
                            Matrix4.translationValues(8.0, -25.0, 0.0),
                            width: 85,
                            height: 30,
                            decoration: BoxDecoration(
                                color: AppTheme.themeColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text('Week '+assesmentList[selectedWeekIndex]['week_number'].toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 41,
                        decoration: BoxDecoration(
                            color: AppTheme.blueColor,
                            borderRadius: BorderRadius.circular(3)),
                        child: Row(
                          children: [
                            SizedBox(width: 6),
                            Text('Total Marks : '+assesmentList[selectedWeekIndex]['total'].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                            SizedBox(width: 15),
                            Text('Marks Obtained : '+assesmentList[selectedWeekIndex]['average'].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                _assessmentBottomSheet();
                              },
                              child: Container(
                                width: 30,
                                height: 31,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Center(
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: AppTheme.blueColor, size: 15),
                                ),
                              ),
                            ),
                            SizedBox(width: 5)
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          draftMap.length!=0?
          HeadingTextWidget('Current ', 'Week'):Container(),
          SizedBox(height: 15),
          draftMap.length!=0?
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFFF3F3F3)),
            child: Row(
              children: [
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Attributes',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                                Text(attributes.values.toString().substring(1,attributes.values.toString().length-1),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                color: AppTheme.blueColor,
                                shape: BoxShape.circle),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Week',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                                Text( draftMap.length!=0?draftMap[0]['week_number'].toString():'',
                                    style: TextStyle(
                                        color: AppTheme.themeColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                          SizedBox(width: 15)
                        ],
                      ),
                      /*SizedBox(height: 13),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 42,
                        child: ElevatedButton(
                            child: Text('Fill Details',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.5)),
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
                            onPressed: () {
                              *//*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CurrentWeekScreen()));*//*
                            }),
                      ),*/
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ):Container(),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: AppTheme.blueColor,
                borderRadius: BorderRadius.circular(3)),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 6),
                    Text('Total Marks All Weeks :',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    Spacer(),
                    Text('0',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    SizedBox(width: 20)
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(width: 6),
                    Text('Total Marks Obtained All Weeks :',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    Spacer(),
                    Text('0',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    SizedBox(width: 20)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _assessmentBottomSheet() {
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
                              child: Text('Week ',
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
                                Text(assesmentList[selectedWeekIndex]['week_number'].toString(),
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
                      SizedBox(height: 10),
                      /*    Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Row(
                                    children: [
                                      Text('Bowling',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13)),
                                      SizedBox(width: 25),
                                      Text('07',
                                          style: TextStyle(
                                              color: AppTheme.blueColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  flex: 1),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text('Fielding',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                    SizedBox(width: 35),
                                    Text('07',
                                        style: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                  ],
                                ),
                                flex: 1,
                              )
                            ],
                          )),*/

                      Container(
                        height: 150,
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 15,
                              crossAxisCount: 2,
                              childAspectRatio: (2/ 0.5)),
                          itemCount: attributes.length,
                          itemBuilder: (context, index) {
                            return  Row(
                              children: [
                                Text(attributes.values.elementAt(index),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                SizedBox(width: 25),
                                Text("0",
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ],
                            );
                            // Item rendering
                          },
                        ),
                      ),

                      SizedBox(height: 22),
                      Container(
                        height: 41,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: AppTheme.blueColor,
                            borderRadius: BorderRadius.circular(3)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Marks : 0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                            Text('Marks Obtained : 0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      SizedBox(height: 22),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            child: Text('Back',
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
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                      SizedBox(height: 25)
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



  fetchAssesments(String catID) async {

    setState(() {
      isLoading=true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getUserAssessment",
      "data": {
        "user_slug":  AppModel.slug,
        "type": "coach",
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 30,
        "current_stage_id": "5d496c2de67f81784a9ddc39",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id":catID==''?catId:catID,
        "action_performed_by": id
      }
    };
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getUserAssessment', requestModel, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading=false;
    });
    print(responseJSON);
    if(responseJSON['decodedData']['status']=='success'){
      noData=false;
      assesmentList = responseJSON['decodedData']['result'];
      draftMap = responseJSON['decodedData']['draft'];
      attributes = responseJSON['decodedData']['attributes'];
    }else{
      noData=true;
      errorMessage=responseJSON['decodedData']['message'].toString();
      setState(() {
      });


    }

    setState(() {

    });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAssesments('');
    _fetchCategoryList(context);
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
                    SizedBox(
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
                                      imageURL +
                                          categoryList[index]
                                          ['category_image'],
                                      width: 45,
                                      height: 45,
                                      color: AppTheme.themeColor)
                                      : Image.network(
                                      imageURL +
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
                              print(categoryList[selectedCategoryIndex]
                              ['category_id']);


                              fetchAssesments(categoryList[selectedCategoryIndex]
                              ['category_id']);
                              currentCategoryImageUrl=imageURL +
                                  categoryList[selectedCategoryIndex]
                                  ['category_image'];
                              setState(() {

                              });

                              Navigator.pop(context);

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
          position:
          Tween(begin: Offset(0, true ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  _fetchCategoryList(BuildContext context) async {
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
    categoryList = responseJSON['decodedData']['result'];
    imageURL = responseJSON['decodedData']['image_url'];
    if (categoryList.length != 0) {
      currentCategoryImageUrl = imageURL + categoryList[0]['category_image'];
    }
    setState(() {});
    print(responseJSON);
  }


}