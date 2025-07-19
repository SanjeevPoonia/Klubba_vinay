
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:klubba/view/login/ForgotPassMailSent.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../app_theme.dart';

class ForgotChangePassword extends StatefulWidget{
  final String email;
  final validateStr;

  const ForgotChangePassword(this.email,this.validateStr,{super.key});

  ForgotChangeState createState()=> ForgotChangeState();
}
class ForgotChangeState  extends State<ForgotChangePassword>{
  bool isObscure = true;
  bool isObscureNew = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final _formKeyChangePass = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: AppTheme.neutralTertiarySuperLightColor,
            body: Form(
              key: _formKeyChangePass,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      ClipPath(
                          clipper: OvalBottomBorderClipper(),
                          child: Container(
                            color: Colors.white,
                            child: Column(

                              children: [
                                Center(
                                  child:  Image.asset('assets/ap_ic_dark.png',
                                      width: 114, height: 34),
                                ),
                                Lottie.asset(
                                    'assets/change_pass_ani.json', width: MediaQuery.of(context).size.width*0.6, height: MediaQuery.of(context).size.height * 0.35),
                              ],
                            ),
                          )
                      ),
                      const SizedBox(height: 10),

                      const SizedBox(height: 25),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child:  Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text('Change ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        const Text('Password',
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
                                    Navigator.pushAndRemoveUntil(
                                        context, _createRouteLogin(), (Route<dynamic> route) => false);
                                  },
                                  child: const Text(
                                      'Back',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.blueColor,
                                          decoration: TextDecoration
                                              .underline)), /*Container(
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
                            )

                        ),
                      ),

                      const SizedBox(height: 10),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: const Text('Please Set New Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                      const SizedBox(height: 25),


                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                            validator: checkPasswordValidator,
                            controller: passwordController,
                            obscureText: isObscure,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              errorMaxLines: 2,
                              /*    contentPadding:
                                    const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 10.0),*/
                              suffixIcon: IconButton(
                                icon: isObscure
                                    ? const Icon(
                                  Icons.visibility_off,
                                  size: 20,
                                  color: AppTheme.blueColor,
                                )
                                    : const Icon(
                                  Icons.visibility,
                                  size: 20,
                                  color: AppTheme.blueColor,
                                ),
                                onPressed: () {
                                  Future.delayed(Duration.zero, () async {
                                    if (isObscure) {
                                      isObscure = false;
                                    } else {
                                      isObscure = true;
                                    }

                                    setState(() {});
                                  });
                                },
                              ),
                              labelText: 'New Password',
                              labelStyle: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                            )),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                            validator: checkPasswordValidatorConfirm,
                            obscureText: isObscureNew,
                            controller: confirmpasswordController,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              /*    contentPadding:
                                    const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 10.0),*/
                              suffixIcon: IconButton(
                                icon: isObscureNew
                                    ? const Icon(
                                  Icons.visibility_off,
                                  size: 20,
                                  color: AppTheme.blueColor,
                                )
                                    : const Icon(
                                  Icons.visibility,
                                  size: 20,
                                  color: AppTheme.blueColor,
                                ),
                                onPressed: () {
                                  Future.delayed(Duration.zero, () async {
                                    if (isObscureNew) {
                                      isObscureNew = false;
                                    } else {
                                      isObscureNew = true;
                                    }

                                    setState(() {});
                                  });
                                },
                              ),
                              labelText: 'Re-enter Your New Password',
                              labelStyle: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                            )),
                      ),

                      const SizedBox(height: 40),

                      InkWell(
                        onTap: () {
                          /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const ForgotPassMailSent()));*/
                          _submitHandler(context);
                        },
                        child: Container(
                            margin:
                            const EdgeInsets.symmetric(horizontal: 17),
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



                      const SizedBox(height: 18),
                      const SizedBox(height: 15),

                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
  String? checkPasswordValidatorConfirm(String? value) {
    if (value!.length < 7) {
      return 'Password should have atleast 8 digit';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKeyChangePass.currentState!.validate()) {
      return;
    }
    _formKeyChangePass.currentState!.save();
    validateChangePass();
  }

  void validateChangePass(){
    String pass=passwordController.text;
    String confirmPass=confirmpasswordController.text;
    if(pass==confirmPass){
      _reSetPassword(context);
    }else{
      Toast.show("New password and Confirm password not Matched!!",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }
  String? checkPasswordValidator(String? value) {
    RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.length < 7 && value.length > 17) {
      return 'combination of at-least 1 number, 1 Alphabet , 1 special character And minimum 8 digits .';
    }else{
      if(!regex.hasMatch(value)){
        return 'combination of at-least 1 number, 1 Alphabet , 1 special character And minimum 8 digits .';
      }else{
        return null;
      }
    }
  }
  Route _createRouteLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>   LoginOTPScreen(),
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

  _reSetPassword(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var data = {
      "method_name": "resetPassword",
      "data": {
        "email": widget.email,
        "validate_string":widget.validateStr,
        "slug": "kamal-sanghai",
        "password": passwordController.text,
        "current_role": "5d4d4f960fb681180782e4f4",
        "confirm_password": confirmpasswordController.text,
        "current_category_id": null,
        "action_performed_by": null
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'resetPassword', requestModel, context);
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
    Toast.show(responseJSON['decodedData']['message'],
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.greenAccent);

    Navigator.pushAndRemoveUntil(
        context, _createRouteLogin(), (Route<dynamic> route) => false);


  }

}