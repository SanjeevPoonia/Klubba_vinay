import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/planner/assignment_detail_screen.dart';
import 'package:toast/toast.dart';

class PendingAssignments extends StatefulWidget {
  PendingState createState() => PendingState();
}

class PendingState extends State<PendingAssignments> {
  int selectedTab = 1;
  List<dynamic> pendingTasks = [];
  List<dynamic> skillSetList = [];
  List<dynamic> fitnessList = [];
  List<dynamic> nutritionList = [];
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
                  text: 'Pending ',
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
        body: Column(children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
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
          SizedBox(height: 25),
          Expanded(
              child:

                  isLoading?

                      Center(
                        child: CircularProgressIndicator(),
                      ):




              selectedTab==1?


                  skillSetList.length==0?

                      Center(
                        child: Text("No data found !"),

                      ):


              ListView.builder(
                  itemCount: skillSetList.length,
                  padding: EdgeInsets.only(top: 15),
                  itemBuilder: (BuildContext context, int pos) {
                    return Column(
                      children: [
                        Container(
                          height: 148,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color(0xFFF3F3F3)),
                          child: Row(
                            children: [
                              Container(
                                height: 148,
                                color: AppTheme.blueColor,
                                width: 12,
                              ),
                              SizedBox(width: 7),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 7),
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
                                              Text(
                                                skillSetList[pos]['title'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          transform: Matrix4.translationValues(
                                              0.0, -25.0, 0.0),
                                          width: 85,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: AppTheme.themeColor,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Center(
                                            child: Text(returnDateInFormatTailor(skillSetList[pos]['end_date'].toString()),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          height: 41,
                                          width: 110,
                                          child: ElevatedButton(
                                              child: Text('View',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ))),
                                              onPressed: () async {

                                                String startDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(skillSetList[pos]['end_date'].toString()));

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => AssignmentDetailScreen(startDate, skillSetList[pos], false,"view")));
                                              }),
                                        ),

                                        SizedBox(width: 15),


                                        Container(
                                          height: 41,
                                          width: 110,
                                          child: ElevatedButton(
                                              child: Text('Shift',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                                  shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(4),
                                                      ))),
                                              onPressed: () async {

                                                shiftTask(context,skillSetList[pos]['category_id']);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25)
                      ],
                    );
                  }):

                  selectedTab==2?
                  fitnessList.length==0?

                  Center(
                    child: Text("No data found !"),

                  ):

                  ListView.builder(
                      itemCount: fitnessList.length,
                      padding: EdgeInsets.only(top: 15),
                      itemBuilder: (BuildContext context, int pos) {
                        return Column(
                          children: [
                            Container(
                              height: 148,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xFFF3F3F3)),
                              child: Row(
                                children: [
                                  Container(
                                    height: 148,
                                    color: AppTheme.blueColor,
                                    width: 12,
                                  ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 7),
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
                                                  Text(
                                                    fitnessList[pos]['title'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12),
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              transform: Matrix4.translationValues(
                                                  0.0, -25.0, 0.0),
                                              width: 85,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: AppTheme.themeColor,
                                                  borderRadius:
                                                  BorderRadius.circular(4)),
                                              child: Center(
                                                child: Text(returnDateInFormatTailor(fitnessList[pos]['end_date'].toString()),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12.5)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              height: 41,
                                              width: 110,
                                              child: ElevatedButton(
                                                  child: Text('View',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11.5)),
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(4),
                                                          ))),
                                                  onPressed: () async {

                                                    String startDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(fitnessList[pos]['end_date'].toString()));

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AssignmentDetailScreen(startDate, fitnessList[pos], false,"view")));


                                                  }),
                                            ),
                                            SizedBox(width: 15),
                                            Container(
                                              height: 41,
                                              width: 110,
                                              child: ElevatedButton(
                                                  child: Text('Shift',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11.5)),
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(4),
                                                          ))),
                                                  onPressed: () async {

                                                    shiftTask(context,fitnessList[pos]['category_id']);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 25)
                          ],
                        );
                      }):



                  nutritionList.length==0?

                  Center(
                    child: Text("No data found !"),

                  ):
                  ListView.builder(
                      itemCount: nutritionList.length,
                      padding: EdgeInsets.only(top: 15),
                      itemBuilder: (BuildContext context, int pos) {
                        return Column(
                          children: [
                            Container(
                              height: 148,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xFFF3F3F3)),
                              child: Row(
                                children: [
                                  Container(
                                    height: 148,
                                    color: AppTheme.blueColor,
                                    width: 12,
                                  ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 7),
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
                                                  Text(
                                                    nutritionList[pos]['title'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12),
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              transform: Matrix4.translationValues(
                                                  0.0, -25.0, 0.0),
                                              width: 85,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: AppTheme.themeColor,
                                                  borderRadius:
                                                  BorderRadius.circular(4)),
                                              child: Center(
                                                child: Text(returnDateInFormatTailor(nutritionList[pos]['end_date'].toString()),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12.5)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              height: 41,
                                              width: 110,
                                              child: ElevatedButton(
                                                  child: Text('View',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11.5)),
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(4),
                                                          ))),
                                                  onPressed: () async {
                                                    String startDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(nutritionList[pos]['end_date'].toString()));

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AssignmentDetailScreen(startDate, nutritionList[pos], false,"view")));


                                                  }),
                                            ),

                                            SizedBox(width: 15),
                                            Container(
                                              height: 41,
                                              width: 110,
                                              child: ElevatedButton(
                                                  child: Text('Shift',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11.5)),
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(4),
                                                          ))),
                                                  onPressed: () async {

                                                    shiftTask(context,nutritionList[pos]['category_id']);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 25)
                          ],
                        );
                      })



          )
        ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPendingTasks(context);
  }

  fetchPendingTasks(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getPendingCalenderData",
      "data": {
        "user_id": id,
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
    var response =
        await helper.postAPI('getPendingCalenderData', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    isLoading = false;
    pendingTasks = responseJSON['decodedData']['result'];

    for(int i=0;i<pendingTasks.length;i++)
      {
        if(pendingTasks[i]['type']=="skill-set")
          {
            skillSetList.add(pendingTasks[i]);
          }
       else if(pendingTasks[i]['type']=="nutrition")
        {
          nutritionList.add(pendingTasks[i]);
        }
        else if(pendingTasks[i]['type']=="fitness")
        {
          fitnessList.add(pendingTasks[i]);
        }
      }


    if(skillSetList.length!=0)
      {
        skillSetList.sort((a,b) {
          var adate = a['end_date']; //before -> var adate = a.expiry;
          var bdate = b['end_date']; //before -> var bdate = b.expiry;
          return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
        });
      }

    if(nutritionList.length!=0)
    {
      nutritionList.sort((a,b) {
        var adate = a['end_date']; //before -> var adate = a.expiry;
        var bdate = b['end_date']; //before -> var bdate = b.expiry;
        return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
      });
    }

    if(fitnessList.length!=0)
    {
      fitnessList.sort((a,b) {
        var adate = a['end_date']; //before -> var adate = a.expiry;
        var bdate = b['end_date']; //before -> var bdate = b.expiry;
        return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
      });
    }



    setState(() {});
  }


  shiftTask(BuildContext context,String catId) async {

    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    var data = {
      "method_name": "shiftCalenderData",
      "data": {
        "user_id": id,
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
    var response =
    await helper.postAPI('shiftCalenderData', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    Navigator.pop(context);

    if(responseJSON['decodedData']['status']=='success')
      {
        Toast.show(responseJSON['decodedData']['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        if(pendingTasks.length!=0)
          {
            pendingTasks.clear();
            skillSetList.clear();
            nutritionList.clear();
            fitnessList.clear();
            setState(() {

            });
          }
        fetchPendingTasks(context);
      }
    else
      {
        Toast.show(responseJSON['decodedData']['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

  }


  String returnDateInFormatTailor(String date) {
    final dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.d();
    final DateFormat monthFormatter = DateFormat.MMM();
    String dayAsString = dayFormatter.format(dateTime);
    String monthString = monthFormatter.format(dateTime);

    String finalString = dayAsString + " " + monthString;
    print(finalString);
    return finalString;
  }
}
