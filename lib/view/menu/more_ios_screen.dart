import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/menu/addon_packages_ios.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:klubba/view/digital_library/digital_library_screen.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:klubba/view/book_now/my_booking_screen.dart';
import 'package:klubba/view/menu/my_packages_screen.dart';
import 'package:klubba/view/menu/my_review.dart';
import 'package:klubba/view/notification/notification_screen.dart';
import 'package:klubba/view/performance_assesment/performance_assessments.dart';
import 'package:klubba/view/refer/refer_and_earn_screen.dart';
import 'package:klubba/view/performance_assesment/self_assesment_screen.dart';
import 'package:klubba/view/menu/service_support.dart';
import 'package:klubba/view/menu/suggestion.dart';
import 'package:klubba/view/payment/transaction_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class MoreIOSScreen extends StatefulWidget {
  MoreState createState() => MoreState();
}

class MoreState extends State<MoreIOSScreen> {
  List<String> menuName = [
    'Digital Library',
    'Review',
    'Support',
    'Suggestion',
    'Add On Package',
    'My Packages',
    'My Transactions',
    'Performance Assessment',
    'Refer & Earn',
    'My Bookings',
    'Delete Account',
  ];
  List<String> menuIcons = [
    'assets/menu1.png',
    'assets/menu2.png',
    'assets/menu3.png',
    'assets/menu4.png',
    'assets/menu5.png',
    'assets/menu6.png',
    'assets/menu7.png',
    'assets/menu9.png',
    'assets/menu11.png',
    'assets/menu12.png',
    'assets/delete_ios.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.themeColor,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));
            },
            child: Padding(
                padding: EdgeInsets.only(right: 13),
                child: Icon(Icons.notifications, color: Colors.black, size: 27)),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartScreen(false)));
            },
            child: Padding(
                padding: EdgeInsets.only(right: 13),
                child: Icon(Icons.shopping_cart, color: Colors.black, size: 27)),
          ),
        ],
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'More',
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
      body: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            crossAxisCount: 3,
            childAspectRatio: (2 / 2)),
        itemCount: menuName.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DigitalLibraryScreen(false,"View",1,false)));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyReview()));
              }else if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ServiceSupport()));
              }
              else if (index == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Suggestion()));
              }else if (index == 4) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addOnPackagesIOS()));
              }
              else if (index == 5) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPackagesScreen()));
              } else if (index == 6) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionsScreen()));


              } else if (index == 7) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => performanceAssessment()));

              }
              else if(index==8)
              {

                Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferAndEarnScreen()));

              }
              else if(index==9)
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBookingScreen()));
                }

              else if(index==10)
              {
                accountDeleteDialog();
              }
            },
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Image.asset(menuIcons[index], width: 45, height: 45),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(menuName[index],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          // Item rendering
        },
      ),
    );
  }

  accountDeleteDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete",style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),),
      onPressed: () {
        Navigator.pop(context);
        deleteAccount();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account?"),
      content: Text("Deleting your account will delete your access and all your information on Klubba?"),
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

  deleteAccount() async {
    APIDialog.showAlertDialog(context, "Deleting account...");
    var data = {
      "method_name": "deleteUser",
      "data": {
        "slug": AppModel.slug,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('deleteUser', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    Toast.show("Account Deleted successfully!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.greenAccent);
    _logOut();

  }
  _logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginOTPScreen()),
            (Route<dynamic> route) => false);
  }

}
