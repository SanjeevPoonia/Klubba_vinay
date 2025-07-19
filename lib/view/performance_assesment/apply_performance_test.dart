import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class applyPerformanceTest extends StatefulWidget{
  _applyPerformanceTest createState()=> _applyPerformanceTest();
}
class _applyPerformanceTest extends State<applyPerformanceTest> {
  List<DropdownMenuItem<String>> dropdownItems = [];
  int selectedIndex = 0;
  String initialDropDownVal = "";
  DateTime? _chosenDateTime;
  String _formatedDateTime = "";
  bool _fromTop = true;
  TextEditingController postCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String userFullName = "";
  String categoryName = "";
  String catrgoryId = "";
  String categorySkill = "";
  String cateSkillId = "";
  String performanceFees = "";
  List<dynamic> dropList = [];
  bool validPincode = false;


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop("0"),
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
                  text: 'Apply For ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Performance Test',
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
        body: isLoading ? Center(
          child: Loader(),
        ) : Form(
          key: _formKey,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                child: ListView(
                  children: [
                    const Text('Name',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    Text(userFullName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 15,),
                    const Text('Category',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    Text(categoryName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 15,),
                    const Text('Current Skill level',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    Text(categorySkill,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 15,),
                    const Text('Fees for Application',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    Text(performanceFees,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 15,),
                    const Text("Select Slot",
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 53,
                        decoration: BoxDecoration(
                          color: AppTheme.greyColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: initialDropDownVal,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: dropdownItems,
                            onChanged: (String? value) {
                              setState(() {
                                initialDropDownVal = value!;
                                selectedIndex =
                                    dropdownItems.indexWhere((i) => i.value ==
                                        value);
                                print(initialDropDownVal);
                              });
                            },
                            isExpanded: true,

                          ),
                        )
                    ),
                    const SizedBox(height: 15,),
                    const Text('Select Date',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    GestureDetector(
                      onTap: () {
                        _showSelectDateDialog();
                      },
                      child: Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        color: AppTheme.greyColor,
                        child: Row(
                          children: [
                            Text(
                                _chosenDateTime == null
                                    ? 'Select Date'
                                    : _formatedDateTime, /*"${_chosenDateTime?.year}-${_chosenDateTime?.month}-${_chosenDateTime?.day}",*/
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                )),
                            Spacer(),
                            Icon(Icons.calendar_month_outlined)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    const Text('Post Code',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    TextFormField(
                      controller: postCodeController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          hintText: "Enter Post Code Here",
                          border: InputBorder.none,
                          filled: true,
                          fillColor: AppTheme.greyColor,
                          hintStyle: TextStyle(
                              color: AppTheme.greyColor,
                              fontSize: 15
                          )
                      ),
                      validator: checkPincode,
                      onChanged: (s) {
                        if (s.length == 6) {
                          _fetchPinCodeDetailsCurrent(context, s);
                        }
                      },
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      height: 47,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
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
                          onPressed: () {
                            _submitHandler(context);
                          },
                          child: const Text('Apply',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15))),
                    ),
                  ],
                ),
              )
            ],
          ),
        )


    );
  }

  String? checkPincode(String? value) {
    if (value!.length < 6) {
      return 'Invalid Post Code';
    }
    return null;
  }

  _showSelectDateDialog() {
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                            Text('Date',
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
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: DateTime.now(),
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                            _formatedDateTime = DateFormat('dd/MM/yyyy').format(
                                _chosenDateTime!);
                          });
                        }),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ElevatedButton(
                        child: Text('Save',
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

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _checkValidations();
  }

  _checkValidations() {
    if (initialDropDownVal.isEmpty) {
      Toast.show('Please Select Reason',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (_chosenDateTime == null) {
      Toast.show('Please select Date',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (!validPincode) {
      Toast.show('This Post code not available',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      _submitHelp(context);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchUderDetails(context);
    });
  }

  _fetchUderDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    APIDialog.showAlertDialog(context, "Please Wait...");
    catrgoryId = (await MyUtils.getSharedPreferences("current_category_id"))!;

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


    if (responseJSON['decodedData']['status'] == "success") {
      userFullName = responseJSON['decodedData']['result']['full_name']!;
      List<dynamic> catList = [];
      catList = responseJSON['decodedData']['result']['user_categories'];
      for (int i = 0; i < catList.length; i++) {
        if (catList[i]['id'] == catrgoryId) {
          categoryName = catList[i]['text'];
          categorySkill = catList[i]['stage'];
          cateSkillId = catList[i]['stage_id'];
          break;
        }
      }

      _fetchFeesDetails(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
      isLoading = false;
      setState(() {});
      _finishThePage();
    }
  }

  _fetchFeesDetails(BuildContext context) async {
    catrgoryId = (await MyUtils.getSharedPreferences("current_category_id"))!;
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var data = {
      "method_name": "getAssessmentFees",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by": _id,
        "category": catrgoryId,
        "current_category_id": catrgoryId,
        "current_role": currentRole,
        "learning_stage": cateSkillId,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getAssessmentFees', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'] == "success") {
      performanceFees = responseJSON['decodedData']['result'].toString();
      _fetchDropDown(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
      isLoading = false;
      setState(() {});
      _finishThePage();
    }
  }

  _fetchDropDown(BuildContext context) async {
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    var data = {
      "method_name": "getMasterDropDown",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by": id,
        "current_category_id": catId,
        "current_role": role,
        "dropdown_type": "shifts"
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getMasterDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      dropList.clear();

      dropList = responseJSON['decodedData']['result'];

      for (int i = 0; i < dropList.length; i++) {
        String id = dropList[i]['id'].toString();
        String val = dropList[i]['text'].toString();
        if (i == 0) {
          initialDropDownVal = id;
        }
        var newItem = DropdownMenuItem(value: id, child: Text(val));
        dropdownItems.add(newItem);
      }
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      _finishThePage();
    }
  }

  _finishThePage() {
    Navigator.of(context).pop("0");
  }

  _fetchPinCodeDetailsCurrent(BuildContext context, String pincode) async {
    APIDialog.showAlertDialog(context, 'Checking Pincode...');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "checkPinCode",
      "data": {
        "pin_code": pincode,
        "slug": AppModel.slug,
        "current_role": role,
        "action_performed_by": id,
        "current_category_id": catId,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('checkPinCode', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      validPincode = true;
    }
    else if (responseJSON['decodedData']['message'] ==
        "front.system_this_pincode_not_available") {
      Toast.show("Sorry this Pincode is not available",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      validPincode = false;
    }
    else {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      validPincode = false;
    }
    Navigator.pop(context);
    setState(() {});
  }




  _submitHelp(BuildContext context) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data={
      "method_name":"addPerformanceAssessment",
      "data":{
        "category":catrgoryId,
        "current_skill_level":cateSkillId,
        "applied_skill_level":"5d496c33e67f81784a9ddc3a",
        "zip_code":postCodeController.text,
        "application_fee":performanceFees,
        "preferred_date":_formatedDateTime,
        "preferred_time":initialDropDownVal,
        "user_id":id,
        "product_name":"Performance Assesment",
        "type":"assessment",
        "description":"Performance Assesment to upgrade from Beginner to Intermediate.",
        "slug":AppModel.slug,
        "current_role":role,
        "current_category_id":catId,
        "action_performed_by":id
      }
    };

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('addPerformanceAssessment', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status'].toString()=='success'){
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => CartScreen(false)));
    }else if(responseJSON['decodedData']['message']==''){
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }


}