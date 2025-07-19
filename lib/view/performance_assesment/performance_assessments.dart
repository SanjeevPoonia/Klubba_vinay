
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/performance_assesment/new_coach_assesment_screen.dart';
import 'package:klubba/view/performance_assesment/new_self_assesment_screen.dart';
import 'package:klubba/view/performance_assesment/performaceTest.dart';
import 'package:lottie/lottie.dart';

import '../app_theme.dart';

class performanceAssessment extends StatefulWidget{
  _performanceAssessment createState()=>_performanceAssessment();
}
class _performanceAssessment extends State<performanceAssessment>{
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
                  text: 'Performance ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Assessment',
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
        body: Column(
          children: [
            const SizedBox(height: 15,),
            Center(
              child:  Lottie.asset('assets/perform_ass_anim.json',
                  width: MediaQuery.of(context).size.width *
                      0.6,
                  height:
                  MediaQuery.of(context).size.height *
                      0.35),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Card(
                          color: const Color(0xFFF3F3F3),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Container(
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Image.asset('assets/ic_perform_test.png',
                                    width: 45, height: 45),
                                const SizedBox(height: 10),
                                const Text('Performance Test',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                        onTap: ()=>{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      performanceTest()))
                        },
                      )),
                  const SizedBox(width: 16),
                  Expanded(
                      flex: 1,
                      child:InkWell(
                        onTap: ()=>{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewSelfAssesmentScreen()))
                        },
                        child: Card(
                          color: Color(0xFFF3F3F3),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Container(
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Image.asset('assets/ic_perform_self.png',
                                    width: 45, height: 45),
                                const SizedBox(height: 10),
                                const Text('Self Assessment',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 25),
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
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewCoachAssesmentScreen()));
                        },
                        child: Card(
                          color: Color(0xFFF3F3F3),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Container(
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Image.asset('assets/ic_perform_coach.png',
                                    width: 45, height: 45),
                                const SizedBox(height: 10),
                                const Text('Coach Assessment',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(width: 16),
                  Expanded(
                      flex: 1,
                      child: Container()),
                ],
              ),
            ),
          ],
        )

    );
  }

}