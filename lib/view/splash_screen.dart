

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/view/category/add_category_screen.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:klubba/view/walkthrough/walkthrough_first.dart';

class SplashScreen extends StatefulWidget
{
  final String token;
  SplashScreen(this.token);
  SplashState createState()=>SplashState();
}
class SplashState extends State<SplashScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/ap_ic_dark.png",width: MediaQuery.of(context).size.width*0.5),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  _navigateUser() async {
    if(widget.token!='')
    {

      String? currentPackage=await MyUtils.getSharedPreferences("current_package");
      String? currentcatId=await MyUtils.getSharedPreferences("current_category_id");
      if(currentPackage=="")
      {
        //change
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DialogScreen())));
      }

      else if(currentcatId=='' || currentcatId==null)
        {
          Timer(
              Duration(seconds: 2),
                  () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => AddCategoryScreen())));
        }
      else
      {
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LandingScreen())));
      }


    }
    else
    {
      Timer(
          Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => walkthrough_first())));
    }
  }
}
