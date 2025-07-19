import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/blank_screen.dart';
import 'package:klubba/view/book_now/book_now_screen.dart';
import 'package:klubba/view/community/community_screen.dart';
import 'package:klubba/view/digital_library/digital_library_screen.dart';
import 'package:klubba/view/home/home_screen.dart';
import 'package:klubba/view/menu/more_ios_screen.dart';
import 'package:klubba/view/menu/more_screen.dart';
import 'package:klubba/view/planner/my_planner_screen.dart';
import 'package:klubba/view/category/select_category_screen.dart';
import 'package:klubba/view/performance_assesment/self_assesment_screen.dart';
import 'package:klubba/widgets/new_bottom.dart';
import 'package:lottie/lottie.dart';

class LandingScreen extends StatefulWidget {
  LandingState createState() => LandingState();
}

class LandingState extends State<LandingScreen> {
  static int _tabIndex = 0;
  String email='';

  int get tabIndex => _tabIndex;

  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);

    fetchUserEmail();


  }




  fetchUserEmail() async {
    email=(await MyUtils.getSharedPreferences("email"))??"";
    setState(() {

    });
    print(email+"hgefy");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // extendBody: true,
        bottomNavigationBar: CircleNavBar(
          height:IphoneHasNotch.hasNotch ? 84 : 64,
          activeIcons: [
            Lottie.asset('assets/home_animation.json'),
            Lottie.asset('assets/community_animation.json'),
            Lottie.asset('assets/planner_animation.json'),
            Lottie.asset('assets/booking_animation.json'),
            Lottie.asset('assets/more_animation.json'),
          ],
          inactiveIcons: [
            Container(
              child: Column(
                children: [
                  Image.asset('assets/bottom1.png', width: 42, height: 42),
                  Text("Home",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w500)),

                  SizedBox(height: 5)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Image.asset('assets/bottom2.png', width: 42, height: 42),
                  Text("Community",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 5)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Image.asset('assets/bottom3.png', width: 42, height: 42),
                  Text("Planner",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w500)),

                  SizedBox(height: 5)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Image.asset('assets/bottom4.png', width: 42, height: 42),
                  Text("Book Now",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w500)),

                  SizedBox(height: 5)
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Image.asset('assets/bottom5.png', width: 42, height: 42),
                  Text("More",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w500)),

                  SizedBox(height: 5)
                ],
              ),
            ),
          ],
          color: Colors.white,
          circleWidth: 60,
          activeIndex: tabIndex,
          onTab: (v) {
            tabIndex = v;
            pageController.jumpToPage(tabIndex);
          },
          /*  cornerRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),*/
          shadowColor: Colors.black.withOpacity(0.5),
          elevation: 4,
        ),
        body: WillPopScope(
          onWillPop: () {

            appExitDialog();
            return Future.value(true);
          },
          child: PageView(
            controller: pageController,
            onPageChanged: (v) {
              tabIndex = v;
            },
            children: [
              HomeScreen2(),
              email=="govindshringi9883@gmail.com"?DigitalLibraryScreen(true,"Views",1,false):
              CommunityScreen(),
              MyPlannerScreen(false),
              BookNowScreen(),
              email=="maheshkumawat075@gmail.com"?
              MoreIOSScreen():
              MoreScreen()
            ],
          ),

        )
    );
  }


  appExitDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600
      )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Exit",style: TextStyle(
        color: AppTheme.blueColor,
        fontWeight: FontWeight.w600
      )),
      onPressed: () {
        Navigator.pop(context);
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Exit App?",style: TextStyle(
          color: AppTheme.blueColor,
          fontWeight: FontWeight.w600
      )),
      content: Text("Are you sure you want to exit Klubba?"),
      actions: [
        cancelButton,
        continueButton,
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

}
