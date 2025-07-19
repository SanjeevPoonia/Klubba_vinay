import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/login/ForgotChangePassword.dart';
import 'package:klubba/view/category/add_category_screen.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/view/login/parent_form.dart';
import 'package:klubba/view/login/reset_login_screen.dart';
import 'package:klubba/view/login/reset_new_password.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../widgets/custom_clipper.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class LoginOtpVerify extends StatefulWidget {
  final String phone;
  const LoginOtpVerify(this.phone);

  _emailOtpVerify createState() => _emailOtpVerify();
}

class _emailOtpVerify extends State<LoginOtpVerify> {
  bool isObscure = true;
  bool isObscureNew = true;
  String validateString = "";
  var phoneController = TextEditingController();
  bool isLoading = false;
  Timer? _timer;
  int _start = 30;

  String sentOTP = "";
  String validateStr = "";

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
                          padding: EdgeInsets.only(left: 10, right: 10),
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
                                                      fontSize: 18)),
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
                                                        fontSize: 18)),
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
                                          child: const Text('Back',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.blueColor,
                                                  decoration: TextDecoration
                                                      .underline)),
                                          /*Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: AppTheme.themeColor,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
                                          height: 50,
                                          width: 120,
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
                                const SizedBox(height: 25),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: TextFormField(
                                      enabled: false,
                                      validator: emailValidator,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: phoneController,
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
                                        labelText: "Mobile No.",
                                        labelStyle: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
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
                                    child: OtpTextField(
                                      borderRadius: BorderRadius.circular(4),
                                      borderColor:
                                          AppTheme.otpColor.withOpacity(0.5),
                                      fillColor:
                                          AppTheme.otpColor.withOpacity(0.5),
                                      filled: true,
                                      numberOfFields: 4,
                                      focusedBorderColor: AppTheme.blueColor,
                                      //set to true to show as box or false to show as dash
                                      showFieldAsBox: true,
                                      //runs when a code is typed in
                                      onCodeChanged: (String code) {
                                        //handle validation or checks here
                                      },

                                      //runs when every textfield is filled
                                      onSubmit: (String verificationCode) {
                                        _verifyOtp(context, verificationCode);
                                        /*if(verificationCode==sentOTP){

                                        _verifyOtp(context, verificationCode);
                                        //Navigator.pop(context,"1");
                                      }else{
                                        Toast.show("Incorrect OTP!!",
                                            duration: Toast.lengthLong,
                                            gravity: Toast.bottom,
                                            backgroundColor: Colors.red);
                                      }*/
                                        /*setState(() {
                                          // userEnteredOTP = verificationCode;
                                        });*/
                                      }, // end onSubmit
                                    ),
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
                                          sendOTP(context);
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

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email is required and should be valid Email address.';
    }
    return null;
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




  sendOTP(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Sending OTP...');
    var data ={"method_name":"sendOTPforLogin","data":{"mobile_number":widget.phone.toString()}};

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('sendOTPforLogin', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {


      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
      startTimer();





    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _verifyOtp(BuildContext context, String verCode) async {
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var data = {
      "method_name": "loginWithOtp",
      "data": {
        "mobile_number": widget.phone,
        "otp": verCode,
        "remember_me": null,
        "slug": "anuj-singh-1",
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('verifyOTP', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {

      if(responseJSON['decodedData']['result']['is_temp_password']==1)
      {
        Toast.show("Please generate a new password to continue !",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);

        Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetNewPasswordLogin(widget.phone.toString(),responseJSON['decodedData']['result']['slug'],responseJSON['decodedData']['current_role']!=null?responseJSON['decodedData']['current_role']:"",responseJSON)));
      }
      else
      {
        if(responseJSON['decodedData']['result']['current_role']=="5d4d4f960fb681180782e4f4")
        {
          _saveUserDetailAndProceed(responseJSON);
          //  validateUser(responseJSON['decodedData']['result']['_id'],responseJSON);

          // success
        }
        else
        {
          // Unauthorized User
          showAlertDialog(context);
          // _saveUserDetailAndProceed(responseJSON);

        }
      }

    }  else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid user"),
      content: Text("Sorry you are not a valid user"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  _saveUserDetailAndProceed(var responseJSON) async {
    int currentYear=DateTime.now().year;
    AppModel.setHintValue(true);
    MyUtils.saveSharedPreferences(
        'access_token', responseJSON['decodedData']['token']);
    MyUtils.saveSharedPreferences(
        'name',
        responseJSON['decodedData']['result']['first_name'] +
            ' ' +
            responseJSON['decodedData']['result']['last_name']);

    if(responseJSON['decodedData']['profile_image']!=null)
      {
        MyUtils.saveSharedPreferences(
            'profile_image',
            responseJSON['decodedData']['image_url'] +
                responseJSON['decodedData']['result']['profile_image']);
      }
    else
      {
        MyUtils.saveSharedPreferences(
            'profile_image',
            responseJSON['decodedData']['image_url']);
      }

    AppModel.setTokenValue(responseJSON['decodedData']['token']);
    AppModel.setSlugValue(responseJSON['decodedData']['result']['slug']);
    MyUtils.saveSharedPreferences(
        "current_role", responseJSON['decodedData']['result']['current_role']);
    MyUtils.saveSharedPreferences(
        "slug", responseJSON['decodedData']['result']['slug']);
    MyUtils.saveSharedPreferences(
        "_id", responseJSON['decodedData']['result']['_id']);
    MyUtils.saveSharedPreferences(
        "location",
        responseJSON['decodedData']['result']['location_details']['city_name'] +
            ',' +
            responseJSON['decodedData']['result']['location_details']
            ['state_name'] +
            ',' +
            responseJSON['decodedData']['result']['location_details']
            ['country_name']);
    MyUtils.saveSharedPreferences(
        'klubba_id', responseJSON['decodedData']['result']['user_code']);
    MyUtils.saveSharedPreferences('valid_till',
        responseJSON['decodedData']['result']['current_package_expiry']);
    MyUtils.saveSharedPreferences(
        'territory_name',
        responseJSON['decodedData']['result']['location_details']
        ['territory_name']);
    MyUtils.saveSharedPreferences(
        'ro',
        responseJSON['decodedData']['result']['location_details']
        ['regional_office_name']);
    MyUtils.saveSharedPreferences(
        'kiosk_name',
        responseJSON['decodedData']['result']['location_details']
        ['kiosk_name']);
    MyUtils.saveSharedPreferences('current_category_id',
        responseJSON['decodedData']['result']['current_category_id'] ?? '');
    MyUtils.saveSharedPreferences('current_city',
        responseJSON['decodedData']['result']['current_category_id'] ?? '');
    MyUtils.saveSharedPreferences(
        'address',
        responseJSON['decodedData']['result']['location_details']['city_name'] +
            " " +
            responseJSON['decodedData']['result']['location_details']
            ['state_name']);
    MyUtils.saveSharedPreferences('pincode',
        responseJSON['decodedData']['result']['location'].toString());
    MyUtils.saveSharedPreferences(
        'full_name', responseJSON['decodedData']['result']['full_name']);
    MyUtils.saveSharedPreferences(
        'email', responseJSON['decodedData']['result']['email']);
    MyUtils.saveSharedPreferences('mobile_number',
        responseJSON['decodedData']['result']['mobile_number'].toString());

    MyUtils.saveSharedPreferences('current_package',
        responseJSON['decodedData']['result']['current_package']);

    if(responseJSON['decodedData']['result'].toString().contains("is_suscribes_tmp"))
    {
      MyUtils.saveSharedPreferences('tmp',
          "subscribed");
    }
    else
    {
      MyUtils.saveSharedPreferences('tmp',
          "not subscribed");
    }
    DateTime? dob;
    Toast.show(responseJSON['decodedData']['message'],
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.green);
    if(responseJSON['decodedData']['result']['date_of_birth']!=null)
    {
      dob=DateTime.parse(responseJSON['decodedData']['result']['date_of_birth'].toString());
      if(responseJSON['decodedData']['result']['date_of_birth']!=null && (currentYear-dob.year)<18 && !responseJSON.toString().contains("parent_ids"))
      {
        MyUtils.saveSharedPreferences("parent", "adult");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>  ParentFormScreen(responseJSON['decodedData']['result']['slug'],responseJSON)));
      }
      else
      {
        if (responseJSON['decodedData']['result']['current_package'] == "") {
          Route route = MaterialPageRoute(builder: (context) => DialogScreen());
          Navigator.pushAndRemoveUntil(
              context, _createRouteDialog(), (Route<dynamic> route) => false);
        } else {

          if(responseJSON['decodedData']['result']['current_category_id']!=null)
          {
            Route route = MaterialPageRoute(builder: (context) => LandingScreen());
            Navigator.pushAndRemoveUntil(
                context, _createRouteLanding(), (Route<dynamic> route) => false);
          }
          else
          {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => AddCategoryScreen()));
          }
        }
      }



    }
    else
    {
      if (responseJSON['decodedData']['result']['current_package'] == "") {
        Route route = MaterialPageRoute(builder: (context) => DialogScreen());
        Navigator.pushAndRemoveUntil(
            context, _createRouteDialog(), (Route<dynamic> route) => false);
      } else {

        if(responseJSON['decodedData']['result']['current_category_id']!=null)
        {
          Route route = MaterialPageRoute(builder: (context) => LandingScreen());
          Navigator.pushAndRemoveUntil(
              context, _createRouteLanding(), (Route<dynamic> route) => false);
        }
        else
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => AddCategoryScreen()));
        }
      }
    }


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

  @override
  void initState() {
    super.initState();
    phoneController.text=widget.phone.toString();
    startTimer();
  }
}
