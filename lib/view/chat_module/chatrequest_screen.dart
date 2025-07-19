import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';

class chatRequestScreen extends StatefulWidget{
  _chatRequestScreen createState()=>_chatRequestScreen();
}
class _chatRequestScreen extends State<chatRequestScreen>{
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
                text: 'Chat ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Request',
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
      backgroundColor: Colors.white,
      body: Padding(padding: EdgeInsets.all(5),
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: 5,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int pos) {
              return Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 6),
                        child: Row(
                          children: [
                            // assets/dummy_profile.png
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage: AssetImage(
                                      "assets/dummy_profile.png"),
                                ),
                                Positioned(
                                    right: 2,
                                    bottom: 2,
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF06D451),
                                      ),
                                    )
                                )
                              ],
                            ),

                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text("Michael Bruno",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily:
                                            "Poppins",
                                            color: AppTheme
                                                .blueColor,
                                            fontWeight:
                                            FontWeight
                                                .w500)),
                                    Text("Hi, Michael see you after work?",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: "Poppins",
                                          color:
                                          Color(0xFFB1B1B1),
                                        )),
                                  ],
                                )),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("12:00",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                        "Poppins",
                                        color: Color(0xFFB1B1B1),
                                        fontWeight:
                                        FontWeight
                                            .w500)),

                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.themeColor,
                                    shape: BoxShape.circle,

                                  ),
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                    child: Text("3",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.w500 ),),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: AppTheme.greyColor,
                    height: 07,
                  ),
                  SizedBox(height: 5),
                ],
              );
            }),
      ),
    );
  }
  
}