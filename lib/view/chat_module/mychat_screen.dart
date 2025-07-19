import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';
import '../community/received_request.dart';
import '../community/send_request.dart';
import 'package:flutter_svg/svg.dart';
import 'archievChat_Screen.dart';
import 'chat_screen.dart';
import 'groupChatScreen.dart';
import 'newmessage_screen.dart';

class myChatScreen extends StatefulWidget{
  _myChatScreen createState()=>_myChatScreen();
}
class _myChatScreen extends State<myChatScreen> with TickerProviderStateMixin{
  TabController? tabController;
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
                text: 'My ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Chat',
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
      body: Column(
        children: [
          Container(
            height: 53,
            padding: const EdgeInsets.only(bottom: 5),
            child: AppBar(
              backgroundColor: AppTheme.greyColor,
              bottom: TabBar(
                indicatorColor: AppTheme.themeColor,
                unselectedLabelColor: Colors.black38,
                labelColor: Colors.black87,
                labelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                controller: tabController,
                tabs:  [
                  Tab(
                   icon: SvgPicture.asset(
                     'assets/ic_chat_folder.svg',
                     height: 20,
                     width: 20,
                     color: AppTheme.hintColor,
                   ),
                  ),
                  Tab(
                    text: 'Chat',
                  ),
                  Tab(
                    text: 'Group Chat',
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                archievChatScreen(),
                chatScreen(),
                groupChatScreen()
              ],
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
    tabController = TabController(vsync: this, length: 3);
  }


}