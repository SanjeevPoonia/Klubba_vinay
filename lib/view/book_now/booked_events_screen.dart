import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/loader.dart';


class BookedEventsScreen extends StatefulWidget {
  TransactionState createState() => TransactionState();
}

class TransactionState extends State<BookedEventsScreen> {
  bool isLoading=false;
  List<dynamic> bookingEventList=[];
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
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Booked ',
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
      ),
      body:
      isLoading?
      Center(child: Loader()):
      bookingEventList.length==0?

      Center(
        child: Text('No Events found'),
      ):

      ListView.builder(
          itemCount: bookingEventList.length,
          padding: const EdgeInsets.only(top: 20),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int pos){
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFF3F3F3)),
                  child: Column(
                    children: [
                      Container(
                        height: 51,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppTheme.blueColor),
                        child: Row(
                          children:  [
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                      bookingEventList[pos]['product_name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12)),
                                )),

                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Column(
                                  children: [
                                    Text('Start Date & Time',
                                        style: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11)),
                                    Text('5/28/22, 12:58 PM',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                    SizedBox(height: 10),
                                    Text('Membership',
                                        style: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11)),
                                    Text('Monthly',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                    SizedBox(height: 10),

                                  ],
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                ),
                              ),
                              flex: 1),
                          Expanded(
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('End Date& Time',
                                        style: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11)),
                                    Text('5/29/22, 12:58 PM',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                    SizedBox(height: 10),
                                    Text('Total Amount',
                                        style: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11)),
                                    Text('₹'+bookingEventList[pos]['price'].toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),

                                    SizedBox(height:10),


                                    /* Container(
                                          width: 120,
                                          height: 39,
                                          child: ElevatedButton(
                                              child: Text('View Details',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {




                                              }),
                                        ),*/
                                  ],
                                ),
                              ))
                        ],
                      ),
                      SizedBox(height:15),





                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            );
          }));
  }


  _fetchBookingEvents(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");

    var data = {
      "method_name":"userEventAllBookings",
      "data":{
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":"5ea69a7057329b5981b02c40",
        "action_performed_by":_id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('userEventAllBookings', requestModel, context);
    var responseJSON = json.decode(response.body);
    bookingEventList = responseJSON['decodedData']['result'];
    isLoading = false;
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBookingEvents(context);
  }

}
