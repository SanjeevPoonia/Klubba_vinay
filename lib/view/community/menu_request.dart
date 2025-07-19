import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../app_theme.dart';
import 'received_request.dart';
import 'send_request.dart';


class menuRequest extends StatefulWidget{
  _menuRequest createState()=>_menuRequest();
}
class _menuRequest extends State<menuRequest> with TickerProviderStateMixin{
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
                    text: 'Received Request',
                  ),
                  Tab(
                    text: 'Send Request',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                  receivedRequest(),
                sendRequest()



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