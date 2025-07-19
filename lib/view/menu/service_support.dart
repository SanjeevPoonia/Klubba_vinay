
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/support/support_24support.dart';
import 'package:klubba/view/support/support_faq.dart';
import 'package:klubba/view/support/support_lookinghelp.dart';
import 'package:klubba/view/support/support_other.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';

class ServiceSupport extends StatefulWidget{
  _serviceSupport createState()=>_serviceSupport();
}
class _serviceSupport extends State<ServiceSupport>{
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
           text: const TextSpan(
             style: TextStyle(
               fontSize: 13,
               color: Color(0xFF1A1A1A),
             ),
             children: <TextSpan>[
               TextSpan(
                 text: 'Service ',
                 style: TextStyle(fontSize: 16, color: Colors.black),
               ),
               TextSpan(
                 text: 'Support',
                 style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: Colors.black),
               ),
             ],
           ),
         ),
         centerTitle: true,
       ),
       body: ListView(
         children: [
           SizedBox(height: 15,),
           Center(
             child:  Lottie.asset('assets/support_anim.json',
                 width: MediaQuery.of(context).size.width *
                     0.6,
                 height:
                 MediaQuery.of(context).size.height *
                     0.35),
           ),
           SizedBox(height: 20),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8),
             child: Row(
               children: [
                 Expanded(
                     child: InkWell(
                       child: Card(
                         color: Color(0xFFF3F3F3),
                         elevation: 3,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(4)),
                         child: Container(
                           child: Column(
                             children: [
                               SizedBox(height: 25),
                               Image.asset('assets/support_help.png',
                                   width: 45, height: 45),
                               SizedBox(height: 10),
                               Text('Looking for help?',
                                   style: TextStyle(
                                       fontSize: 13,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w600)),
                               SizedBox(height: 25),
                             ],
                           ),
                         ),
                       ),
                       onTap: ()=>{
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     SupportLokingHelp()))
                       },
                     ),
                     flex: 1),
                 const SizedBox(width: 16),
                 Expanded(
                     flex: 1,
                     child:InkWell(
                       onTap: ()=>{
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     SupportSprt()))
                       },
                       child: Card(
                         color: Color(0xFFF3F3F3),
                         elevation: 3,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(4)),
                         child: Container(
                           child: Column(
                             children: [
                               SizedBox(height: 25),
                               Image.asset('assets/support_sprt.png',
                                   width: 45, height: 45),
                               SizedBox(height: 10),
                               Text('24*7 Support',
                                   style: TextStyle(
                                       fontSize: 13,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w600)),
                               SizedBox(height: 25),
                             ],
                           ),
                         ),
                       ),

                     )),
               ],
             ),
           ),
           const SizedBox(height: 15),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8),
             child: Row(
               children: [
                 Expanded(
                     child: InkWell(
                       onTap: (){
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     SupportOther()));
                       },
                       child: Card(
                         color: Color(0xFFF3F3F3),
                         elevation: 3,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(4)),
                         child: Container(
                           child: Column(
                             children: [
                               SizedBox(height: 25),
                               Image.asset('assets/support_others.png',
                                   width: 45, height: 45),
                               SizedBox(height: 10),
                               Text('Other Question',
                                   style: TextStyle(
                                       fontSize: 13,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w600)),
                               SizedBox(height: 25),
                             ],
                           ),
                         ),
                       ),
                     ),
                     flex: 1),
                 const SizedBox(width: 16),
                 Expanded(
                     child: InkWell(
                       child: Card(
                         color: Color(0xFFF3F3F3),
                         elevation: 3,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(4)),
                         child: Container(
                           child: Column(
                             children: [
                               SizedBox(height: 25),
                               Image.asset('assets/support_faq.png',
                                   width: 45, height: 45),
                               SizedBox(height: 10),
                               Text('FAQ',
                                   style: TextStyle(
                                       fontSize: 13,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w600)),
                               SizedBox(height: 25),
                             ],
                           ),
                         ),
                       ),
                       onTap: (){
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     supportFaq()));
                       },
                     ),
                     flex: 1),
               ],
             ),
           ),

           const SizedBox(height: 15),
          /* Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8),
             child: Row(
               children: [
                 Expanded(
                     child: InkWell(
                       onTap: (){

                         whatsapp();

                       },
                       child: Card(
                         color: Color(0xFFF3F3F3),
                         elevation: 3,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(4)),
                         child: Container(
                           child: Column(
                             children: [
                               SizedBox(height: 25),
                               Image.asset('assets/whatsapp_ic.png',
                                   width: 45, height: 45),
                               SizedBox(height: 10),
                               Text('Chat Now',
                                   style: TextStyle(
                                       fontSize: 13,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w600)),
                               SizedBox(height: 25),
                             ],
                           ),
                         ),
                       ),
                     ),
                     flex: 1),
                 const SizedBox(width: 16),
                 Expanded(
                     child: Container(),
                     flex: 1),
               ],
             ),
           ),

           const SizedBox(height: 15),*/

         ],
       )

   );
  }
  whatsapp() async{
    var contact = "+91 90247 75873";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hello";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hello')}";

    try{
      if(Platform.isIOS){
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception{

    }
  }
}