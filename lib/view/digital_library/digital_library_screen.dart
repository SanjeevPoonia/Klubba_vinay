import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/utils/filter_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/digital_library/library_tab.dart';
import 'package:klubba/view/digital_library/my_library_tab.dart';
import 'package:klubba/widgets/loader.dart';

class DigitalLibraryScreen extends StatefulWidget {
  final bool filterApplied;
  final bool categoryFilterApplied;
  final String operationType;
  int selectedInnerTab;
  DigitalLibraryScreen(this.filterApplied,this.operationType,this.selectedInnerTab,this.categoryFilterApplied);
  DigitalState createState() => DigitalState();
}

class DigitalState extends State<DigitalLibraryScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  bool filterData=false;
  String? selectedSubAttributeValue;
  List<dynamic> subAttributeList=[];
  List<String> subAttributeListAsString=[];
  String selectedSubAttributeID='';
  String? selectedCatValue;
  bool isLoading = false;
  List<dynamic> attributeList=[];
  List<String> attributeListAsString=[];
  List<dynamic> categoryList=[];
  String? selectedAttributeValue;
  List<String> categoryListAsString=[];
  String selectedCategoryGroupID='';
  String selectedAttributeID='';
  String selectedLevelId='';
  String levelID='';
  String selectedCategoryID='';
  List<dynamic> levelList=[];
  List<String> levelListAsString=[];
  String? selectedLevelValue;
  final List<String> dropDownItems = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        actions: [
          GestureDetector(
            onTap: () {
              filterBottomSheet();
            },
            child: Padding(
                padding: EdgeInsets.only(right: 13),
                child:
                    Image.asset('assets/filter_ic.png', width: 24, height: 24)),
          ),
        ],
        leading:

        widget.operationType=="Views"?
            Container():

        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
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
                text: 'Digital ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Library',
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
          Container(
            height: 53,
            padding: const EdgeInsets.only(bottom: 5),
            child: AppBar(
              backgroundColor: AppTheme.blueColor,
              bottom: TabBar(
                indicatorColor: AppTheme.themeColor,
                unselectedLabelColor: const Color(0xFFB9B9B9),
                labelColor: AppTheme.themeColor,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                controller: tabController,
                tabs: const [
                  Tab(
                    text: 'Klubba Library',
                  ),
                  Tab(
                    text: 'My Library',
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: Loader(),
                )
              : Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [KlubbaLibraryTab(widget.filterApplied,widget.operationType,widget.selectedInnerTab,widget.categoryFilterApplied), MyLibraryTab(widget.filterApplied,widget.categoryFilterApplied)],
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    _fetchCategoryList(context);
  }

  filterBottomSheet() {
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
                                Text('Filter',
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
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Select Category',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF6F6F6)),
                        width: double.infinity,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            icon: Icon(Icons.keyboard_arrow_down_outlined,
                                color: Colors.black),
                            isExpanded: true,
                            hint: Text(
                              'Select category',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: categoryListAsString
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
                            value: selectedCatValue,
                            onChanged: (value) async {
                              dialogState(() {
                                selectedCatValue = value as String;
                              });

                              String categoryID='';

                              for(int i=0;i<categoryList.length;i++)
                              {
                                if(selectedCatValue==categoryList[i]['category'])
                                {
                                  categoryID=categoryList[i]['category_id'];
                                  selectedCategoryGroupID=categoryList[i]['category_group_id'];
                                  break;
                                }
                              }
                              FilterModel.setCategoryValue(categoryID);
                              selectedCategoryID=categoryID;
                          bool apiStatus=  await _fetchAttributeList(context,categoryID);
                          if(apiStatus)
                            {
                              dialogState(() {
                              });
                            }
                            },
                            buttonHeight: 40,
                            buttonWidth: 140,
                            itemHeight: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Select Level',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF6F6F6)),
                        width: double.infinity,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            icon: Icon(Icons.keyboard_arrow_down_outlined,
                                color: Colors.black),
                            isExpanded: true,
                            hint: Text(
                              'Select Level',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: levelListAsString
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
                            value: selectedLevelValue,
                            onChanged: (value) {
                              dialogState(() {
                                selectedLevelValue = value as String;
                              });
                              String levelID='';

                              for(int i=0;i<levelList.length;i++)
                              {
                                if(selectedLevelValue==levelList[i]['text'])
                                {

                                  levelID=levelList[i]['id'];
                                  break;
                                }
                              }

                              selectedLevelId=levelID;
                              FilterModel.setLearnerValue(selectedLevelId);
                            },
                            buttonHeight: 40,
                            buttonWidth: 140,
                            itemHeight: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Select Attribute',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF6F6F6)),
                        width: double.infinity,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            icon: Icon(Icons.keyboard_arrow_down_outlined,
                                color: Colors.black),
                            isExpanded: true,
                            hint: Text(
                              'Select attribute',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: attributeListAsString
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
                            value: selectedAttributeValue,
                            onChanged: (value) async {
                              dialogState(() {
                                selectedAttributeValue = value as String;
                              });


                              String attributeID='';

                              for(int i=0;i<attributeList.length;i++)
                              {
                                if(selectedAttributeValue==attributeList[i]['text'])
                                {

                                  attributeID=attributeList[i]['id'];
                                  break;
                                }
                              }

                              selectedAttributeID=attributeID;
                              FilterModel.setAttributeValue(selectedAttributeID);
                              bool apiStatus=  await _fetchSubAttributeList(context,attributeID);
                              if(apiStatus)
                              {
                                dialogState(() {
                                });
                              }

                            },
                            buttonHeight: 40,
                            buttonWidth: 140,
                            itemHeight: 40,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('Select Sub-Attribute',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),


                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF6F6F6)),
                        width: double.infinity,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            icon: Icon(Icons.keyboard_arrow_down_outlined,
                                color: Colors.black),
                            isExpanded: true,
                            hint: Text(
                              'Select category sub attribute',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: subAttributeListAsString
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
                            value: selectedSubAttributeValue,
                            onChanged: (value) {
                              dialogState(() {
                                selectedSubAttributeValue = value as String;
                              });

                              String subAttributeID='';

                              for(int i=0;i<subAttributeList.length;i++)
                              {
                                if(selectedSubAttributeValue==subAttributeList[i]['text'])
                                {

                                  subAttributeID=subAttributeList[i]['id'];
                                  break;
                                }
                              }

                              selectedSubAttributeID=subAttributeID;

                              FilterModel.setSubAttributeValue(selectedSubAttributeID);

                            },
                            buttonHeight: 40,
                            buttonWidth: 140,
                            itemHeight: 40,
                          ),
                        ),
                      ),

                      SizedBox(height: 42),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, top: 5, bottom: 25),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            child: Text('Update',
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
                              FilterModel.setSubAttributeValue(selectedSubAttributeID);
                              FilterModel.setAttributeValue(selectedAttributeID);
                              FilterModel.setLearnerValue(selectedLevelId);
                              Navigator.pop(context);
                              Navigator. pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DigitalLibraryScreen(true,widget.operationType,widget.selectedInnerTab,true),
                                ),
                              );
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

  _fetchCategoryList(BuildContext context) async {
    setState(() {
      isLoading=true;
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
    setState(() {
      isLoading=false;
    });
    categoryList = responseJSON['decodedData']['result'];
    levelList = responseJSON['decodedData']['dropdowns']['learner_stages'];
    for(int i=0;i<categoryList.length;i++)
    {
      categoryListAsString.add(categoryList[i]['category']);
      if(catId==categoryList[i]["category_id"])
        {
          selectedCatValue=categoryList[i]["category"];
        }
    }

    if(levelList.length!=0)
    {
      levelList.removeAt(0);
    }

    for(int i=0;i<levelList.length;i++)
    {
      levelListAsString.add(levelList[i]['text']);
    }
    _fetchSeparateAttributeList(context);
    setState(() {});
    print(responseJSON);
  }


  Future<bool> _fetchAttributeList(BuildContext context,String categoryId) async {
    bool apiStatus=true;
    if(attributeList.length!=0)
    {
      attributeListAsString.clear();
      attributeList.clear();
      selectedAttributeValue=null;
    }
    if(subAttributeList.length!=0)
    {
      subAttributeListAsString.clear();
      subAttributeList.clear();
      selectedSubAttributeValue=null;
    }
    selectedLevelValue=null;

    APIDialog.showAlertDialog(context, 'Please wait');

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name":"getCategoryAttributesList",
      "data":{
        "category_id":categoryId,
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":catId,
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getLearnerCategoryList', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    attributeList = responseJSON['decodedData']['result']['category_attribute_list'];
    if(attributeList.length!=0)
    {
      attributeList.removeAt(0);
    }
    for(int i=0;i<attributeList.length;i++)
    {
      attributeListAsString.add(attributeList[i]['text']);
    }
    setState(() {});
    print(responseJSON);
   return apiStatus;
  }


   _fetchSeparateAttributeList(BuildContext context) async {

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name":"getCategoryAttributesList",
      "data":{
        "category_id":catId,
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":catId,
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getLearnerCategoryList', requestModel, context);
    var responseJSON = json.decode(response.body);
    attributeList = responseJSON['decodedData']['result']['category_attribute_list'];
    if(attributeList.length!=0)
    {
      attributeList.removeAt(0);
    }
    for(int i=0;i<attributeList.length;i++)
    {
      attributeListAsString.add(attributeList[i]['text']);
    }
    setState(() {});
    print(responseJSON);
  }



  Future<bool> _fetchSubAttributeList(BuildContext context,String attributeID) async {
    bool apiStatus=true;
    if(subAttributeList.length!=0)
    {
      subAttributeListAsString.clear();
      subAttributeList.clear();
    }

    APIDialog.showAlertDialog(context, 'Please wait');

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data={
      "method_name":"getCategorySubAttributesList",
      "data":{
        "category_attribute_id":attributeID,
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":catId,
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getCategorySubAttributesList', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    subAttributeList = responseJSON['decodedData']['result']['category_sub_attribute_list'];
    if(subAttributeList.length!=0)
    {
      subAttributeList.removeAt(0);
    }
    for(int i=0;i<subAttributeList.length;i++)
    {
      subAttributeListAsString.add(subAttributeList[i]['text']);
    }
    setState(() {});
    print(responseJSON);
    return apiStatus;
  }


}
