import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class SupportLokingHelp extends StatefulWidget{
  _supportHelp createState()=>_supportHelp();
}
class _supportHelp extends State<SupportLokingHelp>{
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
  bool _fromTop = true;

  TextEditingController helpMessageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();


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
                text: 'Looking For ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Help',
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
            child: ListView(
              children: [
                Text("Name",
                style: TextStyle(
                  color: AppTheme.blueColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: "Enter Name",
                        hintStyle: TextStyle(
                            color: AppTheme.hintColor,
                            fontSize: 15
                        ),
                        border: InputBorder.none
                    ),
                    validator: nameValidator,

                  ),
                ),
                SizedBox(height: 15,),
                Text("Profile",
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(profileStr,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: AppTheme.hintColor
                    ),),
                ),
                SizedBox(height: 15,),
                Text("Mobile",
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: mobileController,
                    decoration: const InputDecoration(
                        hintText: "Enter Mobile",
                        hintStyle: TextStyle(
                            color: AppTheme.hintColor,
                            fontSize: 15
                        ),
                        border: InputBorder.none
                    ),
                    validator: phoneValidator,

                  ),
                ),
                SizedBox(height: 15,),
                Text("Email",
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,

                    decoration: const InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(
                            color: AppTheme.hintColor,
                            fontSize: 15
                        ),
                        border: InputBorder.none
                    ),
                    validator: emailValidator,

                  )
                ),
                SizedBox(height: 15,),
                Text("Reason",
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
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
                ),
                SizedBox(height: 15,),
                Text("Message",
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
                SizedBox(height: 20,),
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
                        child: Text('Send Message',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      )),
                )
              ],
            ),
          )
      ),
    );
  }
  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Please enter valid mobile number, it must be of 10 digits and begins with 6, 7, 8 or 9.';
    }
    return null;
  }
  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }
  String? reViewValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Details!';
    }
    return null;
  }
  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Name!';
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
      Toast.show('Please Select Reason',
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

      nameController.text=nameStr;
      mobileController.text=mobileStr;
      emailController.text=emailStr;

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
        "email":emailController.text,
        "enquiry_type":"contact_us",
        "first_name":nameController.text,
        "last_name":lastNameStr,
        "message":helpMessageController.text,
        "phone_no":mobileController.text,
        "subject":initialDropDownVal,
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('saveContact', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status'].toString()=='success'){
      Navigator.of(context).pop();
      _showSuccessDialog(responseJSON['decodedData']['message']);
    }else{
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }
  _finishThePage(){
    Navigator.of(context).pop();
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
                          _finishThePage();
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
                          _finishThePage();
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