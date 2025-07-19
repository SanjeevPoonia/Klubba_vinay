import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:klubba/view/login/ForgotPassMailSent.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:klubba/widgets/custom_clipper.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import 'EmailOtpVerify.dart';
import '../app_theme.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final _formKeyforgot = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String EmailStr = "";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: AppTheme.neutralTertiarySuperLightColor,
        body: Form(
          key: _formKeyforgot,
          child: Stack(
            children: [
              ListView(
                children: [
                  ClipPath(
                      clipper: OnBoardClipper(),
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 45),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.42,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Center(
                                child: Image.asset('assets/ap_ic_dark.png',
                                    width: 114, height: 34),
                              ),
                              SizedBox(
                                  height: 270,
                                  child: OverflowBox(
                                    minHeight: 280,
                                    maxHeight: 280,
                                    child: Lottie.asset(
                                        'assets/forgot_pass_ani.json'),
                                  )),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 18),
                  Container(
                    color: AppTheme.neutralTertiarySuperLightColor,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text('Forgot ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18)),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Text('Password',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18)),
                                            Container(
                                              width: 35,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: AppTheme.themeColor),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                     LoginOTPScreen()));
                                      },
                                      child: const Text('Back',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.blueColor,
                                              decoration:
                                                  TextDecoration.underline)),
                                      /*Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: AppTheme.themeColor,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
                                            height: 40,
                                            width: 150,
                                            child: const Text("Back",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),


                                          ),*/
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 10),
                            const Text('For Recover Your Password.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            const SizedBox(height: 25),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                  controller: emailController,
                                  validator: emailValidator,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    labelText: 'Email/Mobile',
                                    labelStyle: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 40),
                            InkWell(
                              onTap: () {
                                _submitHandler(context);
                                /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const ForgotPassMailSent()));*/
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 50,
                                  child: const Center(
                                    child: Text('Send Me OTP',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  )),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Email or Mobile no. cannot be empty";
    } else if (!isNumeric(value)) {
      if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return 'Enter a valid Email or Mobile no.';
      }
    } else {
      if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value)) {
        return 'Enter a valid Email or Mobile no.';
      }
    }

    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKeyforgot.currentState!.validate()) {
      return;
    }
    _formKeyforgot.currentState!.save();
    //_sendOtpOnMail(context);
    _emailVerify();
  }

  void _emailVerify() {
    EmailStr = emailController.text;
    if (emailController.text.toString().contains("@")) {
      FocusScope.of(context).unfocus();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailOtpVerify(EmailStr, "email")));
    } else {
      FocusScope.of(context).unfocus();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailOtpVerify(EmailStr, "mobile")));
    }
  }

  _sendOtpOnMail(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var data = {
      "method_name": "forgotPassword",
      "data": {
        "forget_email_mobile_password": emailController.text,
        "type": "email",
        "slug": "kamal-sanghai",
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('forgotPassword', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      _sendUserToVerify(responseJSON);
      // success

    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _sendUserToVerify(var responseJSON) async {
    String otp = responseJSON['decodedData']['otp_code'];
    String type = responseJSON['decodedData']['type'];
    String email_mobile_data = responseJSON['decodedData']['email_mobile_data'];
    String validate_string = responseJSON['decodedData']['validate_string'];
    String message = responseJSON['decodedData']['validate_string'];
    Toast.show(responseJSON['decodedData']['message'],
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.greenAccent);
  }

  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Enter a valid Mobile Number';
    }
    return null;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
