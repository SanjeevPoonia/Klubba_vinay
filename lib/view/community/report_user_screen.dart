import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:toast/toast.dart';

class ReportScreen extends StatefulWidget {
  final String postID;

  ReportScreen(this.postID);

  ReportState createState() => ReportState();
}

class ReportState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text('Report',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                                fontSize: 16)),
                        SizedBox(height: 3),
                        Container(
                          width: 38,
                          margin: EdgeInsets.only(right: 16.5),
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: AppTheme.themeColor),
                        )
                      ],
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              )),
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
          SizedBox(height: 13),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                thickness: 1.5,
              )),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
                'If someone is in immediate danger, get help before reporting to Klubba. Don\'t wait.',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    fontSize: 15.5)),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 19, right: 10),
            child: Text(
                '- You can submit a report now even if you don\'t add information',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    fontSize: 12)),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 11, right: 10),
            child: Text(
                '- We won\'t let being sarcastic know who reported them',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    fontSize: 12)),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: ElevatedButton(
                child: Text('Submit Report',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ))),
                onPressed: () {

                  reportPost();


                }),
          ),
        ],
      ),
    );
  }

  reportPost() async {
    APIDialog.showAlertDialog(context, "Please wait");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "reportApostOrRepostOrShared",
      "data": {
        "post_id": widget.postID,
        "action_type": "report",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'reportApostOrRepostOrShared', requestModel, context);
    var responseJSON = json.decode(response.body);

    Navigator.pop(context);

    if (responseJSON['decodedData']['status'] == "success") {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.pop(context);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
    print(responseJSON);
  }
}
