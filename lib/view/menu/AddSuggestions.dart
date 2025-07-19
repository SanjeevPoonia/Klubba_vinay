import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class AddSuggestions extends StatefulWidget{
  _addSuggestions createState()=> _addSuggestions();
}
class _addSuggestions extends State<AddSuggestions>{
  final _formKey = GlobalKey<FormState>();
  final _formCategoryKey = GlobalKey<FormState>();
  final _formOtherKey = GlobalKey<FormState>();
  final _formAttributeKey = GlobalKey<FormState>();
  final _formSubAttributeKey = GlobalKey<FormState>();
  bool isLoading=false;
  List<dynamic> stageList=[];

  int stageSelectedIndex=0;
  String stageInitialDropDownVal="";

  List<dynamic> categoryGroupList=[];
  List<DropdownMenuItem<String>> categoryGroupDropdownItems = [];
  int categoryGroupSelectedIndex=0;
  String categoryGroupInitialDropDownVal="";

  List<dynamic> categoryList=[];
  List<DropdownMenuItem<String>> categoryDropdownItems = [];
  int categorySelectedIndex=0;
  String categoryInitialDropDownVal="";

  bool _fromTop = true;


  List<dynamic> attributeList=[];


  String _attribu = "";


  List<DropdownMenuItem<String>> suggTypeDropdownItems = [];
  int suggTypeSelectedIndex=0;
  String suggTypeInitialDropDownVal="";


  List<learnerModel> leanerStageList=[];
  String selectedStage="";
  List<learnerModel> attriList=[];
  String selectedattri="";
  String selectedAttriIds="";
  List<String> selectedAttriArray=[];


  TextEditingController catNameController = TextEditingController();
  TextEditingController catdescriptionController = TextEditingController();

  TextEditingController attributeNameController = TextEditingController();
  TextEditingController attridescriptionController = TextEditingController();

  TextEditingController subAttributeNameController = TextEditingController();
  TextEditingController subAttridescriptionController = TextEditingController();

