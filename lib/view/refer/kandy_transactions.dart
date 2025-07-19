import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/refer/recommended_screen.dart';
import 'dart:convert';

import 'package:klubba/widgets/loader.dart';

class KandyTransactionsScreen extends StatefulWidget {
  KandyState createState() => KandyState();
}

class KandyState extends State<KandyTransactionsScreen> {
  bool isLoading=false;
  String totalKandy='';
  String redeemKandy='';
  String availableKandy='';
  List<dynamic> transactionIn=[];
  List<dynamic> transactionOut=[];
  bool noTransaction=false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                text: 'Klubba Kandy ',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Transaction',
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
      body:
      isLoading?
          Center(
            child: Loader(),
          ):

          noTransaction?


              Center(
                child: Text("No transactions found !"),
              ):


      ListView(
        children: [
          const SizedBox(height: 12),
         /* Stack(
            children: [
              Container(
                height: 157,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: const Color(0xFFE6E7F5)),
                child: Column(
                  children: const [
                    Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 20, right: 10, bottom: 7),
                      child: Text(
                          'Customers earned 10000 Kandy by introducing their friends and family to Klubba',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12)),
                    ),
                  ],
                ),
              ),
              Container(
                height: 110,
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1A1A1A),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'My ',
                                  style: TextStyle(
                                      fontSize: 16, color: AppTheme.blueColor),
                                ),
                                TextSpan(
                                  text: 'Recommendations',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.blueColor),
                                ),
                              ],
                            ),
                          ),
                         GestureDetector(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>RecommendedScreen()));
                           },
                           child: Text('View All',
                               style: TextStyle(
                                   color: Colors.black,
                                   decoration: TextDecoration.underline,
                                   fontWeight: FontWeight.w600,
                                   fontSize: 14)),
                         )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Text('1',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22)),
                              SizedBox(height: 5),
                              Text('Pending',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ],
                          ),
                          Column(
                            children: const [
                              Text('10',
                                  style: TextStyle(
                                      color: Color(0xFF3CDD0B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22)),
                              SizedBox(height: 5),
                              Text('Successful',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ],
                          ),
                          Column(
                            children: const [
                              Text('500',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20)),
                              SizedBox(height: 5),
                              Text('Earned Kandy',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),*/

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
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
                  contentPadding: EdgeInsets.only(top: 12),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                )),
          ),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: DottedBorder(
              color: const Color(0xFF01345B),
              borderType: BorderType.RRect,
              radius: const Radius.circular(6),
              padding: EdgeInsets.zero,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: Container(
                      height: 78,
                      width: double.infinity,
                      color: const Color(0xFFF3F3F3),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children:  [
                                Text('Total Earn',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                SizedBox(height: 5),
                                Text(totalKandy+' Kandy',
                                    style: TextStyle(
                                        color: AppTheme.greenColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Total Spend',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                SizedBox(height: 5),
                                Text(redeemKandy+' Kandy',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Remaining Kandy',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                SizedBox(height: 5),
                                Text(totalKandy+' Kandy',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ))),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: const Color(0xFFE0E0E0),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const SizedBox(
                  width: 160,
                  child: Text('Details',
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Text('Earn',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14)))),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Text('Spend',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14))))
              ],
            ),
          ),
          ListView.builder(
              itemCount: transactionIn.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int pos) {
                return Column(
                  children: [

                    Container(
                      height: 46,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color:Colors.white ,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 160,
                            child: Text(
                                transactionIn[pos]['type'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.5)),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text(transactionIn[pos]['points']+' Kandy',
                                      style: TextStyle(
                                          color: AppTheme.greenColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)))),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14))))
                        ],
                      ),
                    ),

                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.1),
                    )
                  ],
                );
              }),
          ListView.builder(
              itemCount: transactionOut.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int pos) {
                return Column(
                  children: [

                    Container(
                      height: 46,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Color(0xFFF6F6F6),
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 160,
                            child: Text(
                                transactionOut[pos]['type'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.5)),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('',
                                      style: TextStyle(
                                          color: AppTheme.greenColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)))),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('20 Kandy',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14))))
                        ],
                      ),
                    ),

                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.3),
                    )
                  ],
                );
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchKandy(context);
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

    if(responseJSON['decodedData']['status']=="error")
      {
       noTransaction=true;
      }
    else
      {
        totalKandy = responseJSON['decodedData']['result']['total'].toString();
        redeemKandy = responseJSON['decodedData']['result']['redeemed'].toString();
        availableKandy = responseJSON['decodedData']['result']['available'].toString();
        transactionIn = responseJSON['decodedData']['result']['transaction_in'];
        transactionOut = responseJSON['decodedData']['result']['transaction_out'];
      }

    isLoading = false;
    setState(() {});
    print(responseJSON);
  }
}
