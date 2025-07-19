import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:klubba/view/login/ForgotChangePassword.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../widgets/custom_clipper.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class EmailOtpVerify extends StatefulWidget{
  final String email;
  final String type;
  const EmailOtpVerify(
  this.email,
      this.type,
  {super.key}
  );
  _emailOtpVerify createState()=>_emailOtpVerify();
}
class _emailOtpVerify extends State<EmailOtpVerify>{
  bool isObscure = true;
  bool isObscureNew = true;
  String validateString="";
  var phoneController=TextEditingController();
  bool isLoading = false;
  Timer? _timer;
  int _start = 30;

  String sentOTP="";
  String validateStr="";


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: AppTheme.neutralTertiarySuperLightColor,
            body: isLoading?

            Center(
              child: Loader(),
            ):Stack(
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
                                child:  Image.asset('assets/ap_ic_dark.png',
                                    width: 114, height: 34),
                              ),
                              Lottie.asset(
                                  'assets/otp_animation.json', width: MediaQuery.of(context).size.width*0.6, height: MediaQuery.of(context).size.height * 0.35),
                            ],
                          ),
                        )
                    ),
                    const SizedBox(height: 18),
                    Container(
                      color: AppTheme.neutralTertiarySuperLightColor,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Text('Email ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18)),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text('Verify',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 18)),
                                              Container(
                                                width: 35,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: AppTheme.themeColor),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context,"0");
                                        },
                                        child: const Text(
                                            'Back',
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
                                  )

                              ),
                              const SizedBox(height: 25),


                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                      suffixIcon:widget.type=="email"? Icon(Icons.mail_outline_outlined,color: AppTheme.blueColor):Icon(Icons.phone_android,color: AppTheme.blueColor),
                                      labelText: widget.type=="email"?"Email":"Mobile No.",
                                      labelStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    )),

                              ),

                              const SizedBox( height: 10,),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child: GestureDetector(
                                  onTap:()=>{
                                    Navigator.pop(context,"0")
                                  } ,
                                  child: Text(
                                    'Change Email or Mobile',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: AppTheme
                                            .blueColor,
                                        decoration:
                                        TextDecoration
                                            .underline),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),




                              const SizedBox(height: 30),
                              Container(
                                margin: const EdgeInsets
                                    .symmetric(
                                    horizontal: 20),
                                height: 55,
                                child: Center(
                                  child: OtpTextField(
                                    borderRadius: BorderRadius.circular(4),
                                    borderColor:AppTheme.otpColor.withOpacity(0.5),
                                    fillColor: AppTheme.otpColor.withOpacity(0.5),
                                    filled: true,
                                    numberOfFields: 4,
                                    focusedBorderColor:
                                    AppTheme.blueColor,
                                    //set to true to show as box or false to show as dash
                                    showFieldAsBox: true,
                                    //runs when a code is typed in
                                    onCodeChanged:
                                        (String code) {
                                      //handle validation or checks here
                                    },

                                    //runs when every textfield is filled
                                    onSubmit: (String
                                    verificationCode) {
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
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child:  Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 13,
                                        color:
                                        Color(0xFF1A1A1A),
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text:
                                            'Resend OTP in '),
                                        TextSpan(
                                          text: _start<10?
                                          '00:0'+_start.toString():

                                          '00:'+_start.toString()


                                          ,
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
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Didn\'t receive the OTP ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.bold,
                                        color:
                                        Color(0xFF1A1A1A),
                                      )),

                                  GestureDetector(
                                    onTap: (){
                                      if(_start==0)
                                      {
                                        _reSendOtpOnMail(context);
                                      }

                                    },
                                    child: Text('Resend',
                                        style: TextStyle(
                                          fontSize: 15,
                                          decoration:
                                          TextDecoration
                                              .underline,
                                          fontWeight:
                                          FontWeight.bold,
                                          color:

                                          _start==0?
                                          AppTheme
                                              .blueColor:Colors.grey,
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
    _start=30;
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
  _reSendOtpOnMail(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var data = {
      "method_name": "resendUserOTP",
      "data": {
        "email_mobile_data": phoneController.text,
        "is_from_type": "forgot_password_form",
        "slug": "kamal-sanghai",
        "validate_string":validateStr,
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    print(data.toString());

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'resendUserOTP', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    startTimer();
    if (responseJSON['decodedData']['status'] == 'success') {
      _sendUserToVerify(responseJSON);
      // success

    }
    else
      {
        Toast.show(responseJSON['decodedData']['message'],
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    setState(() {

    });
  }
  _sendUserToVerify(var responseJSON) async {

    sentOTP=responseJSON['decodedData']['otp_code'].toString();
    //String type=responseJSON['decodedData']['type'];
    String email_mobile_data=responseJSON['decodedData']['email_mobile_data'];
    validateStr=responseJSON['decodedData']['validate_string'];
    String message=responseJSON['decodedData']['message'];
    Toast.show(responseJSON['decodedData']['message'],
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.greenAccent);


  }
  _sendOtpOnMail(BuildContext context,String type) async {
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var data = {
      "method_name": "forgotPassword",
      "data": {
        "forget_email_mobile_password": widget.email,
        "type": widget.type,
        "slug": "kamal-sanghai",
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    print("API Params "+data.toString());

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'forgotPassword', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    phoneController.text=widget.email;
    startTimer();
    if (responseJSON['decodedData']['status'] == 'success') {


      if(widget.type=="mobile"){
        Toast.show(responseJSON['decodedData']['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        _sendUserToVerify(responseJSON);

      }
      else
        {
          _sendUserToVerify(responseJSON);
        }



      // success
    }


    else {

      if(widget.type=="mobile")
        {
          Toast.show("Sorry no account found with this mobile no. !!",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          Navigator.pop(context);
        }
      else
        {
          Toast.show("Sorry no account found with this email !!",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          Navigator.pop(context);
        }


    }

    setState(() {
      isLoading=false;
    });
  }


  _verifyOtp(BuildContext context,String verCode) async {
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var data = {
      "method_name": "verifyOTP",
      "data": {
        "forget_email_mobile_password": widget.email,
        "type":widget.type,
        "otp":verCode,
        "otpvalue_one": verCode[0],
        "otpvalue_two": verCode[1],
        "otpvalue_three": verCode[2],
        "otpvalue_four": verCode[3],
        "is_from_type":null,
        "slug": "kamal-sanghai",
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null,
        "validate_string":validateStr,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'verifyOTP', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      _sendUserToChangePass(responseJSON);
      // success
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }

  _sendUserToChangePass(var responseJSON) async {
    Toast.show(responseJSON['decodedData']['message'],
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.greenAccent);
    String validateStr=responseJSON['decodedData']['validate_string'];
    Navigator.pushAndRemoveUntil(
        context, _createRouteChangePass(validateStr), (Route<dynamic> route) => false);
  }
  Route _createRouteChangePass(String validateStr) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  ForgotChangePassword(widget.email,validateStr),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
    Future.delayed(const Duration(milliseconds: 0), () {
      _sendOtpOnMail(context,widget.type);
    });
  }
}
