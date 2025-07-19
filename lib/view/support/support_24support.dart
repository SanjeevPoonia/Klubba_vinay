

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';

class SupportSprt extends StatefulWidget{
  _supportSprt createState()=>_supportSprt();
}
class _supportSprt extends State<SupportSprt>{

  Future<void>? _launched;


  _makingPhoneCall(String phone) async {
    var url = Uri.parse("tel:"+phone);
    print(url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
  _makingMail() async{
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@klubba.in',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Support & ',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw Exception("Unable to open the email");
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                text: '24*7 ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Support',
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
      body: Padding(
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Klubba ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Text("Address",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 5,
                  margin: EdgeInsets.only(left: 90),
                  width: 50,
                  color: AppTheme.themeColor,
                  alignment: Alignment.topLeft,
                ),

                const SizedBox(height: 15,),
                Row(
                  children:  const [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.location_on,
                        size: 24,
                        color: AppTheme.blueColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    Flexible(child: Text("F45 Malviya Nagar Industrial Area Okay Plus Spaces Office No. 211, Near Apex Circle, Jaipur",
                        style: TextStyle(
                            color: Colors.black, fontSize: 14)),),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: const Icon(
                        Icons.mail,
                        size: 24,
                        color: AppTheme.blueColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: (){
                        _makingMail();
                      },
                      child:Text("support@klubba.in",
                          style: TextStyle(
                              color: Colors.black, fontSize: 14)) ,
                    )
                    ,
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children:  const [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.phone,
                        size: 24,
                        color:AppTheme.blueColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text("8306662770, 9314023473",
                        style: TextStyle(
                            color: Colors.black, fontSize: 14)),
                  ],
                ),

                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      left: 17, right: 17, top: 5),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      child:Text('Call Now',
                          style:
                          TextStyle(color: Colors.white, fontSize: 15.5)),


                      style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ))),
                      onPressed: () {
                        showCustomDialog(context);
                      }),
                ),

                const SizedBox(height: 20),

              ],
            ),
          ),

    );
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Row(
                  children: [

                    Icon(Icons.call,color: AppTheme.themeColor,),

                    SizedBox(width: 10),

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        _makingPhoneCall("8306662770");

                      },
                      child: Text('8306662770',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),

                  ],
                ),
                    SizedBox(height: 5),

                Row(
                  children: [
                    Icon(Icons.call,color: AppTheme.themeColor,),

                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        _makingPhoneCall("9314023473");
                      },
                      child: Text('9314023473',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),
                  ],
                ),


              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

}