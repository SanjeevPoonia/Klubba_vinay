import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';

class RecommendedScreen extends StatefulWidget {
  RecommendedState createState() => RecommendedState();
}

class RecommendedState extends State<RecommendedScreen> {
  int selectedIndex = 0;
  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
                text: 'My ',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Recommendations',
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
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedIndex == 0
                                ? AppTheme.themeColor
                                : Color(0xFFF3F3F3)),
                        child: Center(
                          child: Text('All',
                              style: TextStyle(
                                  color: selectedIndex == 0
                                      ? Colors.black
                                      : Color(0xFF9A9CB8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),
                        ),
                      ),
                    ),
                    flex: 1),
                SizedBox(width: 7),
                Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedIndex == 1
                                ? AppTheme.greenColor
                                : Color(0xFFF3F3F3)),
                        child: Center(
                          child: Text('Successful',
                              style: TextStyle(
                                  color: selectedIndex == 1
                                      ? Colors.black
                                      : Color(0xFF9A9CB8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),
                        ),
                      ),
                    ),
                    flex: 1),
                SizedBox(width: 7),
                Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: selectedIndex == 2
                                ? Color(0xFfED2F59)
                                : Color(0xFFF3F3F3)),
                        child: Center(
                          child: Text('Pending',
                              style: TextStyle(
                                  color: selectedIndex == 2
                                      ? Colors.black
                                      : Color(0xFF9A9CB8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),
                        ),
                      ),
                    ),
                    flex: 1),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 46,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Color(0xFFE7E7E7)),
                color: const Color(0xFFF6F6F6)),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 8),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                )),
          ),
          const SizedBox(height: 12),
          Expanded(
              child: selectedIndex == 0
                  ? ListView.builder(
                      itemCount: 5,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (BuildContext context, int pos) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                        children: [
                                      Text('Swati Singh',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13)),
                                      SizedBox(height: 5),
                                      pos % 2 == 0
                                          ? Text('You Earned 200 Kandy',
                                              style: TextStyle(
                                                  color: AppTheme.greenColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13))
                                          : Text('Not Yet Accept Your Request',
                                              style: TextStyle(
                                                  color: Color(0xFFED2F59),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13)),
                                    ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start)),
                                pos % 2 == 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text('Member',
                                            style: TextStyle(
                                                color: AppTheme.greenColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13)),
                                      )
                                    : Container(
                                        height: 35,
                                        width: 85,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: AppTheme.themeColor),
                                        child: Center(
                                          child: Text('Remind',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13)),
                                        ),
                                        margin: EdgeInsets.only(right: 5),
                                      )
                              ],
                            ),
                            Divider()
                          ],
                        );
                      })
                  : selectedIndex == 1
                      ? ListView.builder(
                          itemCount: 5,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                            children: [
                                          Text('Swati Singh',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13)),
                                          SizedBox(height: 5),
                                          Text('You Earned 200 Kandy',
                                              style: TextStyle(
                                                  color: AppTheme.greenColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13))
                                        ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text('Member',
                                          style: TextStyle(
                                              color: AppTheme.greenColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13)),
                                    )
                                  ],
                                ),
                                Divider()
                              ],
                            );
                          })
                      : selectedIndex == 2
                          ? ListView.builder(
                              itemCount: 5,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              itemBuilder: (BuildContext context, int pos) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                                children: [
                                              Text('Swati Singh',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13)),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Not Yet Accept Your Request',
                                                  style: TextStyle(
                                                      color: Color(0xFFED2F59),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13)),
                                            ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start)),
                                        Container(
                                          height: 35,
                                          width: 85,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: AppTheme.themeColor),
                                          child: Center(
                                            child: Text('Remind',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13)),
                                          ),
                                          margin: EdgeInsets.only(right: 5),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Divider(),
                                    SizedBox(height: 5)
                                  ],
                                );
                              })
                          : Container())
        ],
      ),
    );
  }


}
