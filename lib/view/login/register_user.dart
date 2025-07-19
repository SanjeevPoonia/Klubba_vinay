import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/otp_verify_screen.dart';
import 'package:klubba/widgets/custom_clipper.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import '../../utils/app_modal.dart';
import '../../widgets/textfield_widget.dart';
import 'dart:convert' show base64, json, utf8;

import '../app_theme.dart';


class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterUser> {
  Duration initialtimer = new Duration();
  bool validPinCode=false;
  String dobValidation = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  bool isObscure = true;
  bool termsChecked = false;
  bool _fromTop = true;
  String _date = "Not set";
  DateTime? _chosenDateTime;
  String _formatedDateTime = "";
  String _gender = "Gender*";
  int selectedGenderIndex = 0;
  final _formKey = GlobalKey<FormState>();

  String mobileNumber = "";
  String isVerified = "0";

  @override
  Widget build(BuildContext context) {
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom - 40;
    ToastContext().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.neutralTertiarySuperLightColor,
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              ClipPath(
                  clipper: OnBoardClipper(),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Image.asset('assets/ap_ic_dark.png',
                              width: 114, height: 34),
                        ),
                        Lottie.asset('assets/register_ani.json',
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.35),
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 5,
                                    width: 30,
                                    color: AppTheme.themeColor,
                                    alignment: Alignment.topLeft,
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Login',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.blueColor,
                                        decoration: TextDecoration.underline)),
                                /*Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: AppTheme.themeColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  bottomLeft:
                                                  Radius.circular(25))),
                                          height: 40,
                                          width: 150,
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),*/
                              ),
                            ],
                          )),
                      const SizedBox(height: 10),
                      const Text('Create an account Free and Enjoy it.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldShow(
                  labeltext: 'First Name*',
                  controller: firstNameController,
                  validator: checkEmptyString,
                  fieldIC: const Icon(Icons.mail,
                      size: 20, color: AppTheme.themeColor),
                  suffixIc: const Icon(
                    Icons.mail,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldShow(
                  labeltext: 'Last Name*',
                  controller: lastNameController,
                  validator: checkEmptyLastName,
                  fieldIC: const Icon(Icons.mail,
                      size: 20, color: AppTheme.themeColor),
                  suffixIc: const Icon(
                    Icons.mail,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldRegister22(
                        labeltext: 'Mobile Number*',
                        maxLength: 10,
                        validator: phoneValidator,
                        controller: phoneController,
                        fieldIC: const Icon(Icons.mail,
                            size: 20, color: AppTheme.themeColor),
                        suffixIc: const Icon(
                          Icons.mail,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldEmail(
                  labeltext: 'Email',
                  controller: emailController,
                  validator: emailValidator,
                  fieldIC: const Icon(Icons.mail,
                      size: 20, color: AppTheme.themeColor),
                  suffixIc: const Icon(
                    Icons.mail,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _showCategoryDialog();
                },
                child: Container(
                  color: AppTheme.neutralTertiarySuperLightColor,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 48,
                  child: Row(
                    children: [
                      Text(_chosenDateTime == null ? 'DOB' : _formatedDateTime,
                          /*"${_chosenDateTime?.year}-${_chosenDateTime?.month}-${_chosenDateTime?.day}",*/
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          )),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 15),
              ),
            /*  dobValidation != ''
                  ? Padding(
                      padding: EdgeInsets.only(top: 5, left: 15),
                      child: Text('Date of Birth is required',
                          style:
                              TextStyle(fontSize: 12, color: Colors.red[700]!)),
                    )
                  : Container(),*/
              SizedBox(height: 13),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text('Select gender*',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 12, right: 10),
                child: Row(
                  children: [
                    selectedGenderIndex == 0
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGenderIndex = 0;
                              });
                            },
                            child: Icon(Icons.radio_button_checked_rounded,
                                color: AppTheme.themeColor))
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGenderIndex = 0;
                              });
                            },
                            child: Icon(Icons.radio_button_off)),
                    SizedBox(width: 5),
                    Text('Male',
                        style: TextStyle(fontSize: 12, color: Colors.black)),
                    SizedBox(width: 5),
                    selectedGenderIndex == 1
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGenderIndex = 1;
                              });
                            },
                            child: Icon(Icons.radio_button_checked_rounded,
                                color: AppTheme.themeColor))
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGenderIndex = 1;
                              });
                            },
                            child: Icon(Icons.radio_button_off)),
                    SizedBox(width: 5),
                    Text('Female',
                        style: TextStyle(fontSize: 12, color: Colors.black)),

                    SizedBox(width: 5),
                    selectedGenderIndex == 2
                        ? GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGenderIndex = 2;
                          });
                        },
                        child: Icon(Icons.radio_button_checked_rounded,
                            color: AppTheme.themeColor))
                        : GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGenderIndex = 2;
                          });
                        },
                        child: Icon(Icons.radio_button_off)),
                    SizedBox(width: 5),
                    Text('Third Gender',
                        style: TextStyle(fontSize: 12, color: Colors.black)),


                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 15),
              ),
              SizedBox(height: 7),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child:

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                      validator: checkPincode,
                      onChanged: (String value) async {

                        if(value.toString().length==6)
                          {
                            validatePinCode();
                          }

                      },
                      keyboardType: TextInputType.number,
                      controller: pinController,
                      maxLength: 6,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
                          //prefixIcon: fieldIC,

                          labelText: 'Pin Code*',
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ))),
                )





              /*  TextFieldPincode(
                  labeltext: 'Pin Code*',
                  maxLength: 6,
                  onChanged: (String value) async {
                   validatePinCode();
                  },
                  controller: pinController,
                  validator: checkPincode,
                  fieldIC: const Icon(Icons.mail,
                      size: 20, color: AppTheme.themeColor),
                  suffixIc: const Icon(
                    Icons.mail,
                    size: 20,
                  ),
                ),*/
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  _submitHandler(context);
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 17),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                    height: 50,
                    child: const Center(
                      child: Text('Submit',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    )),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      )),
    );
  }

  String? emailValidator(String? value) {

    if(value!.isEmpty)
      {

      }

    else if (
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'First Name cannot be Empty';
    }
    return null;
  }

  String? checkEmptyLastName(String? value) {
    if (value!.isEmpty) {
      return 'Last Name cannot be Empty';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    validateValues();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    validateGender();
  }

  validateGender() {
    if (_chosenDateTime == null) {
      dobValidation = 'Error';
    } else {
      dobValidation = '';
    }
    setState(() {});

    _checkValidations();
  }

  validateValues() {
    if (_chosenDateTime == null) {
      dobValidation = 'Error';
    } else {
      dobValidation = '';
    }
    setState(() {});
  }

  _checkValidations() {
    _sendOtp();
  }

  _sendOtp() async {
    APIDialog.showAlertDialog(context, "Sending OTP...");

   var data;


   if(emailController.text!="")
     {
       data = {
         "method_name": "resendUserOTP",
         "data": {
           "email":emailController.text,
           "email_mobile_data": phoneController.text,
           "type": "mobile",
           "is_from_type": "register",
           "validate_string": "",
           "slug": "",
           "current_role": "5d4d4f960fb681180782e4f4",
           "current_category_id": null,
           "action_performed_by": null
         }
       };

     }
   else
     {
       data = {
         "method_name": "resendUserOTP",
         "data": {

           "email_mobile_data": phoneController.text,
           "type": "mobile",
           "is_from_type": "register",
           "validate_string": "",
           "slug": "",
           "current_role": "5d4d4f960fb681180782e4f4",
           "current_category_id": null,
           "action_performed_by": null
         }
       };
     }


    print(data.toString());

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('resendUserOTP', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerify(
                  phoneController.text,
                  firstNameController.text,
                  lastNameController.text,
                  pinController.text.toString(),
                  _formatedDateTime,
                  emailController.text,
                  selectedGenderIndex,
                  responseJSON['decodedData']['otp'].toString())));
      ;
    } else {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  validatePinCode() async {
    APIDialog.showAlertDialog(context, "Validating Pincode");

    var data = {
      "method_name": "checkPinCode",
      "data": {
        "pin_code": pinController.text.toString(),
        "slug":
            "testingsjzbzidbjdhdjdnsjsksnksbshshsbs-bsjbdudbdbdudndhdvdjdhxbbsjsbshsbsbshsbshsbshsbsbs",
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
      validPinCode=true;
      Toast.show("Pincode validated successfully!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      validPinCode=false;
      Toast.show("Invalid Pincode",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password should have atleast 6 digit';
    }
    return null;
  }

  String? checkPincode(String? value) {
    if (value!.isEmpty) {
      return "Pin code is required";
    } else if (!RegExp(r'(^[1-9][0-9]{5}$)').hasMatch(value)) {
      return 'Invalid Pin code';
    }
    else if(!validPinCode)
      {
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

  _showCategoryDialog() {
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
                            Text('DOB',
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
                        minimumYear: 1970,
                        maximumYear: DateTime.now().year-4,
                        initialDateTime: DateTime(DateTime.now().year-4, DateTime.now().month,DateTime.now().day),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                            _formatedDateTime = DateFormat('yyyy-MM-dd')
                                .format(_chosenDateTime!);
                          });
                        }),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
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
          position: Tween(begin: Offset(0, false ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  _showGenderDialog() {
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
                              Text('Your Gender',
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
                    Column(
                      children: [
                        RadioListTile(
                            title: Text("Male"),
                            value: "Male",
                            groupValue: _gender,
                            onChanged: (value) {
                              dialogState(() {});
                              setState(() {
                                _gender = value.toString();
                              });
                            }),
                        RadioListTile(
                            title: Text("Female"),
                            value: "Female",
                            groupValue: _gender,
                            onChanged: (value) {
                              dialogState(() {});
                              setState(() {
                                _gender = value.toString();
                              });
                            }),
                        RadioListTile(
                            title: Text("Third Gender"),
                            value: "Third Gender",
                            groupValue: _gender,
                            onChanged: (value) {
                              dialogState(() {});
                              setState(() {
                                _gender = value.toString();
                              });
                            })
                      ],
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
                            if (_gender != 'Gender*') {
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
          position:
              Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                  .animate(anim1),
          child: child,
        );
      },
    );
  }
}
