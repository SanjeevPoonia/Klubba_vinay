import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/menu/AddSuggestions.dart';
import 'package:klubba/view/menu/MySuggestions.dart';
import 'package:lottie/lottie.dart';

import '../app_theme.dart';

class Suggestion extends StatefulWidget{
  _suggestion createState()=>_suggestion();
}
class _suggestion extends State<Suggestion> with TickerProviderStateMixin{
  TabController? tabController;


 /* TabBar get _tabBar=>TabBar(
    unselectedLabelColor: AppTheme.blueColor,
    indicatorSize: TabBarIndicatorSize.label,
    
    indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppTheme.blueColor,
    ),
    tabs: [






      Tab(
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          child: Align(
            alignment: Alignment.center,
            child: Text("Add Suggestion"),
          ),

        ),
      ),
      Tab(
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          child: Align(
            alignment: Alignment.center,
            child: Text("My Suggestion"),
          ),

        ),
      )
    ],
    labelColor: AppTheme.themeColor,
    labelStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),

  );*/
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
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
                  text: ' ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Suggestion',
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
            Container(
              height: 53,
              padding: const EdgeInsets.only(bottom: 5),
              child: AppBar(
                backgroundColor: AppTheme.blueColor,
                bottom: TabBar(
                  indicatorColor: AppTheme.themeColor,
                  unselectedLabelColor: const Color(0xFFB9B9B9),
                  labelColor: AppTheme.themeColor,
                  labelStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: 'Add Suggestion',
                    ),
                    Tab(
                      text: 'My Suggestion',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  AddSuggestions(),
                  MySuggestions()
                ],
              ),
            ),
          ],
        )

    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }
}