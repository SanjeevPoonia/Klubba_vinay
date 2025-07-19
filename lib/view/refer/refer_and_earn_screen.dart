import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/refer/EncashKlubbaKandy.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/refer/how_refer_wrk.dart';
import 'package:klubba/view/refer/kandy_transactions.dart';
import 'package:klubba/view/refer/share_kandy_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:lottie/lottie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

import 'package:toast/toast.dart';

class ReferAndEarnScreen extends StatefulWidget {
  ReferState createState() => ReferState();
}

class ReferState extends State<ReferAndEarnScreen> {
  bool isLoading=false;
  String totalKandy='';
  String AvailableKandy='';
  String referralLink='https://klubba.in/register/639d9c65d95d1e1a88657aa8';
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
                text: 'Refer & ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Earn',
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
      body:
      isLoading?
          Center(
            child: Loader(),
          ):
      Column(
        children: [
          Stack(
            children: [
              Container(
                height: 230,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/refer_bg.png'))),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Refer,\nWin,\nRepeat',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 27)),
                  ),
                  Container(
                    height: 180,
                    transform: Matrix4.translationValues(40.0, 0.0, 0.0),
                    child: Lottie.asset('assets/reward_animation.json'),
                  ),
                ],
              )
            ],
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -45.0, 0.0),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            transform:
                                Matrix4.translationValues(-12.0, 0.0, 0.0),
                            height: 90,
                            child:
                                Lottie.asset('assets/referal_animation2.json')),
                        Expanded(
                          child: Container(
                            transform:
                                Matrix4.translationValues(-18.0, 0.0, 0.0),
                            child: Column(
                              children: [
                                Text('Referral Link',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.5)),
                                SizedBox(
                                  height: 6,
                                ),
                                Container(
                                    height: 43,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xFFE6E7F5)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(referralLink,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            _copyText();
                                          },
                                          child: Text('COPY',
                                              style: TextStyle(
                                                  color: AppTheme.blueColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13)),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => HowReferWork()));
                                          },
                                  child: Text('How It Works',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.5)),
                                )
                              ),
                            )),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Share.share('Klubba runs a refer program , where you can earn and redeem klubba kandies.\nhttps://klubba.in/register/639d9c65d95d1e1a88657aa8');
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: Text('Share Link',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.5)),
                                ),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: DottedBorder(
                    color: Color(0xFF01345B),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(4),
                    padding: EdgeInsets.all(6),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        child: Container(
                          height: 85,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [

                              Lottie.asset('assets/kandy_animation.json'),

                              Spacer(),
                              Column(
                                children: [
                                  SizedBox(height: 15),
                                  Text('Total Klubba Kandy Earn',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  SizedBox(height: 8),
                                  Text(totalKandy+' Kandy',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KandyTransactionsScreen()));
                  },
                  child: Container(
                    height: 74,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xFFF3F3F3)),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          width: 60,
                          height: 60,
                          child: Lottie.asset('assets/kandy1_animation.json'),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Text('Klubba Kandy Transaction',
                                style: TextStyle(
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            SizedBox(height: 4),
                            Text('You can view all the transactions here',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          ],
                        )),
                        Icon(Icons.keyboard_arrow_right_outlined,
                            color: Colors.black),
                        SizedBox(width: 15)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
             /*   InkWell(
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>EncashKandy(AvailableKandy)));
                  },
                  child: Container(
                    height: 74,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xFFF3F3F3)),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          width: 60,
                          height: 60,
                          child: Lottie.asset('assets/kandy2_animation.json'),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Text('Encash Klubba Kandy',
                                style: TextStyle(
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            SizedBox(height: 4),
                            Text('Simply dummy text',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          ],
                        )),
                        Icon(Icons.keyboard_arrow_right_outlined,
                            color: Colors.black),
                        SizedBox(width: 15)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),*/
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ShareKandyScreen(AvailableKandy)));
                  },
                  child: Container(
                    height: 74,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xFFF3F3F3)),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          width: 60,
                          height: 60,
                          child: Lottie.asset('assets/kandy3_animation.json'),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Text('Share Klubba Kandy',
                                style: TextStyle(
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            SizedBox(height: 4),
                            Text('Here you can share your kandies with other members',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 12)),
                          ],
                        )),
                        Icon(Icons.keyboard_arrow_right_outlined,
                            color: Colors.black),
                        SizedBox(width: 15)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
  _fetchKandy(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name": "getKandyDetails",
      "data": {
        "_id": id,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": null,
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getKandyDetails', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']["status"]=="error")
      {
        totalKandy="0";
        AvailableKandy="0";
      }
    else
      {
        totalKandy = responseJSON['decodedData']['result']['total'].toString();
        AvailableKandy = responseJSON['decodedData']['result']['available'].toString();
      }

    isLoading = false;
    setState(() {});
    print(responseJSON);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchKandy(context);
  }

  _copyText() async {
    await Clipboard.setData(ClipboardData(text: referralLink));
    Toast.show('Copied Successfully !',
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);

  }
}
