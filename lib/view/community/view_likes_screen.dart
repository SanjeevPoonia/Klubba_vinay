

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/like_tab.dart';
import 'package:klubba/view/community/react_tab.dart';

class ViewLikesScreen extends StatefulWidget
{
  String postID;
  ViewLikesScreen(this.postID);
  ViewLikeState createState()=>ViewLikeState();
}
class ViewLikeState extends State<ViewLikesScreen>  with TickerProviderStateMixin
{
  TabController? tabController;

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
              fontFamily: "Poppins",
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'View ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Likes',
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

          Container(
            height: 55,
            padding: const EdgeInsets.only(bottom: 5),
            child: AppBar(
              backgroundColor: Color(0xFFF6F6F6),
              bottom: TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0,color: AppTheme.themeColor),
                    insets: EdgeInsets.only(left: 25,right:25,bottom: 7)
                ),
                indicatorColor: AppTheme.themeColor,
                unselectedLabelColor: Color(0xFF1B1B1B),
                labelColor:Color(0xFF1B1B1B),
                labelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                controller: tabController,
                tabs: const [
                  Tab(
                    text: 'Likes',
                  ),
                  Tab(
                    text: 'React',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [LikeTab(widget.postID),ReactTab(widget.postID)],
            ),
          ),

        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 2);

  }





}