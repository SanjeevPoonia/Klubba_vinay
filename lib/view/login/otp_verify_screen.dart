import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:klubba/widgets/custom_clipper.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../network/api_helper.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpVerify extends StatefulWidget {
  final String mobileNumber, firstName, lastName, pinCode, selectedDate, email;
  final int genderIndex;
  final String otp;

  OtpVerify(this.mobileNumber, this.firstName, this.lastName, this.pinCode,
      this.selectedDate, this.email, this.genderIndex, this.otp);

  OtpVerifyState createState() => OtpVerifyState();
}

class OtpVerifyState extends State<OtpVerify> {
  bool isObscure = true;
  bool isObscureNew = true;
  var phoneController = TextEditingController();
  bool isLoading = false;
  String otpReceived="";
  String sentOTP = "";
  Timer? _timer;
  String _commingSms = 'Unknown';
  int _start = 30;
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: AppTheme.neutralTertiarySuperLightColor,
        body: isLoading
            ? Center(
                child: Loader(),
              )
            : Stack(
                children: [
                  ListView(
                    children: [
                      ClipPath(
                          clipper: OnBoardClipper(),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                SizedBox(height: 25),
                                Center(
                                  child: Image.asset('assets/ap_ic_dark.png',
                                      width: 114, height: 34),
                                ),
                                Lottie.asset('assets/otp_animation.json',
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.35),
                              ],
                            ),
                          )),
                      const SizedBox(height: 18),
                      Container(
                        color: AppTheme.neutralTertiarySuperLightColor,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text('Mobile ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 22)),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Text('Verify',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 22)),
                                                Container(
                                                  width: 35,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      color:
                                                          AppTheme.themeColor),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context, "0");
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: AppTheme.themeColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25))),
                                            height: 50,
                                            width: 120,
                                            child: const Text(
                                              "Back",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 25),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: TextFormField(
                                      enabled: false,
                                      validator: checkPasswordValidator,
                                      keyboardType: TextInputType.number,
                                      controller: phoneController,
                                      maxLength: 12,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        /*    contentPadding:
                                    const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 10.0),*/
                                        suffixIcon: Icon(Icons.phone_android,
                                            color: AppTheme.blueColor),
                                        labelText: 'Mobile Number*',
                                        labelStyle: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () => {Navigator.pop(context, "0")},
                                    child: Text(
                                      'Change Mobile Number',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.blueColor,
                                          decoration: TextDecoration.underline),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  height: 55,
                                  child: Center(
                                    child: OTPTextField(
                                        otpFieldStyle: OtpFieldStyle(
                                          backgroundColor: AppTheme.otpColor
                                              .withOpacity(0.5),
                                          borderColor: AppTheme.otpColor
                                              .withOpacity(0.5),
                                        ),
                                        controller: otpController,
                                        length: 4,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        // textFieldAlignment: MainAxisAlignment.spaceAround,
                                        fieldWidth: 45,
                                        spaceBetween: 2,
                                        fieldStyle: FieldStyle.box,
                                        outlineBorderRadius: 4,
                                        style: TextStyle(fontSize: 17),
                                        onChanged: (pin) {
                                          print("Changed: " + pin);
                                        },
                                        onCompleted: (pin) {
                                          print("Completed: " + pin);
                                          FocusScope.of(context).unfocus();
                                          if (pin.toString() == otpReceived) {
                                            Toast.show(
                                                "Otp Verified successfully !!",
                                                duration: Toast.lengthLong,
                                                gravity: Toast.bottom,
                                                backgroundColor: Colors.green);

                                            registerUser(context);
                                          } else {
                                            Toast.show(
                                                "Please enter valid OTP !!",
                                                duration: Toast.lengthLong,
                                                gravity: Toast.bottom,
                                                backgroundColor: Colors.red);
                                          }
                                        }),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                        children: <TextSpan>[
                                          const TextSpan(
                                              text: 'Resend OTP in '),
                                          TextSpan(
                                            text: _start < 10
                                                ? '00:0' + _start.toString()
                                                : '00:' + _start.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsScreen2()));
                                              },
                                          ),
                                          const TextSpan(text: ' seconds '),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Didn\'t receive the OTP ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A1A1A),
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        if (_start == 0) {
                                          _sendOtp(context);
                                        }
                                      },
                                      child: Text('Resend',
                                          style: TextStyle(
                                            fontSize: 15,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                            color: _start == 0
                                                ? AppTheme.blueColor
                                                : Colors.grey,
                                          )),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
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
      )),
    );
  }

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password should have atleast 6 digit';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.mobileNumber;
    otpReceived=widget.otp;
    startTimer();
  }

  _sendOtp(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    /* var data = {
      "method_name": "verifyMobileNo",
      "data": {
        "emailMobileData": widget.mobileNumber
      }
    };*/

    var data = {
      "method_name": "resendUserOTP",
      "data": {
        "email_mobile_data": widget.mobileNumber,
        "type": "mobile",
        "is_from_type": "register",
        "validate_string": "",
        "slug": "",
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('resendUserOTP', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'] == 'success') {
      otpReceived = responseJSON['decodedData']['otp'].toString();
      startTimer();
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      phoneController.text = widget.mobileNumber;
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    isLoading = false;
    setState(() {});
  }

  verifyOtp(BuildContext context, String code) async {
    APIDialog.showAlertDialog(context, "Verifying OTP...");

    /* var data = {
      "method_name": "verifyMobileNo",
      "data": {
        "emailMobileData": widget.mobileNumber
      }
    };*/

    var data = {
      "method_name": "verifyOTP",
      "data": {
        "otpvalue_one": code[0],
        "otpvalue_two": code[1],
        "otpvalue_three": code[2],
        "otpvalue_four": code[3],
        "validate_string": "",
        "is_from_type": "register",
        "otp": code,
        "slug": "",
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('verifyOTP', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show("Otp Verified successfully !!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      registerUser(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    isLoading = false;
    setState(() {});
  }


  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  registerUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    //phoneController.text=phoneController.text.toString().replaceAll("+91", "");
    APIDialog.showAlertDialog(context, 'Registering account...');
    var data = {
      "method_name": "userRegistration",
      "data": {
        "signup_role": "learner",
        "first_name": widget.firstName,
        "last_name": widget.lastName,
        "email": widget.email,
        "mobile_number": widget.mobileNumber,
        "location": widget.pinCode,
        "date_of_birth": widget.selectedDate,
        "terms": true,
        "newsletter": "",
        "gender": widget.genderIndex == 0 ? "Male" : widget.genderIndex==1?"Female":"Third Gender",
        "user_type": "learner",
        "slug": "",
        "current_role": "",
        "current_category_id": null,
        "action_performed_by": null
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('userRegistration', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Route route = MaterialPageRoute(builder: (context) => LoginOTPScreen());
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
      // success
    } else {
      if (responseJSON['decodedData']['errors'].toString().contains("email")) {
        Toast.show(responseJSON['decodedData']['errors']["email"][0],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      } else if (responseJSON['decodedData']['errors']
          .toString()
          .contains("mobile_number")) {
        Toast.show(responseJSON['decodedData']['errors']['mobile_number'][0],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      } else {
        Toast.show(responseJSON['decodedData']['errors'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }
  }

}
