import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/performance_assesment/add_self_assesment.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/performance_assesment/current_week_screen.dart';
import 'package:klubba/widgets/heading_text_widget.dart';
import 'package:klubba/widgets/loader.dart';

class NewCoachAssesmentScreen extends StatefulWidget {
  SelfState createState() => SelfState();
}

class SelfState extends State<NewCoachAssesmentScreen> {
  int selectedWeekIndex = 0;
  int selectedTab = 1;
  List<dynamic> assesmentList = [];
  List<dynamic> skillSetList = [];
  List<dynamic> nutritionList = [];
  List<dynamic> fitnessList = [];
  bool isLoading = false;
  List<dynamic> draftMap = [];
  Map<String, dynamic> attributes = {};
  String currentCategoryImageUrl = '';
  int selectedCategoryIndex = 9999;
  List<dynamic> categoryList = [];
  String imageURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  border: Border.all(width: 1.5, color: Color(0xFFCEAC45))),
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
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : Column(
              children: [
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
                SizedBox(height: 15),
                Expanded(
                    child:

                    selectedTab==1?

                        skillSetList.length==0?

                        Center(
                          child: Text('No data found'),
                        ):

                    ListView.builder(
                        itemCount: skillSetList.length,
                        itemBuilder: (BuildContext context, int pos) {
                          return

                            skillSetList[pos].toString().contains("grades")?

                            Column(
                            children: [
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Attribute Name',
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .blueColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12)),
                                                    Text(
                                                        skillSetList[pos][
                                                            'category_attribute_name'],
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
                                                height: 58,
                                                width: 58,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.blueColor,
                                                    shape: BoxShape.circle),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Grade',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12)),
                                                    Text(
                                                        skillSetList[pos]
                                                                ['grades']["week "+ skillSetList[pos]
                                                        ['week'].toString()]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .themeColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 15)
                                            ],
                                          ),
                                          SizedBox(height: 13),
                                      /*    Container(
                                            margin: EdgeInsets.only(top: 5),
                                            height: 42,
                                            child: ElevatedButton(
                                                child: Text('Fill Details',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.5)),
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.black),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.black),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ))),
                                                onPressed: () async {


                                          final result=await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddAssesmentScreen(
                                                                  skillSetList)));

                                          if(result!=null)
                                            {
                                              String? catId = await MyUtils.getSharedPreferences('current_category_id');
                                              fetchAssesments(catId.toString());
                                            }

                                                }),
                                          ),
                                          SizedBox(height: 8),*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15)
                            ],
                          ):Container();
                        }):

                selectedTab==2?
                fitnessList.length==0?

                Center(
                  child: Text('No data found'),
                ):
                ListView.builder(
                    itemCount: fitnessList.length,
                    itemBuilder: (BuildContext context, int pos) {
                      return

                        fitnessList[pos].toString().contains("grades")?

                        Column(
                        children: [
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('Attribute Name',
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .blueColor,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 12)),
                                                Text(
                                                    fitnessList[pos][
                                                    'category_attribute_name'],
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
                                            height: 58,
                                            width: 58,
                                            decoration: BoxDecoration(
                                                color: AppTheme.blueColor,
                                                shape: BoxShape.circle),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text('Grade',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 12)),
                                                Text(
                                                    fitnessList[pos]
                                                    ['grades']["week "+ fitnessList[pos]
                                                    ['week'].toString()]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .themeColor,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15)
                                        ],
                                      ),
                                      SizedBox(height: 13),
                                    /*  Container(
                                        margin: EdgeInsets.only(top: 5),
                                        height: 42,
                                        child: ElevatedButton(
                                            child: Text('Fill Details',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.5)),
                                            style: ButtonStyle(
                                                foregroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(
                                                    Colors.black),
                                                backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(
                                                    Colors.black),
                                                shape: MaterialStateProperty
                                                    .all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                    ))),
                                            onPressed: () async {


                                              final result=await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddAssesmentScreen(
                                                              fitnessList)));

                                              if(result!=null)
                                              {
                                                String? catId = await MyUtils.getSharedPreferences('current_category_id');
                                                fetchAssesments(catId.toString());
                                              }

                                            }),
                                      ),
                                      SizedBox(height: 8),*/
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15)
                        ],
                      ):Container();
                    }):


                nutritionList.length==0?

                Center(
                  child: Text('No data found'),
                ):
                ListView.builder(
                    itemCount: nutritionList.length,
                    itemBuilder: (BuildContext context, int pos) {
                      return
                        nutritionList[pos].toString().contains("grades")?





                        Column(
                        children: [
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('Attribute Name',
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .blueColor,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 12)),
                                                Text(
                                                    nutritionList[pos][
                                                    'category_attribute_name'],
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
                                            height: 58,
                                            width: 58,
                                            decoration: BoxDecoration(
                                                color: AppTheme.blueColor,
                                                shape: BoxShape.circle),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text('Grade',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 12)),
                                                Text(
                                                    nutritionList[pos]
                                                    ['grades']["week "+ nutritionList[pos]
                                                    ['week'].toString()]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .themeColor,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15)
                                        ],
                                      ),
                                      SizedBox(height: 13),
                                   /*   Container(
                                        margin: EdgeInsets.only(top: 5),
                                        height: 42,
                                        child: ElevatedButton(
                                            child: Text('Fill Details',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.5)),
                                            style: ButtonStyle(
                                                foregroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(
                                                    Colors.black),
                                                backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(
                                                    Colors.black),
                                                shape: MaterialStateProperty
                                                    .all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                    ))),
                                            onPressed: () async {


                                              final result=await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddAssesmentScreen(
                                                              nutritionList)));

                                              if(result!=null)
                                              {
                                                String? catId = await MyUtils.getSharedPreferences('current_category_id');
                                                fetchAssesments(catId.toString());
                                              }

                                            }),
                                      ),
                                      SizedBox(height: 8),*/
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15)
                        ],
                      ):Container();
                    })

                )
              ],
            ),
    );
  }

  fetchAssesments(String catID) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

     var data = {
      "method_name": "getCompletedAttributesForCoach",
      "data": {
        "user_id": id,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id":catID,
        "action_performed_by": id
      }
    };


    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getCompletedAttributesForCoach', requestModel, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading = false;
    });
    print(responseJSON);
    if (assesmentList.length != 0) {
      assesmentList.clear();
    }


    if (skillSetList.length != 0) {
      skillSetList.clear();
    }

    if (nutritionList.length != 0) {
      nutritionList.clear();
    }

    if (fitnessList.length != 0) {
      fitnessList.clear();
    }





    assesmentList = responseJSON['decodedData']['result'];

    for(int i=0;i<assesmentList.length;i++)
      {
        if(assesmentList[i]["type"]=="skill-set")
          {
            skillSetList.add(assesmentList[i]);
          }
        else if(assesmentList[i]["type"]=="nutrition")
        {
          nutritionList.add(assesmentList[i]);
        }
        else
          {
            fitnessList.add(assesmentList[i]);
          }
      }




    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

                              fetchAssesments(
                                  categoryList[selectedCategoryIndex]
                                      ['category_id']);
                              currentCategoryImageUrl = imageURL +
                                  categoryList[selectedCategoryIndex]
                                      ['category_image'];
                              setState(() {});

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
          position: Tween(begin: Offset(0, true ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  _fetchCategoryList(BuildContext context) async {
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
    isLoading = false;
    categoryList = responseJSON['decodedData']['result'];
    imageURL = responseJSON['decodedData']['image_url'];
    if (categoryList.length != 0) {
      currentCategoryImageUrl = imageURL + categoryList[0]['category_image'];
    }

    fetchAssesments(catId.toString());

    setState(() {});
    print(responseJSON);
  }
}
