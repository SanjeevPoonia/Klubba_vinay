

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/heading_text_widget.dart';

class CurrentWeekScreen extends StatefulWidget
{
  SelfState createState()=>SelfState();
}
class SelfState extends State<CurrentWeekScreen>
{
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
                text: 'Current ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Week',
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

      body: Column(
        children: [
          SizedBox(height:5),
          HeadingTextWidget('Weekly ', 'Performance Assessment'),
          SizedBox(height:15),
          Container(
            height: 78,
            margin: EdgeInsets.only(left: 12),
            child: ListView.builder(
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int pos) {
                  return Row(
                    children: [
                      InkWell(
                        child: Container(
                          width: 49,
                          height: 77,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: /*pos == currentDateSelectedIndex
                                  ? Colors.black
                                  :*/ AppTheme.themeColor),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Image.asset('assets/smiley_ic.png',
                                  width: 21.93, height: 21.93),
                              Text('0' + (pos + 1).toString(),
                                  style: TextStyle(
                                      color:/* pos == currentDateSelectedIndex
                                          ? Colors.white
                                          :*/ Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17)),
                              Text('Mon',
                                  style: TextStyle(
                                      color: /*pos == currentDateSelectedIndex
                                          ? Colors.white
                                          :*/ Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        onTap: () {

                        },
                      ),
                      SizedBox(width: 8),
                    ],
                  );
                }),
          ),
          SizedBox(height: 35),

          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(
                horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(4),
                color:
                const Color(0xFFF3F3F3)),
            child: Row(
              children: [
                Container(
                  color:  Colors
                      .orange,
                  width: 5,
                  height: 70,
                ),
                SizedBox(width: 5),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text('Attributes',
                                    style: TextStyle(
                                        color: AppTheme
                                            .blueColor,
                                        fontWeight: FontWeight
                                            .w600,
                                        fontSize:
                                        12)),
                                Text(
                                    'Bowling, Batting, Fielding, Introduction',
                                    style: TextStyle(
                                        color: Colors
                                            .black,
                                        fontWeight: FontWeight
                                            .w500,
                                        fontSize:
                                        12)),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            transform: Matrix4
                                .translationValues(
                                8.0,
                                -25.0,
                                0.0),
                            width: 85,
                            height: 30,
                            decoration: BoxDecoration(
                                color: AppTheme
                                    .themeColor,
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    4)),
                            child: Center(
                              child: Text(
                                  'Week 03',
                                  style: TextStyle(
                                      color: Colors
                                          .black,
                                      fontWeight:
                                      FontWeight
                                          .w600,
                                      fontSize:
                                      12.5)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),

                      Container(
                        height: 41,
                        decoration: BoxDecoration(
                            color: AppTheme.blueColor,
                            borderRadius: BorderRadius.circular(3)
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 6),
                            Text('Total Marks : 40',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight
                                        .w600,
                                    fontSize:
                                    12)),

                            SizedBox(width: 15),

                            Text('Marks Obtained : 28',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight
                                        .w600,
                                    fontSize:
                                    12)),

                            Spacer(),

                            InkWell(
                              onTap: (){
                                _assessmentBottomSheet();
                              },
                              child: Container(
                                width: 30,
                                height: 31,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3)
                                ),
                                child: Center(
                                  child: Icon(Icons.arrow_forward_ios_rounded,color: AppTheme.blueColor,size: 15),
                                ),
                              ),
                            ),


                            SizedBox(width: 5)

                          ],
                        ),
                      ),

                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height:18),
          HeadingTextWidget('Current ', 'Week'),
          SizedBox(height:15),

          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(
                horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(4),
                color:
                const Color(0xFFF3F3F3)),
            child: Row(
              children: [

                SizedBox(width: 5),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text('Attributes',
                                    style: TextStyle(
                                        color: AppTheme
                                            .blueColor,
                                        fontWeight: FontWeight
                                            .w600,
                                        fontSize:
                                        12)),
                                Text(
                                    'Bowling, Batting, Fielding, Introduction',
                                    style: TextStyle(
                                        color: Colors
                                            .black,
                                        fontWeight: FontWeight
                                            .w500,
                                        fontSize:
                                        12)),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),

                          Container(
                            height: 65,
                            width:65,
                            decoration: BoxDecoration(
                                color: AppTheme.blueColor,
                                shape: BoxShape.circle
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Week',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight
                                            .w600,
                                        fontSize:
                                        12)),

                                Text('04',
                                    style: TextStyle(
                                        color: AppTheme
                                            .themeColor,
                                        fontWeight: FontWeight
                                            .bold,
                                        fontSize:
                                        14)),


                              ],
                            ),
                          ),



                          SizedBox(width: 15)



                        ],
                      ),
                      SizedBox(height: 13),

                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 42,
                        child: ElevatedButton(
                            child: Text('Fill Details',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.5)),
                            style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.black),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.black),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ))),
                            onPressed: () => null),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),


          SizedBox(height: 20),

          Container(

            padding: EdgeInsets.symmetric(vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: AppTheme.blueColor,
                borderRadius: BorderRadius.circular(3)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 6),
                    Text('Total Marks All Weeks :',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight
                                .w600,
                            fontSize:
                            12)),

                    Spacer(),

                    Text('2080',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight
                                .w600,
                            fontSize:
                            13)),
                    SizedBox(width: 20)

                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    SizedBox(width: 6),
                    Text('Total Marks Obtained All Weeks :',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight
                                .w600,
                            fontSize:
                            12)),

                    Spacer(),

                    Text('76',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight
                                .w600,
                            fontSize:
                            13)),
                    SizedBox(width: 20)

                  ],
                ),
              ],
            ),
          ),

        ],
      ),

    );
  }
  _assessmentBottomSheet() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, dialogState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Card(
                margin: EdgeInsets.zero,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                            width: 80, height: 3, color: Color(0xFFAAAAAA)),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
                              child: Center(
                                child: Icon(Icons.close_sharp,
                                    color: Colors.white, size: 13.5),
                              ),
                            ),
                          ),
                          SizedBox(width: 15)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Week ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('03',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                        fontSize: 16)),
                                SizedBox(height: 3),
                                Container(
                                  width: 38,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: AppTheme.themeColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 10),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                          child:  Row(
                            children: [
                              Expanded(child:  Row(
                                children: [
                                  Text('Bowling',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          13)),

                                  SizedBox(width:25),

                                  Text('07',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          14)),

                                ],
                              ),flex: 1),

                              Expanded(child:  Row(

                                children: [
                                  Text('Fielding',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          13)),
                                  SizedBox(width:35),
                                  Text('07',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          14)),

                                ],
                              ),flex: 1,)



                            ],
                          )

                      ),

                      SizedBox(height: 15),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                          child:  Row(
                            children: [
                              Expanded(child:  Row(
                                children: [
                                  Text('Batting',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          13)),

                                  SizedBox(width:25),

                                  Text('07',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          14)),

                                ],
                              ),flex: 1),

                              Expanded(child:  Row(

                                children: [
                                  Text('Introduction',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          13)),
                                  SizedBox(width:35),
                                  Text('07',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight
                                              .w600,
                                          fontSize:
                                          14)),

                                ],
                              ),flex: 1,)



                            ],
                          )

                      ),
                      SizedBox(height: 22),

                      Container(
                        height: 41,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: AppTheme.blueColor,
                            borderRadius: BorderRadius.circular(3)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('Total Marks : 40',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight
                                        .w600,
                                    fontSize:
                                    12)),



                            Text('Marks Obtained : 28',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight
                                        .w600,
                                    fontSize:
                                    12)),



                          ],
                        ),
                      ),

                      SizedBox(height: 22),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            child: Text('Back',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.5)),
                            style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.black),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.black),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ))),
                            onPressed: () => null),
                      ),

                      SizedBox(height: 25)


                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, false ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
}