  TextEditingController otherNameController = TextEditingController();
  TextEditingController otherdescriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return isLoading?Center(child: Loader(),):Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.all(10),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text("Suggestion Type*",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppTheme.blueColor
                  ),),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton(
                    value: suggTypeInitialDropDownVal,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: suggTypeDropdownItems,
                    onChanged: (String? value) {
                      setState(() {
                        suggTypeInitialDropDownVal = value!;
                        suggTypeSelectedIndex=suggTypeDropdownItems.indexWhere((i) => i.value==value);
                      });
                      print(suggTypeInitialDropDownVal);

                      /*if(categoryGroupInitialDropDownVal!=''){
                        _fetchCategoryDropDown(context);
                      }*/

                    },
                    isExpanded: true,

                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                suggTypeInitialDropDownVal=='category'?_getCategoryWidget():
                suggTypeInitialDropDownVal=='others'?_getOtherWidget():
                suggTypeInitialDropDownVal=='attribute'?_getAttributeWidget():
                suggTypeInitialDropDownVal=='sub_attributes'?_getSubAttributeWidget():
                Center(),




              ],
            ),)


          ],
        ));
  }
  @override
  void initState(){
    super.initState();
    _fetchStageDropDown(context);
  }

  _fetchCategoryGroupDropDown(BuildContext context) async{
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getDigitalLibraryDropDown",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getDigitalLibraryDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']['status'].toString()=='success'){
      categoryGroupList.clear();
      categoryGroupList=responseJSON['decodedData']['result']['categoryGroupData'];

      for(int i=0;i<categoryGroupList.length;i++){
        String id = categoryGroupList[i]['id'].toString();
        String val= categoryGroupList[i]['text'].toString();
        if(i==0){
          categoryGroupInitialDropDownVal=id;
        }
        var newItem=DropdownMenuItem(value: id,child: Text(val),);
        categoryGroupDropdownItems.add(newItem);
      }



      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }


  }
  _fetchStageDropDown(BuildContext context)async{
    setState(() {
      isLoading=true;
    });

    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "method_name": "getMasterDropDown",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
        "dropdown_type":"learner_stages"
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getMasterDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']['status'].toString()=='success'){
      stageList.clear();
      leanerStageList.clear();

      stageList=responseJSON['decodedData']['result'];
      for(int i=0;i<stageList.length;i++){
        String id = stageList[i]['id'].toString();
        String val= stageList[i]['text'].toString();
        if(i==0){
          stageInitialDropDownVal=id;
        }
        if(id!=""){
          leanerStageList.add(new learnerModel(id, val, false));
        }





      }

      /*****Add Suggestions Types*/
      var selectItem=DropdownMenuItem(value: "",child: Text("Select"),);
      var selectItem1=DropdownMenuItem(value: "category",child: Text("Category"),);
      var selectItem2=DropdownMenuItem(value: "attribute",child: Text("Attributes"),);
      var selectItem3=DropdownMenuItem(value: "sub_attributes",child: Text("Sub Attributes"),);
      var selectItem4=DropdownMenuItem(value: "others",child: Text("Other"),);
      suggTypeDropdownItems.add(selectItem);
      suggTypeDropdownItems.add(selectItem1);
      suggTypeDropdownItems.add(selectItem2);
      suggTypeDropdownItems.add(selectItem3);
      suggTypeDropdownItems.add(selectItem4);

      suggTypeInitialDropDownVal="";




      _fetchCategoryGroupDropDown(context);

    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }
  _fetchCategoryDropDown(BuildContext context)async{
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "method_name": "getCategoryByCategoryGroup",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
        "category_group_id":categoryGroupInitialDropDownVal
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getCategoryByCategoryGroup', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']['status'].toString()=='success'){
      categoryList.clear();

      categoryList=responseJSON['decodedData']['result']['category_list'];

      for(int i=0;i<categoryList.length;i++){
        String id = categoryList[i]['id'].toString();
        String val= categoryList[i]['text'].toString();
        if(i==0){
          categoryInitialDropDownVal=id;
        }
        var newItem=DropdownMenuItem(value: id,child: Text(val),);
        categoryDropdownItems.add(newItem);
      }



    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }
    Navigator.of(context).pop();
    setState(() {

    });
  }
  _fetchAttributeDropDown(BuildContext context)async{
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "method_name": "getCategoryAttributesList",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
        "category_id":categoryInitialDropDownVal
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getCategoryAttributesList', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']['status'].toString()=='success'){
      attributeList.clear();

      attriList.clear();

      attributeList=responseJSON['decodedData']['result']['category_attribute_list'];

      for(int i=0;i<attributeList.length;i++){
        String id = attributeList[i]['id'].toString();
        String val= attributeList[i]['text'].toString();

        var newItem=DropdownMenuItem(value: id,child: Text(val),);

        if(id!=""){
          attriList.add(learnerModel(id, val, false));
        }
      }
      Navigator.of(context).pop();


    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();

    }
  }




  Widget _getCategoryWidget(){


    return Form(
      key: _formCategoryKey,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Suggest ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text("New Category",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          Container(
            height: 5,
            margin: EdgeInsets.only(left: 73),
            width: 35,
            color: AppTheme.themeColor,
            alignment: Alignment.topLeft,
          ),

          SizedBox(height: 10,),
          const Text("Category Group*",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: AppTheme.blueColor
            ),),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.greyColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton(
              value: categoryGroupInitialDropDownVal,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: categoryGroupDropdownItems,
              onChanged: (String? value) {
                setState(() {
                  categoryGroupInitialDropDownVal = value!;
                  categoryGroupSelectedIndex=categoryGroupDropdownItems.indexWhere((i) => i.value==value);
                });
                print(categoryGroupInitialDropDownVal);

                if(categoryGroupInitialDropDownVal!=''){
                  _fetchCategoryDropDown(context);
                }

              },
              isExpanded: true,

            ),
          ),
          SizedBox(height: 15,),

        /*  const Text("Category*",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: AppTheme.blueColor
            ),),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.greyColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton(
              value: categoryInitialDropDownVal,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: categoryDropdownItems,
              onChanged: (String? value) {
                setState(() {
                  categoryInitialDropDownVal = value!;
                  categorySelectedIndex=categoryDropdownItems.indexWhere((i) => i.value==value);
                });

                if(categoryInitialDropDownVal!=""){
                  _fetchAttributeDropDown(context);
                }
              },
              isExpanded: true,

            ),
          ),
          SizedBox(height: 15,),*/

          Text("Category Name",
            style: TextStyle(
                color: AppTheme.blueColor,
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.greyColor,
            ),

            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: catNameController,
              maxLength: 100,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: "Enter Category Name",
                  hintStyle: TextStyle(
                      color: AppTheme.hintColor,
                      fontSize: 15
                  ),
                  border: InputBorder.none
              ),
              validator: categoryNameValidatior,

            ),
          ),
          SizedBox(height: 15,),

          Text("Description",
            style: TextStyle(
                color: AppTheme.blueColor,
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.greyColor,
            ),

            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: catdescriptionController,
              maxLength: 250,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                  hintText: "Enter Description",
                  hintStyle: TextStyle(
                      color: AppTheme.hintColor,
                      fontSize: 15
                  ),
                  border: InputBorder.none
              ),
              validator: descriptionValidatior,

            ),
          ),
          SizedBox(height: 15,),

          InkWell(
            onTap: () {
              _submitCategoryHandler(context);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                    BorderRadius.circular(5)),
                height: 50,
                child: const Center(
                  child: Text('Submit',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                )),
          )


        ],

      ) ,
    );
  }
  Widget _getOtherWidget(){

    return Form(
      key: _formOtherKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              Text("Other ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text("Suggestion",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          Container(
            height: 5,
            margin: EdgeInsets.only(left: 60),
            width: 35,
            color: AppTheme.themeColor,
            alignment: Alignment.topLeft,
          ),
          SizedBox(height: 10,),
          Text("Suggestion",
            style: TextStyle(
                color: AppTheme.blueColor,
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.greyColor,
            ),

            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: otherNameController,
              maxLength: 100,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: "Enter Name",
                  hintStyle: TextStyle(
                      color: AppTheme.hintColor,
                      fontSize: 15
                  ),
                  border: InputBorder.none
              ),
              validator: otherNameValidatior,

            ),
          ),
          SizedBox(height: 15,),

          Text("Description",
            style: TextStyle(
                color: AppTheme.blueColor,
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.greyColor,
            ),

            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: otherdescriptionController,
              maxLength: 250,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                  hintText: "Enter Description",
                  hintStyle: TextStyle(
                      color: AppTheme.hintColor,
                      fontSize: 15
                  ),
                  border: InputBorder.none
              ),
              validator: descriptionValidatior,

            ),
          ),
          SizedBox(height: 15,),

          InkWell(
            onTap: () {
              _submitOtherHandler(context);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                    BorderRadius.circular(5)),
                height: 50,
                child: const Center(
                  child: Text('Submit',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                )),
          )
        ],
      ),

    );
  }
  Widget _getSubAttributeWidget(){

    return Form(
        key: _formSubAttributeKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Suggest ",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text("New Sub Attribute",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            Container(
              height: 5,
              margin: EdgeInsets.only(left: 73),
              width: 35,
              color: AppTheme.themeColor,
              alignment: Alignment.topLeft,
            ),
            SizedBox(height: 10,),
            const Text("Category Group*",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.blueColor
              ),),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton(
                value: categoryGroupInitialDropDownVal,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: categoryGroupDropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    categoryGroupInitialDropDownVal = value!;
                    categoryGroupSelectedIndex=categoryGroupDropdownItems.indexWhere((i) => i.value==value);
                  });
                  print(categoryGroupInitialDropDownVal);

                  if(categoryGroupInitialDropDownVal!=''){
                    _fetchCategoryDropDown(context);
                  }

                },
                isExpanded: true,

              ),
            ),
            SizedBox(height: 15,),
            const Text("Category*",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.blueColor
              ),),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton(
                value: categoryInitialDropDownVal,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: categoryDropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    categoryInitialDropDownVal = value!;
                    categorySelectedIndex=categoryDropdownItems.indexWhere((i) => i.value==value);
                  });

                  if(categoryInitialDropDownVal!=""){
                    _fetchAttributeDropDown(context);
                  }
                },
                isExpanded: true,

              ),
            ),
            SizedBox(height: 15,),
            const Text("Learner Stages*",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.blueColor
              ),),
            GestureDetector(
              onTap: () {
                if(leanerStageList.isNotEmpty){
                  _showDialog();
                }

              },
              child: Container(

                height: 48,
                color: AppTheme.greyColor,
                child: Row(
                  children: [
                    selectedStage==""?Text("Please Select",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: _attribu == ""
                              ? Colors.grey
                              : Colors.black,
                        )):
                    Text(selectedStage,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: _attribu == ""
                              ? Colors.grey
                              : Colors.black,
                        )),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),


            SizedBox(height: 15,),
            const Text("Attributes*",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.blueColor
              ),),
            GestureDetector(
              onTap: () {
                if(attriList.isNotEmpty){

                  _showAttriDialog();
                }

              },
              child: Container(

                height: 48,
                color: AppTheme.greyColor,
                child: Row(
                  children: [
                    selectedattri==''?
                    Text("Attributes",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: _attribu == ""
                              ? Colors.grey
                              : Colors.black,
                        )):
                    Text(selectedattri,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: _attribu == ""
                              ? Colors.grey
                              : Colors.black,
                        )),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Suggested Sub Attribute Name",
              style: TextStyle(
                  color: AppTheme.blueColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.greyColor,
              ),

              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: subAttributeNameController,
                maxLength: 100,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: "Enter Name",
                    hintStyle: TextStyle(
                        color: AppTheme.hintColor,
                        fontSize: 15
                    ),
                    border: InputBorder.none
                ),
                validator: SubAttributeNameValidatior,

              ),
            ),
            SizedBox(height: 15,),

            Text("Description",
              style: TextStyle(
                  color: AppTheme.blueColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.greyColor,
              ),

              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: subAttridescriptionController,
                maxLength: 250,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: "Enter Description",
                    hintStyle: TextStyle(
                        color: AppTheme.hintColor,
                        fontSize: 15
                    ),
                    border: InputBorder.none
                ),
                validator: descriptionValidatior,

              ),
            ),
            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                _submitSubAttriHandler(context);
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                      BorderRadius.circular(5)),
                  height: 50,
                  child: const Center(
                    child: Text('Submit',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  )),
            )
          ],
        )
    );
  }
  Widget _getAttributeWidget(){

    return Form(
        key: _formAttributeKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Suggest ",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text("New Attribute",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            Container(
              height: 5,
              margin: EdgeInsets.only(left: 73),
              width: 35,
              color: AppTheme.themeColor,
              alignment: Alignment.topLeft,
            ),
            SizedBox(height: 10,),
            const Text("Category Group*",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.blueColor
              ),),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton(
                value: categoryGroupInitialDropDownVal,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: categoryGroupDropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    categoryGroupInitialDropDownVal = value!;
                    categoryGroupSelectedIndex=categoryGroupDropdownItems.indexWhere((i) => i.value==value);
                  });
                  print(categoryGroupInitialDropDownVal);

                  if(categoryGroupInitialDropDownVal!=''){
                    _fetchCategoryDropDown(context);
                  }

                },
                isExpanded: true,

              ),
            ),
            SizedBox(height: 15,),
            const Text("Category*",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.blueColor
              ),),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton(
                value: categoryInitialDropDownVal,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: categoryDropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    categoryInitialDropDownVal = value!;
                    categorySelectedIndex=categoryDropdownItems.indexWhere((i) => i.value==value);
                  });

                  if(categoryInitialDropDownVal!=""){
                    _fetchAttributeDropDown(context);
                  }
                },
                isExpanded: true,

              ),
            ),
            SizedBox(height: 15,),
            const Text("Learner Stages*",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.blueColor
              ),),
            GestureDetector(
              onTap: () {
                if(leanerStageList.isNotEmpty){
                  _showDialog();
                }

              },
              child: Container(

                height: 48,
                color: AppTheme.greyColor,
                child: Row(
                  children: [
                    selectedStage==""?Text("Please Select",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15.0,
                          color: _attribu == ""
                              ? Colors.grey
                              : Colors.black,
                        )):
                    Text(selectedStage,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15.0,
                          color: _attribu == ""
                              ? Colors.grey
                              : Colors.black,
                        )),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),

            SizedBox(height: 15,),
            Text("Suggested Attribute Name",
              style: TextStyle(
                  color: AppTheme.blueColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.greyColor,
              ),

              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: attributeNameController,
                maxLength: 100,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: "Enter Name",
                    hintStyle: TextStyle(
                        color: AppTheme.hintColor,
                        fontSize: 15
                    ),
                    border: InputBorder.none
                ),
                validator: AttributeNameValidatior,

              ),
            ),
            SizedBox(height: 15,),

            Text("Description",
              style: TextStyle(
                  color: AppTheme.blueColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.greyColor,
              ),

              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: attridescriptionController,
                maxLength: 250,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: "Enter Description",
                    hintStyle: TextStyle(
                        color: AppTheme.hintColor,
                        fontSize: 15
                    ),
                    border: InputBorder.none
                ),
                validator: descriptionValidatior,

              ),
            ),
            SizedBox(height: 15,),

            InkWell(
              onTap: () {
                _submitAttriHandler(context);
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                      BorderRadius.circular(5)),
                  height: 50,
                  child: const Center(
                    child: Text('Submit',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  )),
            )
          ],
        )
    );
  }

  String? categoryNameValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Category Name!';
    }
    return null;
  }
  String? AttributeNameValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Attribute Name!';
    }
    return null;
  }
  String? SubAttributeNameValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Sub Attribute Name!';
    }
    return null;
  }
  String? descriptionValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Description!';
    }
    return null;
  }
  String? otherNameValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Suggestion name!';
    }
    return null;
  }




  void _submitCategoryHandler(BuildContext context) async {
    if (!_formCategoryKey.currentState!.validate()) {
      return;
    }
    _formCategoryKey.currentState!.save();
    _checkCategoryValidations();
  }
  void _submitOtherHandler(BuildContext context) async {
    if (!_formOtherKey.currentState!.validate()) {
      return;
    }
    _formOtherKey.currentState!.save();
    _submitOtherSuggestion();

  }
  void _submitAttriHandler(BuildContext context) async{
    if(!_formAttributeKey.currentState!.validate()){
      return;
    }
    _formAttributeKey.currentState!.save();
    _checkAttributeValidation();
  }
  void _submitSubAttriHandler(BuildContext context) async{
    if(!_formSubAttributeKey.currentState!.validate()){
      return;
    }
    _formSubAttributeKey.currentState!.save();
    _checkSubAttributeValidation();
  }


  _checkCategoryValidations() {
    if (categoryGroupInitialDropDownVal.isEmpty) {
      Toast.show('Please Select Category Group',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    else {
     print("Validation Successfull");
     _submitCategorySuggestion();
    }
  }
  _checkSubAttributeValidation(){
    String stages="";
    List<String> stagesList=[];
    for(int i=0;i<leanerStageList.length;i++){
      if(leanerStageList[i].selected){
        stagesList.add(leanerStageList[i].value);
        if(stages==""){
          stages=leanerStageList[i].value;
        }else{
          stages="$stages,${leanerStageList[i].value}";
        }
      }

    }


    if (categoryGroupInitialDropDownVal.isEmpty) {
      Toast.show('Please Select Category Group',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(categoryInitialDropDownVal.isEmpty){
      Toast.show('Please Select Category',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(stages==''){
      Toast.show('Please Select Learner Stages',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedAttriIds==''){
      Toast.show('Please Select Attributes',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      print("validation Successfull");
      print(stages);
      print(selectedAttriIds);
      _submitSubAttributeSuggestion(stages,stagesList);
    }

  }
  _checkAttributeValidation(){

    String stages="";
    List<String> stagesList=[];
    for(int i=0;i<leanerStageList.length;i++){
      if(leanerStageList[i].selected){
        stagesList.add(leanerStageList[i].value);
        if(stages==""){
          stages=leanerStageList[i].value;
        }else{
          stages="$stages,${leanerStageList[i].value}";
        }
      }

    }


    if (categoryGroupInitialDropDownVal.isEmpty) {
      Toast.show('Please Select Category Group',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(categoryInitialDropDownVal.isEmpty){
      Toast.show('Please Select Category',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(stages==''){
      Toast.show('Please Select Learner Stages',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      print("validation Successfull");
      print(stages);
      _submitAttributeSuggestion(stages,stagesList);
    }
  }





  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // StatefulBuilder
          builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                Container(
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Select Learner Stage",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 15,
                          ),


                          ListBody(
                            children: leanerStageList.map((e) => CheckboxListTile(
                              value: e.selected,
                              onChanged: (val){
                                setState((){
                                  e.selected=val!;
                                });
                              },
                              title: Text(e.text),
                              controlAffinity: ListTileControlAffinity.leading,
                            )).toList(),
                          ),

                          /*ListView.builder(
                              itemCount: leanerStageList.length,
                              shrinkWrap: false,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int pos){
                                return CheckboxListTile(
                                    value: leanerStageList[pos].selected,
                                    title: Text(leanerStageList[pos].value),
                                    onChanged: (val){
                                      setState((){
                                        leanerStageList[pos].selected=val!;
                                      });
                                    }
                                );
                              }),*/

                          InkWell(
                            onTap: () {
                              selectedStage="";
                              for(int i=0;i<leanerStageList.length;i++){
                                if(leanerStageList[i].selected){
                                  print(leanerStageList[i].text);
                                  if(selectedStage==""){
                                    selectedStage=leanerStageList[i].text;
                                  }else {
                                    selectedStage ="$selectedStage , ${leanerStageList[i].text}";
                                  }
                                }
                              }
                              setState((){});
                              Navigator.pop(context);





                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                height: 50,
                                child: const Center(
                                  child: Text('Save',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                )),
                          )
                        ],
                      ),
                    ))
              ],
            );
          },
        );
      },
    );
  }


  void _showAttriDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // StatefulBuilder
          builder: (context, dialogState) {
            return AlertDialog(
              actions: <Widget>[
                Container(
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Select Attributes",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 15,
                          ),


                          ListBody(
                            children: attriList.map((e) => CheckboxListTile(
                              value: e.selected,
                              onChanged: (val){
                                dialogState((){
                                  e.selected=val!;
                                });
                              },
                              title: Text(e.text),
                              controlAffinity: ListTileControlAffinity.leading,
                            )).toList(),
                          ),



                          InkWell(
                            onTap: () {
                              selectedattri="";
                              selectedAttriIds="";
                              selectedAttriArray.clear();
                              for(int i=0;i<attriList.length;i++){
                                if(attriList[i].selected){
                                  print(attriList[i].text);
                                  selectedAttriArray.add(attriList[i].value);
                                  if(selectedattri==""){
                                    selectedattri=attriList[i].text;
                                    selectedAttriIds=attriList[i].value;
                                  }else {
                                    selectedattri ="$selectedattri , ${attriList[i].text}";
                                    selectedAttriIds="$selectedAttriIds,${attriList[i].value}";
                                  }
                                }
                              }
                              print(selectedattri);
                              print(selectedAttriIds);

                              Navigator.pop(context);
                              dialogState((){});




                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                height: 50,
                                child: const Center(
                                  child: Text('Save',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                )),
                          )
                        ],
                      ),
                    ))
              ],
            );
          },
        );
      },
    );
  }


  _submitOtherSuggestion() async{
    APIDialog.showAlertDialog(context, "Please Wait..");
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveSuggestionData",
      "data": {
        "action_performed_by":id,
        "category":'',
        "category_attributes":[],
        "category_group":"",
        "current_category_id":catId,
        "current_role":role,
        "learner_stages":[],
        "message":otherdescriptionController.text,
        "name":otherNameController.text,
        "slug": AppModel.slug,
        "type":suggTypeInitialDropDownVal,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('saveSuggestionData', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status']=='success'){
      suggTypeInitialDropDownVal="";
      _showSuccessDialog(responseJSON['decodedData']['message']);

    }else{
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {

    });

  }
  _submitCategorySuggestion() async{
    APIDialog.showAlertDialog(context, "Please Wait..");
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveSuggestionData",
      "data": {
        "action_performed_by":id,
        "category":'',
        "category_attributes":[],
        "category_group":categoryGroupInitialDropDownVal,
        "current_category_id":catId,
        "current_role":role,
        "learner_stages":[],
        "message":catdescriptionController.text,
        "name":catNameController.text,
        "slug": AppModel.slug,
        "type":suggTypeInitialDropDownVal,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('saveSuggestionData', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status']=='success'){
      catNameController.text="";
      catdescriptionController.text="";
      suggTypeInitialDropDownVal="";
      categoryGroupInitialDropDownVal="";
      _showSuccessDialog(responseJSON['decodedData']['message']);
    }else{
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    setState(() {

    });

  }
  _submitAttributeSuggestion(String stages,List<String> stageArray) async{
    APIDialog.showAlertDialog(context, "Please Wait..");
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveSuggestionData",
      "data": {
        "action_performed_by":id,
        "category":categoryInitialDropDownVal,
        "category_attributes":[],
        "category_group":categoryGroupInitialDropDownVal,
        "current_category_id":catId,
        "current_role":role,
        "learner_stages":stageArray,
        "name":attributeNameController.text,
        "message":attridescriptionController.text,
        "slug": AppModel.slug,
        "type":suggTypeInitialDropDownVal,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('saveSuggestionData', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status']=='success'){
      attributeNameController.text="";
      attridescriptionController.text="";
      suggTypeInitialDropDownVal="";
      categoryGroupInitialDropDownVal="";
      _showSuccessDialog(responseJSON['decodedData']['message']);
    }else{
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    setState(() {

    });

  }
  _submitSubAttributeSuggestion(String stages,List<String>stageArray) async{
    APIDialog.showAlertDialog(context, "Please Wait..");
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveSuggestionData",
      "data": {
        "action_performed_by":id,
        "category":categoryInitialDropDownVal,
        "category_attributes":selectedAttriArray,
        "category_group":categoryGroupInitialDropDownVal,
        "current_category_id":catId,
        "current_role":role,
        "learner_stages":stageArray,
        "name":subAttributeNameController.text,
        "message":subAttridescriptionController.text,
        "slug": AppModel.slug,
        "type":suggTypeInitialDropDownVal,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('saveSuggestionData', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status']=='success'){
      subAttributeNameController.text="";
      subAttridescriptionController.text="";
      suggTypeInitialDropDownVal="";
      categoryGroupInitialDropDownVal="";
      _showSuccessDialog(responseJSON['decodedData']['message']);
    }else{
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    setState(() {

    });

  }

  _showSuccessDialog(String msg) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('',
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
                            Text('',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                    fontSize: 16)),
                            SizedBox(height: 3),
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
                      child: Lottie.asset('assets/support_success.json')
                  ),
                  SizedBox(height: 10,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Text(msg,
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                          fontSize: 16)),)
                  ,
                  SizedBox(height: 27),
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
                        onPressed: () {
                          Navigator.pop(context);

                        }),
                  )
                ],
              ),
              margin: EdgeInsets.only(top: 22),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }






}

class learnerModel{
  learnerModel(this.value,this.text,this.selected);
  var value="";
  var text="";
  bool selected=false;
}