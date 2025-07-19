



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/category/add_category_screen.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/view/login/parent_form.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../app_theme.dart';

class ResetNewPasswordLogin extends StatefulWidget{
  final String phoneNumber;
  final String slug,currentRole;
  var responseJSONLogin;
  ResetNewPasswordLogin(this.phoneNumber,this.slug,this.currentRole,this.responseJSONLogin);
  _changePasswordState createState()=>_changePasswordState();
}

class _changePasswordState extends State<ResetNewPasswordLogin>{
  final _formKeyChangePassword = GlobalKey<FormState>();
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool isObscure = true;
  bool isNewObscure = true;
  bool isConfirmObscure = true;

  @override
  Widget build(BuildContext context) {
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
                text: 'Generate ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Password',
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
      body:  Form(
        key: _formKeyChangePassword,
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 15,),
                Center(
                  child:  Lottie.asset('assets/chan_pass_anim.json',
                      width: MediaQuery.of(context).size.width *
                          0.6,
                      height:
                      MediaQuery.of(context).size.height *
                          0.35),
                ),

                SizedBox(height: 15,),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "New Password",
                    style: TextStyle(
                        color: AppTheme.blueColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                    ),
                  ),),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15),
                  color: AppTheme.greyColor,
                  child: TextFormField(
                      validator: checkPasswordValidator,

                      obscureText: isNewObscure,
                      controller: newController,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.all(10),
                        /*    contentPadding:
                                    const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 10.0),*/
                        suffixIcon: IconButton(
                          icon: isNewObscure
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
                            Future.delayed(Duration.zero,
                                    () async {
                                  if (isNewObscure) {
                                    isNewObscure = false;
                                  } else {
                                    isNewObscure = true;
                                  }

                                  setState(() {});
                                });
                          },
                        ),
                        hintText: '******',
                        hintStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      )),
                ),
                SizedBox(height: 15,),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Confirm Password",
                    style: TextStyle(
                        color: AppTheme.blueColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                    ),
                  ),),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15),
                  color: AppTheme.greyColor,
                  child: TextFormField(
                      validator: checkPasswordValidator,

                      obscureText: isConfirmObscure,
                      controller: confirmController,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.all(10),
                        /*    contentPadding:
                                    const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 10.0),*/
                        suffixIcon: IconButton(
                          icon: isConfirmObscure
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
                            Future.delayed(Duration.zero,
                                    () async {
                                  if (isConfirmObscure) {
                                    isConfirmObscure = false;
                                  } else {
                                    isConfirmObscure = true;
                                  }
                                  setState(() {});
                                });
                          },
                        ),
                        hintText: '******',
                        hintStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      )),
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 17),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                          BorderRadius.circular(5)),
                      height: 50,
                      child: const Center(
                        child: Text('Generate Password',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      )),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                  skipPassword();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 17),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color:AppTheme.blueColor,
                          borderRadius:
                          BorderRadius.circular(5)),
                      height: 50,
                      child: const Center(
                        child: Text('Skip',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      )),
                ),

                const SizedBox(height: 18),





              ],
            ),
          ],
        ),
      ),
    );
  }
  String? checkPasswordValidator(String? value) {
    RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.length < 7 && value.length > 17) {
      return 'combination of at-least 1 number,1 Alphabet,1 special character and minimum 8 digits.';
    }else{
      if(!regex.hasMatch(value)){
        return 'combination of at-least 1 number,1 Alphabet,1 special character and minimum 8 digits.';
      }else{
        return null;
      }
    }
  }
  String? checkCurrentPassword(String? value) {
    if (value!.isEmpty) {
      return 'Temp Password cannot be Empty';
    }
    return null;
  }



  bool checkConfirmPasswordValidator() {
    if(newController.text==confirmController.text){
      return true;
    }else{
      return false;
    }

  }

  void _submitHandler(BuildContext context) async {
    if (!_formKeyChangePassword.currentState!.validate()) {
      return;
    }
    _formKeyChangePassword.currentState!.save();
    if(checkConfirmPasswordValidator()){


      _changePassword(context);
    }else{
      Toast.show('New Password and Confirm password not matched!!',
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

  skipPassword(){
    if(widget.responseJSONLogin['decodedData']['result']['current_role']=="5d4d4f960fb681180782e4f4")
    {
      _saveUserDetailAndProceed(widget.responseJSONLogin);
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
  _changePassword(BuildContext context) async{
    APIDialog.showAlertDialog(context, 'Changing Password...');
    var data = {
      "method_name": "changePassword",
      "data": {
        "old_password": widget.phoneNumber+"@123",
        "new_password": newController.text,
        "confirm_password": confirmController.text,
        "slug": widget.slug,
        "current_role": widget.currentRole,
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'changePassword', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if(responseJSON['decodedData']['status']=="error")
    {

      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);


    }
    else
    {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
      if(widget.responseJSONLogin['decodedData']['result']['current_role']=="5d4d4f960fb681180782e4f4")
      {
        _saveUserDetailAndProceed(widget.responseJSONLogin);
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

}