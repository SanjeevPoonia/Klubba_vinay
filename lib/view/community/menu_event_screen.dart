import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/community/running_events.dart';
import 'package:klubba/view/community/upcoming_events.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';

class menuEventScreen extends StatefulWidget{
  _menuEventScreen createState()=>_menuEventScreen();
}

class _menuEventScreen extends State<menuEventScreen> with TickerProviderStateMixin{

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
               text: 'View ',
               style: const TextStyle(fontSize: 16, color: Colors.black),
             ),
             TextSpan(
               text: 'Events',
               style: const TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                   color: Colors.black),
             ),
           ],
         ),
       ),
       centerTitle: true,
     /*  actions: [
         IconButton(onPressed: (){}, icon: Icon(Icons.add_circle,color: Colors.black,))
       ],*/
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
               tabs: const [
                 Tab(
                   text: 'Upcoming Event',
                 ),
                 Tab(
                   text: 'Running Event',
                 ),
               ],
             ),
           ),
         ),
         Expanded(
           child: TabBarView(
             controller: tabController,
             children: [
                  upComingEvents(),
               runingEvents()

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
    tabController = TabController(vsync: this, length: 2);
  }

}