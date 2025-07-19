import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/view/menu/addon_packages.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:klubba/view/chat_module/mychat_screen.dart';
import 'package:klubba/view/digital_library/digital_library_screen.dart';
import 'package:klubba/view/book_now/my_booking_screen.dart';
import 'package:klubba/view/menu/my_packages_screen.dart';
import 'package:klubba/view/my_profile/my_profile_screen.dart';
import 'package:klubba/view/menu/my_review.dart';
import 'package:klubba/view/notification/notification_screen.dart';
import 'package:klubba/view/performance_assesment/performance_assessments.dart';
import 'package:klubba/view/refer/refer_and_earn_screen.dart';
import 'package:klubba/view/performance_assesment/self_assesment_screen.dart';
import 'package:klubba/view/menu/service_support.dart';
import 'package:klubba/view/menu/suggestion.dart';
import 'package:klubba/view/payment/transaction_history_screen.dart';

class MoreScreen extends StatefulWidget {
  MoreState createState() => MoreState();
}

class MoreState extends State<MoreScreen> {
  List<String> menuName = [
    'Digital Library',
    'Review',
    'Support',
    'Suggestion',
    'Add On Package',
    'My Packages',
    'My Transactions',
    'Chat',
    'Performance Assessment',
    'Refer & Earn',
    'My Bookings',
    'My Profile',
  ];
  List<String> menuIcons = [
    'assets/menu1.png',
    'assets/menu2.png',
    'assets/menu3.png',
    'assets/menu4.png',
    'assets/menu5.png',
    'assets/menu6.png',
    'assets/menu7.png',
    'assets/menu8.png',
    'assets/menu9.png',
    'assets/menu11.png',
    'assets/menu12.png',
    'assets/profile_ic2.png',
  ];
  String email='';
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
                    fontFamily: "Poppins",
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
              }
              else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyReview()));
              }
              else if (index == 2) {
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
              }
              else if (index == 4) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addOnPackages()));
              }
              else if (index == 5) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPackagesScreen()));
              }
              else if (index == 6) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionsScreen()));

              }

              else if (index == 7) {
                if(email=="govindshringi9883@gmail.com")
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServiceSupport()));
                  }
                else
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => myChatScreen()));
                  }


              }
              else if (index == 8) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => performanceAssessment()));

              }
             /* else if(index==8)
              {

                Navigator.push(context, MaterialPageRoute(builder: (context)=>SelfAssesmentScreen()));

              }*/
              else if(index==9)
              {

                Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferAndEarnScreen()));

              }
              else if(index==10)
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBookingScreen()));
                }
              else if(index==11)
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfileScreen()));
                }
            },
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  index==11?
                  Image.asset(menuIcons[11], width: 45, height: 45,color:Color(0xFFFFCE15).withOpacity(0.5)):
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

  fetchUserEmail() async {
    email=(await MyUtils.getSharedPreferences("email"))??"";
    setState(() {

    });
    print(email+"hgefy");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserEmail();
  }
}
