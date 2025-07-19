import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/notification/notification_detail.dart';
import 'package:klubba/widgets/loader.dart';

class NotificationScreen extends StatefulWidget {
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationScreen> {
  List<dynamic> notificationList = [];
  bool isLoading = false;
  bool isPagLoading = false;
  int _page = 1;
  bool loadMoreData=true;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.themeColor,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
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
                  text: 'Notification',
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
            SizedBox(height: 9),
            
            Expanded(child: isLoading
                ? Center(
              child: Loader(),
            )
                :
            notificationList.length==0?

                Center(
                  child: Text("No Notifications"),
                ):




            ListView.builder(
                itemCount: notificationList.length,
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                itemBuilder: (BuildContext context, int pos) {
                  return Column(
                    children: [
                      InkWell(
                        onTap:(){

                          if(notificationList[pos]["is_read"]==0)
                            {
                              markRead(notificationList[pos]["_id"]);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationDetail(notificationList[pos]["message"])));

                            }
                          else
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationDetail(notificationList[pos]["message"])));

                            }


                  },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10, top: 10, right: 10, bottom: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: notificationList[pos]["is_read"]==0?Color(0xFFB3D5EF): Color(0xFFF3F3F3)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(notificationList[pos]['message'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12)),
                                  ),
                                  SizedBox(width: 5),

                                  notificationList[pos]["is_read"]==0?

                                    Container(
                          width: 55,
                          height: 19,
                          decoration: BoxDecoration(
                            color: AppTheme.themeColor,
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: Center(
                            child:  Text('NEW',
                                style: TextStyle(
                                    color: Color(0xFF777777),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9))
                          ),
                        ):Container()
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SizedBox(height: 3),
                              Text(_returnDateInFormat(notificationList[pos]['created_at']),
                                  style: TextStyle(
                                      color: Color(0xFF777777), fontSize: 12))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  );
                })),

            isPagLoading
                ? Container(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Center(
                child: Loader(),
              ),
            )
                : Container(),
            
            
          ],
        ));
  }

  fetchNotifications(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    var data = {
      "method_name": "getNotificationCountAndList",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 1,
        "pageSize": 10,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getNotificationCountAndList', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    notificationList = responseJSON['decodedData']['result'];

    print(responseJSON);
    setState(() {});
  }

  markRead(String notificationID) async {

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    var data = {
      "method_name":"updateReadNotification",
      "data":{
        "_id":notificationID,
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":catId,
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getAllNotificationList', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
  }




  fetchPaginateData(BuildContext context,int page) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    var data = {
      "method_name": "getAllNotificationList",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": page,
        "pageSize": 10,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getAllNotificationList', requestModel, context);
    var responseJSON = json.decode(response.body);
    isPagLoading = false;
    List<dynamic> newNotifications= responseJSON['decodedData']['result'];
    if(newNotifications.length==0)
    {
      loadMoreData=false;
    }
    else
    {
      List<dynamic> combo=notificationList+newNotifications;
      notificationList=combo;
    }

    print(responseJSON);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _page++;
        if (loadMoreData) {
          setState(() {
            isPagLoading = true;
          });
          fetchPaginateData(context,_page);
        }
      }
    });
    fetchNotifications(context);
  }

  String _returnDateInFormat(String date) {
    final format = DateFormat('dd/MM/yyyy', 'en-US');
    var dateTime22 = format.parse(date, true);
    final DateFormat monthCount = DateFormat.yMMMMd();
    String count = monthCount.format(dateTime22);
    return count;
  }
}
