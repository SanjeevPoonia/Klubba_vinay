import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/view/category/add_category_screen.dart';

import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/view/login/parent_form.dart';
import 'package:klubba/view/login/register_user.dart';
import 'package:klubba/view/login/reset_new_password.dart';
import 'package:klubba/widgets/custom_clipper.dart';
import 'package:toast/toast.dart';
import '../../utils/app_modal.dart';
import '../../widgets/textfield_widget.dart';
import 'ForgotPassword.dart';
import '../home/home_screen.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert' show utf8, base64;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  TextEditingController loginController = TextEditingController();
  String userTypeLearner="5d4d4f960fb681180782e4f4";
  bool flag = true;
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  bool termsChecked = false;
  final _formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: AppTheme.bgColor,
              body: Form(
                key: _formKeyLogin,
                child: Stack(
                  children: [
                    ListView(
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
                                  Lottie.asset('assets/ani_login.json',
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35),
                                ],
                              ),
                            )),
                        const SizedBox(height: 25),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text(
                                        "Login",
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
                                      Navigator.of(context)
                                          .push(_createRouteRegister());
                                      /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const RegisterUser()));*/
                                    },
                                    child: const Text('Register',
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
                                        borderRadius:
                                        BorderRadius.only(
                                            topLeft: Radius
                                                .circular(25),
                                            bottomLeft:
                                            Radius.circular(
                                                25))),
                                    height: 40,
                                    width: 150,
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ),*/
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text('Please Login to your account.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ))),
                        const SizedBox(height: 25),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: /*TextFieldShow(
                              labeltext: 'Email or Mobile',
                              validator: checkEmptyString,
                              controller: loginController,
                              fieldIC: const Icon(Icons.mail,
                                  size: 20,
                                  color: AppTheme.themeColor),
                              suffixIc: const Icon(
                                Icons.mail,
                                size: 20,
                              ),
                            ),*/
                                  Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                    validator: emailValidator,
                                    /*                     onChanged: (content) {
                                      if (content.length != 0) {
                                        bool isPhone = isNumeric(content);
                                        if (isPhone) {
                                          if (flag &&
                                              !loginController.text
                                                  .toString()
                                                  .contains("+91")) {
                                            loginController.text =
                                                '+91' + content;
                                            loginController.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset: loginController
                                                            .text.length));
                                            flag = false;
                                          }
                                        } else {
                                          loginController.text = content
                                              .toString()
                                              .replaceAll("+91", "");
                                          loginController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: loginController
                                                          .text.length));
                                          flag = true;
                                        }
                                        setState(() {});
                                      }
                                    },*/
                                    controller: loginController,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        labelText: 'Email or Mobile',
                                        labelStyle: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.7),
                                        ))),
                              )),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                                validator: checkPasswordValidator,
                                obscureText: isObscure,
                                controller: passwordController,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
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
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              GestureDetector(
                                onTap: () {
                                Navigator.pop(context);
                                },
                                child:  Text('Login with OTP',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.blueColor,
                                        decoration: TextDecoration.underline)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(_createRouteForgot());
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ForgotPassword()));*/
                                },
                                child: const Text('Forgot Password?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.blueColor,
                                        decoration: TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        InkWell(
                          onTap: () {
                            _submitHandler(context);
                            /*Route route = MaterialPageRoute(builder: (context) => DialogScreen());
                                        Navigator.pushAndRemoveUntil(
                                            context, route, (Route<dynamic> route) => false);*/
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
                                child: Text('Login',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              )),
                        ),
                        const SizedBox(height: 15),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  String? checkPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKeyLogin.currentState!.validate()) {
      return;
    }
    _formKeyLogin.currentState!.save();
    loginUser(context);
  }

  loginUser(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Logging in...');
    var data = {
      "method_name": "login",
      "data": {
        "email": loginController.text,
        "password": passwordController.text,
        "remember_me": null,
        "slug": "kamal-sanghai",
        "current_role": "5d4d4f7f0fb681180782e4f1",
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('login', requestModel, context);
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

         Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetNewPassword(passwordController.text.toString(),responseJSON['decodedData']['result']['slug'],responseJSON['decodedData']['current_role']!=null?responseJSON['decodedData']['current_role']:"")));
       }
     else
       {
         if(responseJSON['decodedData']['result']['current_role']==userTypeLearner)
         {
           _saveUserDetailAndProceed(responseJSON);
           //  validateUser(responseJSON['decodedData']['result']['_id'],responseJSON);

           // success
         }
         else
         {
           // Unauthorized User
          // showAlertDialog(context);
           _saveUserDetailAndProceed(responseJSON);

         }
       }

    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
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

  validateUser(String userID,Map<String,dynamic> loginData) async {
    APIDialog.showAlertDialog(context, 'Validating user...');
    var data = {
      "method_name": "saveLoginInfo",
      "data": {
        "user_id": userID,
        "mode": "login",
        "slug": "",
        "current_role": "",
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saveLoginInfo', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    print(DateTime.now().toString());

    if (responseJSON['decodedData']['result'] == 1) {
      _saveUserDetailAndProceed(loginData);
      // success

    } else {
      Toast.show("You are already logged in a different device !!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

/*  String? phoneValidator(String? value) {
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10}$)').hasMatch(value!)) {
      return 'Enter a valid Mobile Number';
    }
    return null;
  }*/

  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Enter a valid Mobile Number';
    }
    return null;
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
  bool isAdult(String birthDateString) {
    String datePattern = "dd-MM-yyyy";

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    return yearDiff > 18 || yearDiff == 18 && monthDiff > 0 || yearDiff == 18 && monthDiff == 0 && dayDiff >= 0;
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

  Route _createRouteRegister() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RegisterUser(),
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

  Route _createRouteForgot() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ForgotPassword(),
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
