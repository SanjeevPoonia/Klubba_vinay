
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:klubba/view/login/ForgotChangePassword.dart';
import 'package:klubba/view/login/ForgotPassword.dart';
import 'package:klubba/view/login/login_screen.dart';
import 'package:klubba/widgets/custom_clipper.dart';
import 'package:lottie/lottie.dart';

import '../app_theme.dart';

class ForgotPassMailSent extends StatefulWidget{
  const ForgotPassMailSent({super.key});

  ForgotPassMailState createState()=> ForgotPassMailState();
}
class ForgotPassMailState  extends State<ForgotPassMailSent>{
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: AppTheme.neutralTertiarySuperLightColor,
            body: Stack(
              children: [
                Column(
                  children: [

                    ClipPath(
                        clipper: OnBoardClipper(),
                        child: Container(
                          color: Colors.white,
                          child: Column(

                            children: [
                              Center(
                                child:  Image.asset('assets/ap_ic_dark.png',
                                    width: 114, height: 34),
                              ),
                              Lottie.asset(
                                  'assets/forgot_succ_ani.json', width: MediaQuery.of(context).size.width*0.6, height: MediaQuery.of(context).size.height * 0.35),
                            ],
                          ),
                        )
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Container(
                        color: AppTheme.neutralTertiarySuperLightColor,

                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            height: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Text('Forgot ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 24)),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Text('Password',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 24)),
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
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const ForgotPassword()));
                                          },
                                          child:  Container(
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


                                          ),
                                        ),

                                      ],
                                    )

                                ),
                                const SizedBox(height: 10),
                                const Text('Mail Successfully Shared Please Check Your Email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),


                                const SizedBox(height: 40),

                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const ForgotChangePassword("","")));
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
                                        child: Text('Set New Password',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),



                                const SizedBox(height: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                )
              ],
            ),
          )),
    );
  }

}