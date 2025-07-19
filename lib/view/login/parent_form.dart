import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/category/add_category_screen.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class ParentFormScreen extends StatefulWidget {
  String fileType;
  Map<String, dynamic> responseJSON;

  ParentFormScreen(this.fileType, this.responseJSON);

  LibraryState createState() => LibraryState();
}

class LibraryState extends State<ParentFormScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  File? selectedFile;
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var zipCodeController = TextEditingController();
  bool validPinCode = false;
  String relationShipID = "";

  List<dynamic> categoryList = [];
  List<String> categoryListAsString = [];
  DateTime? _selectedDate;
  String? selectedCatValue;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.themeColor,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
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
                  text: 'Parent/Guardian  ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: "Consent",
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
        body: Form(
          key: _formKeyLogin,
          child: isLoading
              ? Center(
                  child: Loader(),
                )
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    SizedBox(height: 10),
                    Text(
                        'Because you are under the age of 18, we need consent from your Parent/Guardian',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    SizedBox(height: 15),
                    Text('Your Parent/Guardian First Name*',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                          validator: checkEmptyString,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                          ],
                          controller: firstNameController,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xFFF6F6F6),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 8),
                              hintText: 'First Name',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 13),
                    Text('Your Parent/Guardian Last Name*',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                          validator: checkEmptyString,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                          ],
                          controller: lastNameController,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xFFF6F6F6),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 8),
                              hintText: 'Last Name',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 13),
                    Text('Relationship*',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Container(
                      height: 50,
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
                            'Select relationship',
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
                          onChanged: (value) {
                            setState(() {
                              selectedCatValue = value as String;
                            });
                            String categoryID = '';

                            for (int i = 0; i < categoryList.length; i++) {
                              if (selectedCatValue == categoryList[i]['text']) {
                                relationShipID = categoryList[i]['id'];
                                break;
                              }
                            }
                          },
                          buttonHeight: 40,
                          buttonWidth: 140,
                          itemHeight: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 13),
                    Text('Phone*',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                          validator: phoneValidator,
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),

                            /// here char limit is 5
                          ],
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              errorMaxLines: 2,
                              fillColor: Color(0xFFF6F6F6),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 8),
                              hintText: 'Phone*',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 13),
                    Text('Email*',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                          validator: emailValidator,
                          controller: emailController,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xFFF6F6F6),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 8),
                              hintText: 'Email*',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 13),
                    Text('Zip Code*',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                          validator: checkPincode,
                          controller: zipCodeController,
                          onChanged: (String value) async {
                            if (value.toString().length == 6) {
                              validatePinCode();
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),

                            /// here char limit is 5
                          ],
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xFFF6F6F6),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 8),
                              hintText: 'Zip Code*',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 13),
                    Text('DOB*',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        _pickDateDialog();
                      },
                      child: Container(
                          height: 47,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF6F6F6),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                  _selectedDate == null
                                      ? 'DOB*'
                                      : returnDateInFormat(_selectedDate.toString()),
                                  style: TextStyle(
                                      color: _selectedDate == null
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              Spacer(),
                              Icon(Icons.calendar_month,
                                  color: AppTheme.themeColor),
                              SizedBox(width: 10),
                            ],
                          )),
                    ),
                    SizedBox(height: 34),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                          child: Text('Continue',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
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
                ),
        ));
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Email cannot be left as blank';
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }

  String? checkPincode(String? value) {
    if (value!.isEmpty) {
      return "Pin code is required";
    } else if (!RegExp(r'(^[1-9][0-9]{5}$)').hasMatch(value)) {
      return 'Invalid Pin code';
    } else if (!validPinCode) {
      return 'Invalid Pin code';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Please enter valid Mobile number, it must be of 10 digits and begins with 6, 7, 8 or 9.';
    }
    return null;
  }

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
//2024-01-18 00:00:00.000

      print("Date is " + _selectedDate.toString());
    });
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKeyLogin.currentState!.validate()) {
      return;
    }
    _formKeyLogin.currentState!.save();
    validateValues();
  }

  validateValues() {

    int currentYear=DateTime.now().year;

    if (selectedCatValue == null) {
      Toast.show("Please select a Category ",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    } else if (_selectedDate == null) {
      Toast.show("Please select DOB",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    }

    else if((currentYear-_selectedDate!.year)<18)
      {
        Toast.show("You must be 18 years old.",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }


    else {
      _submitForm();
    }
  }

  _fetchCategoryList(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');



    var data = {
      "method_name": "getMasterDropDown",
      "data": {
        "dropdown_type": "relation",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": "5d498615ee90fb3fb1a59b9e",
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getMasterDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading = false;
    });
    categoryList = responseJSON['decodedData']['result'];
    categoryList.removeAt(0);
    for (int i = 0; i < categoryList.length; i++) {
      categoryListAsString.add(categoryList[i]['text']);
    }
    setState(() {});
    print(responseJSON);
  }

  _submitForm() async {
    APIDialog.showAlertDialog(context, 'Please wait');

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "addGuardian",
      "data": {
        "slug": AppModel.slug,
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "email": emailController.text,
        "mobile_number": phoneController.text,
        "relation": relationShipID,
        "user_type": "student-parent",
        "gender": "male",
        "date_of_birth": returnDateInFormat(_selectedDate.toString()),
        "location": zipCodeController.text.toString(),
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('addGuardian', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      MyUtils.saveSharedPreferences("parent", "");

      if (widget.responseJSON['decodedData']['result']['current_package'] ==
          "") {
        Route route = MaterialPageRoute(builder: (context) => DialogScreen());
        Navigator.pushAndRemoveUntil(
            context, _createRouteDialog(), (Route<dynamic> route) => false);
      } else {
        if (widget.responseJSON['decodedData']['result']
                ['current_category_id'] !=
            null) {
          Route route =
              MaterialPageRoute(builder: (context) => LandingScreen());
          Navigator.pushAndRemoveUntil(
              context, _createRouteLanding(), (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => AddCategoryScreen()));
        }
      }
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  Route _createRouteDialog() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DialogScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteLanding() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LandingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String returnDateInFormat(String date) {
    final dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.d();
    final DateFormat monthFormatter = DateFormat.yM();
    String dayAsString = dayFormatter.format(dateTime);
    String monthString = monthFormatter.format(dateTime);

    String finalString = dayAsString + "/" + monthString;
    print(finalString);
    return finalString;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategoryList(context);
  }

  validatePinCode() async {
    APIDialog.showAlertDialog(context, "Validating Pincode");

    var data = {
      "method_name": "checkPinCode",
      "data": {
        "pin_code": zipCodeController.text.toString(),
        "slug": widget.fileType,
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };

    print(data.toString());

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('checkPinCode', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      validPinCode = true;
      Toast.show("Pincode validated successfully!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      validPinCode = false;
      Toast.show("Invalid Pincode",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  bool isAdult(String birthDateString) {
    String datePattern = "dd-MM-yyyy";

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    return yearDiff > 18 || yearDiff == 18 && monthDiff > 0 || yearDiff == 18 && monthDiff == 0 && dayDiff >= 0;
  }
}
