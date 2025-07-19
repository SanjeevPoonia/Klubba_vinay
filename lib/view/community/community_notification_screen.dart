import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';

class CommunityNotifications extends StatefulWidget {
  CommunityState createState() => CommunityState();
}

class CommunityState extends State<CommunityNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/cross_black.png", width: 20, height: 20),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Notification',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Expanded(
              child: ListView.builder(
                  itemCount: 13,
                  itemBuilder: (BuildContext context, int pos) {
                    return Column(
                      children: [
                        Container(
                            width: double.infinity,
                            color: pos > 3
                                ? Colors.white
                                : Color(0xFF2098E9).withOpacity(0.24),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/profile_dummy.jpg"),
                                    radius: 20,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Jaipur Sports Academy',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                        Spacer(),
                                        Text('09:24 PM',
                                            style: TextStyle(
                                                color: Color(0xFF161F3D)
                                                    .withOpacity(0.50),
                                                fontSize: 9)),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Text('Commented on your post',
                                        style: TextStyle(
                                            color: Color(0xFF161F3D)
                                                .withOpacity(0.37),
                                            fontSize: 9)),
                                    SizedBox(height: 5),
                                    Text(
                                        'simply dummy text of the printing and typesetting industry.',
                                        style: TextStyle(
                                            color: Color(0xFF161F3D)
                                                .withOpacity(0.80),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11)),
                                  ],
                                ))
                              ],
                            )),
                        SizedBox(height: 3)
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}
