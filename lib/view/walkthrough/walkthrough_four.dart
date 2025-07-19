import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:klubba/view/walkthrough/walkthrough_second.dart';
import 'package:klubba/widgets/custom_clipper.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class walkthrough_four extends StatefulWidget{

  walkthrough_state createState()=>walkthrough_state();

}
class walkthrough_state extends State<walkthrough_four>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Color(0xFFEFF1FA),
     body: Column(

       children: <Widget>[
         ClipPath(
           clipper: OnBoardClipper(

           ),
           child: Container(
             padding: EdgeInsets.only(top: 45),
             width: MediaQuery.of(context).size.width,
             color: AppTheme.primarySwatch.shade50,
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 30),
               child:   Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                       width: MediaQuery.of(context).size.width * 0.8,
                       decoration: const BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(25)),
                         color: Colors.white,
                       ),
                       alignment: Alignment.center,
                       child: Column(
                         children: <Widget>[
                           SizedBox(height: 20),

                           Image.asset('assets/ap_ic_dark.png',
                               width: 114, height: 34),
                           // Image.asset('assets/app_icon_dark.png',width: 114,height: 34,),
                           Lottie.asset(
                               'assets/walk_pre_comp.json', width: MediaQuery.of(context).size.width*0.6, height: MediaQuery.of(context).size.height * 0.3),

                         ],
                       ),
                     ),
             ),
           ),
         ),


         Expanded(
           child: Container(
             color: Color(0xFFEFF1FA),
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child:  Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children:  <Widget>[
                   Container(
                     width: MediaQuery.of(context).size.width,
                     alignment: Alignment.centerRight,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         Container(
                           height: 7,
                           width: 7,
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(25)),
                             color: Colors.grey,
                           ),
                         ),
                         const SizedBox(width: 5,),
                         Container(
                           height: 7,
                           width: 7,
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(25)),
                             color: Colors.grey,
                           ),
                         ),
                         const SizedBox(width: 5,),
                         Container(
                           height: 7,
                           width: 7,
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(25)),
                             color: Colors.grey,
                           ),
                         ),
                         const SizedBox(width: 5,),
                         Container(
                           height: 10,
                           width: 20,
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(25)),
                             color: AppTheme.themeColor,
                           ),
                         )
                       ],
                     ),
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Row(
                         children: [
                           const Padding(
                             padding: EdgeInsets.only(left: 20),
                             child: Text("Available ",
                               style: TextStyle(
                                   fontSize: 23,
                                   color: Colors.black,
                                   fontWeight: FontWeight.w500
                               ),),
                           ),
                           Text("Sports",
                             style: TextStyle(
                                 fontSize: 23,
                                 color: Colors.black,
                                 fontWeight: FontWeight.bold
                             ),
                           ),
                         ],
                       ),
                       Container(
                         height: 5,
                         width: 40,
                         margin: const EdgeInsets.only(left: 125),
                         color: AppTheme.themeColor,
                         alignment: Alignment.topLeft,
                       ),

                     ],
                   ),


                   const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Klubba is the 1st Indian app with all sports. All sports are available like cricket, boxing, basket ball, badminton, tennis, volleyball or yoga with your mobile and start playing right now!",
                       style: TextStyle(
                           fontSize: 13,
                           color: Colors.black,
                           fontWeight: FontWeight.w500
                       ),
                   ),
                    ),
                   const SizedBox(height: 60,),
                   Container(
                     alignment: Alignment.center,
                     width: MediaQuery.of(context).size.width,
                     child: GestureDetector(
                       onTap: (){
                         Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: LoginOTPScreen()));
                       },
                       child: Image.asset(
                         'assets/ic_walk_fourth.png',
                         width: 55, height: 55,
                       ),
                     ),
                   ),
                   Spacer(),
                   Container(
                     alignment: Alignment.centerRight,
                     width: MediaQuery.of(context).size.width,
                     child:  Padding(
                       padding: EdgeInsets.only(right: 10.0),
                       child: GestureDetector(
                         onTap: (){
                           Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: LoginOTPScreen()));

                         },
                         child: const Text("Skip >>",
                           style: TextStyle(
                               fontSize: 15,
                               color: AppTheme.blueColor,
                               fontWeight: FontWeight.w600
                           ),
                         ),
                       ),
                     ),
                   )


                 ],
               ),
             ),
           ),
         )

       ],
     ),
   );
  }


}
