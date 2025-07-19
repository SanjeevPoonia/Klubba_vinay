
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class SupportOther extends StatefulWidget{
  _supportOther createState()=>_supportOther();
}
class _supportOther extends State<SupportOther>{
  bool isLoading=false;
  List<dynamic> dropList=[];

  List<DropdownMenuItem<String>> dropdownItems = [];
  int selectedIndex=0;
  String initialDropDownVal="";

  final _formHelp = GlobalKey<FormState>();

  String firstNameStr="";
  String lastNameStr="";
  String nameStr="";
  String profileStr="";
  String mobileStr="";
  String emailStr="";
  String dropdownvalue="Please Select";

  TextEditingController helpMessageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
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
                text: 'Other ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Questions',
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
      body:  isLoading?
      Center(
        child: Loader(),
      ):Form(
          key: _formHelp,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Support Type*",
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:DropdownButtonHideUnderline(
                    child:  DropdownButton(
                      value: initialDropDownVal,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dropdownItems,
                      onChanged: (String? value) {
                        setState(() {
                          initialDropDownVal = value!;
                          selectedIndex=dropdownItems.indexWhere((i) => i.value==value);
                          print(initialDropDownVal);
                        });
                      },
                      isExpanded: true,

                    ),
                  )
                ),
                SizedBox(height: 15,),
                Text("Description*",
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
                    controller: helpMessageController,
                    maxLength: 250,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        hintText: "Enter Details",
                        hintStyle: TextStyle(
                            color: AppTheme.hintColor,
                            fontSize: 15
                        ),
                        border: InputBorder.none
                    ),
                    validator: reViewValidatior,

                  ),
                ),

                Spacer(),


                InkWell(
                  onTap: () {
                    _submitHandler(context);
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
                ),

                SizedBox(height: 20,),
              ],
            ),
          )
      ),
    );
  }

  String? reViewValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Description';
    }
    return null;
  }
  void _submitHandler(BuildContext context) async {
    if (!_formHelp.currentState!.validate()) {
      return;
    }
    _formHelp.currentState!.save();
    _checkValidations();
  }
  _checkValidations() {
    if (initialDropDownVal.isEmpty) {
      Toast.show('Please Select Support Type',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    else {
      _submitHelp(context);
    }
  }
  @override
  void initState(){
    super.initState();

    _fetchDropDown(context);
  }

  _fetchDropDown(BuildContext context)async{
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
        "dropdown_type":"support_type"
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getMasterDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']['status'].toString()=='success'){
      dropList.clear();

      dropList=responseJSON['decodedData']['result'];

      for(int i=0;i<dropList.length;i++){
        String id = dropList[i]['id'].toString();
        String val= dropList[i]['text'].toString();
        if(i==0){
          initialDropDownVal=id;
        }
        var newItem=DropdownMenuItem(value: id,child: Text(val),);
        dropdownItems.add(newItem);
      }

      _fetchUderDetails(context);
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

  _fetchUderDetails(BuildContext context) async{

    var data = {
      "method_name": "getUserDetailBySlug",
      "data": {
        "slug": AppModel.slug
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getUserDetailBySlug', requestModel, context);
    var responseJSON = json.decode(response.body);

    if(responseJSON['decodedData']['status'].toString()=='success'){
      nameStr = responseJSON['decodedData']['result']['full_name']!;
      emailStr = responseJSON['decodedData']['result']['email']!;
      mobileStr = responseJSON['decodedData']['result']['mobile_number']!;
      String currentRole = responseJSON['decodedData']['result']['current_role']!;
      profileStr =responseJSON['decodedData']['result']['user_role_slugs'][currentRole]??"";
      firstNameStr=responseJSON['decodedData']['result']['first_name']!;
      lastNameStr=responseJSON['decodedData']['result']['last_name']!;

    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }






    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  _submitHelp(BuildContext context) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveContact",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
        "email":emailStr,
        "enquiry_type":"support",
        "first_name":firstNameStr,
        "last_name":lastNameStr,
        "message":helpMessageController.text,
        "phone_no":mobileStr,
        "enquiry_support_type":initialDropDownVal,
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('saveContact', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status'].toString()=='success'){
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.of(context).pop();
    }else{
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }
}