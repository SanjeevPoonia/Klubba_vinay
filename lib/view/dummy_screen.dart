
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/webview_page.dart';

class DummyScreen extends StatefulWidget
{
  DummyState createState()=>DummyState();
}
class DummyState extends State<DummyScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: (){

          },
          child: Container(
            width: 100,
            height: 45,
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text('Payment Test',style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white
              )),
            ),
          ),
        ),

      )
    );
  }
  placeOrder(BuildContext context) async {

    APIDialog.showAlertDialog(context, 'Placing order...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name": "placeOrder",
      "data": {
        "date": "2023-01-01T06:01:17.971Z",
        "slot": [
          {"time": "07:52 am-11:10 am"}
        ],
        "payment_method": "cash",
        "afterKandyAmount": 15,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": null,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('placeOrder', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {

    }
    // coachGalleryData = responseJSON['decodedData']['result']['coach_gallery'];
    print(responseJSON);
  }
}