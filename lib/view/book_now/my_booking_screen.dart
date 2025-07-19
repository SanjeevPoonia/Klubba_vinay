import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';

import 'package:klubba/widgets/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:toast/toast.dart';


class MyBookingScreen extends StatefulWidget {
  MyBookingState createState() => MyBookingState();
}

class MyBookingState extends State<MyBookingScreen> {
  bool isLoading = false;
  List<dynamic> bookingList = [];

  String currentDate="";
  String bookingImageUrl="";
  String userImageUrl="";
  int totalRecord=0;
  bool _fromTop = true;

  DateTime? _chosenDateTime;
  String _formatedDateTime="";

  int selectedSlotIndex = 9999;



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
                  text: 'Booking',
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
        Column(
          children: [
            SizedBox(height: 15),
            Expanded(
                child:
                bookingList.length==0?
                Center(
                  child: Text('No Bookings found'),
                ): Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: bookingList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int pos) {
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
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(
                                                    bookingList[pos]['seller_details']['full_name'],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12)),
                                              )),
                                          InkWell(

                                            child:Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15, right: 10),
                                                child: Image.asset(
                                                    'assets/download_ic.png',
                                                    color: Colors.white,
                                                    width: 22,
                                                    height: 22)) ,
                                            onTap: ()=>{
                                              _fetchInvoiceUrl(context, bookingList[pos]['order_number'])
                                            },
                                          )

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
                                                  Text('Booking Title',
                                                      style: TextStyle(
                                                          color: AppTheme.blueColor,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11)),
                                                  Text( bookingList[pos]['booking_title'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 13)),
                                                  SizedBox(height: 10),
                                                  Text('Start Date',
                                                      style: TextStyle(
                                                          color: AppTheme.blueColor,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11)),
                                                  Text(bookingList[pos]['start_date'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 13)),
                                                  SizedBox(height: 10),
                                                  Text('Coupon',
                                                      style: TextStyle(
                                                          color: AppTheme.blueColor,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11)),
                                                  SizedBox(height: 10),
                                                  Text(bookingList[pos]['refund_coupon_code']??'',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 13)),
                                                  SizedBox(height: 12),
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
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text('Transaction Number',
                                                      style: TextStyle(
                                                          color: AppTheme.blueColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                  Text(bookingList[pos]['booking_number'],
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
                                                  Text('₹'+bookingList[pos]['price'].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 13)),
                                                  SizedBox(height: 10),
                                                  Text('Status',
                                                      style: TextStyle(
                                                          color: AppTheme.blueColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                  SizedBox(height: 10),


                                                  bookingList[pos]['is_cancelled']==1?
                                                  Container(
                                                    height: 28,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(2),
                                                        color: Color(0xFF6C6C6C)),
                                                    child: Center(
                                                      child: Text('Cancelled',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 11)),
                                                    ),
                                                  ):
                                                  Container(
                                                    height: 28,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(2),
                                                        color: Color(0xFF0BB500)),
                                                    child: Center(
                                                      child: Text('Successfully',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 11)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    bookingList[pos]['is_cancelled']==1?
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                              onTap: ()=>{
                                              //  _showRedeemDialog(pos)
                                              },
                                              child: Container(
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                    color: Color(0xFF6C6C6C)),
                                                child: Center(
                                                  child: Text('Redeem',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                            ),
                                            flex: 1),
                                        SizedBox(width: 8),
                                        Expanded(
                                            child: InkWell(
                                              onTap: ()=>{
                                               // _showCancelDialog(pos)
                                              },
                                              child: Container(
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                    color: Color(0xFF6C6C6C)),
                                                child: Center(
                                                  child: Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                            ),
                                            flex: 1),
                                        SizedBox(width: 8),
                                        Expanded(
                                            child: InkWell(
                                              onTap: ()=>{
                                                //_showChooseDate(pos)
                                              },
                                              child: Container(
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                    color: Color(0xFF6C6C6C)),
                                                child: Center(
                                                  child: Text('Reschedule',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                            ),
                                            flex: 1)
                                      ],
                                    ):Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                              onTap: ()=>{
                                                _showRedeemDialog(pos)
                                              },
                                              child: Container(
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                    color: AppTheme.blueColor),
                                                child: Center(
                                                  child: Text('Redeem',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                            ),
                                            flex: 1),
                                        SizedBox(width: 8),
                                        Expanded(
                                            child: InkWell(
                                              onTap: ()=>{
                                                _showCancelDialog(pos)
                                              },
                                              child: Container(
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                    color: Colors.red),
                                                child: Center(
                                                  child: Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                            ),
                                            flex: 1),
                                        SizedBox(width: 8),
                                        Expanded(
                                            child: InkWell(
                                              onTap: ()=>{
                                                _showChooseDate(pos)
                                              },
                                              child: Container(
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Text('Reschedule',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11)),
                                                ),
                                              ),
                                            ),
                                            flex: 1)
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          );
                        }),
                    ),
                    /*Container(
                      padding: EdgeInsets.only(top: 22, bottom: 22),
                      color: Colors.white,
                      width: double.infinity,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 32),
                        child: ElevatedButton(
                            child: Text('View More',
                                style: TextStyle(color: Colors.white, fontSize: 14)),
                            style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookedEventsScreen()));
                            }),
                      ),
                    )*/
                  ],
                )),

          ],
        ));
  }


  _fetchBookingDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var catId= await MyUtils.getSharedPreferences("current_category_id");

    var data = {
      "method_name": "userWorkshopAllBookings",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 10,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": _id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('userWorkshopAllBookings', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']['status']=="success"){
      bookingList = responseJSON['decodedData']['result'];
      bookingImageUrl=responseJSON['decodedData']['booking_image_url'];
      userImageUrl=responseJSON['decodedData']['user_image_url'];
      totalRecord=responseJSON['decodedData']['recordsTotal'];
    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }

    setState(() {
      isLoading = false;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBookingDetails(context);
  }

  _fetchInvoiceUrl(BuildContext context,String orderNumber) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var data = {
      "method_name": "getOrderPDF",
      "data": {
        "order_number": orderNumber,
        "user_id":_id,
        "current_role": currentRole,
        "slug": AppModel.slug,
        "current_category_id": null,
        "action_performed_by": null,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getOrderPDF', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();

    if( responseJSON['decodedData']['status'].toString()=='success'){

      String urlStr=responseJSON['decodedData']['result'].toString();
      if(urlStr.isEmpty){
        Toast.show("Invoice Not Found!!!",
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }else{
        _showProgressDialog(urlStr,orderNumber);
      }
     // _downloadWithFlutter("https://www.africau.edu/images/default/sample.pdf", orderNumber);
      // _showProgressDialog("https://www.africau.edu/images/default/sample.pdf",orderNumber);

    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }




  _showProgressDialog(String fileUrl,String orderNumber) async{
    ProgressDialog pd = ProgressDialog( context: context);



    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if(statuses[Permission.storage]!.isGranted){
      pd.show(
          max: 100,
          msg: 'File Downloading...',
          progressType: ProgressType.valuable,
          completed: Completed(completedMsg: "Downloading Done !", completedImage: const AssetImage('assets/ic_dn_complt.png'), completionDelay: 2500),
          backgroundColor: Colors.white,
          progressValueColor: AppTheme.primarySwatch.shade800,
          progressBgColor: AppTheme.primarySwatch.shade50,
          msgColor: AppTheme.blueColor,
          valueColor: AppTheme.blueColor
      );
      var dir = await getApplicationDocumentsDirectory();

      if(dir != null){
        String savename = "klubba$orderNumber.pdf";
        String savePath = dir.path + "/$savename";
        print(savePath);
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(
              fileUrl,
              savePath,
              onReceiveProgress: (received, total) {
                if (total != -1) {

                  int progress = (((received / total) * 100).toInt());
                  pd.update(value: progress);
                  print((received / total * 100).toStringAsFixed(0) + "%");
                  //you can build progressbar feature too
                }
              });
          print("File is saved to download folder.");
          Toast.show("File is saved to download folder.",
              duration: Toast.lengthShort,
              gravity: Toast.bottom,
              backgroundColor: Colors.green);

        } on DioError catch (e) {
          print(e.message);
          Toast.show(e.message,
              duration: Toast.lengthShort,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          pd.update(value: 100,msg: "Error!! Downloading Failed...");
        }
      }
    }else{
      Toast.show("No permission to read and write.",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);


    }




  }


  _showRedeemDialog(int pos) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 22,horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
                  Row(
                    children: [
                      Spacer(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('Are ',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text('You Sure',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                    fontSize: 16)),
                            SizedBox(height: 3),
                            Container(
                              width: 38,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppTheme.themeColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/ic_warning.png",height: 48,width: 48,),
                        SizedBox(height: 15,),
                        Text("Are you sure you want to redeem this bookings?",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.blueColor
                        ),)
                        

                      ],
                    ) ,
                  ),

                  SizedBox(height: 27),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: ()=>{
                              Navigator.pop(context),
                              _redeemCoupan(context, pos)
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  color: AppTheme.btnColor),
                              child: const Center(
                                child: Text('Yes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11)),
                              ),
                            ),
                          )),
                      SizedBox(width: 8),
                      Expanded(
                          child: InkWell(
                            onTap: ()=>{
                            Navigator.pop(context)
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  color: AppTheme.blueColor),
                              child: Center(
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11)),
                              ),
                            ),
                          ),
                          flex: 1),
                    ],
                  ),


                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
  _showCancelDialog(int pos) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 22,horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
                  Row(
                    children: [
                      Spacer(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('Are ',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text('You Sure',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                    fontSize: 16)),
                            SizedBox(height: 3),
                            Container(
                              width: 38,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppTheme.themeColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/ic_warning.png",height: 48,width: 48,),
                        SizedBox(height: 15,),
                        Text("Are you sure you want to Cancel this bookings?",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.blueColor
                          ),)


                      ],
                    ) ,
                  ),

                  SizedBox(height: 27),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: ()=>{
                              Navigator.pop(context),
                              _cancelBooking(context, pos)
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  color: AppTheme.btnColor),
                              child: Center(
                                child: Text('Yes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11)),
                              ),
                            ),
                          ),
                          flex: 1),
                      SizedBox(width: 8),
                      Expanded(
                          child: InkWell(
                            onTap: ()=>{
                              Navigator.pop(context)
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  color: AppTheme.blueColor),
                              child: Center(
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11)),
                              ),
                            ),
                          ),
                          flex: 1),
                    ],
                  ),


                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }



  _redeemCoupan(BuildContext context,int pos) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id=await MyUtils.getSharedPreferences('_id');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "redeemBookingCoupon",
      "data": {
        "action_performed_by": id,
        "booking_id":bookingList[pos]['_id'],
        "coupon":bookingList[pos]['booking_number'],
        "current_category_id": catId,
        "current_role": currentRole,
        "slug": AppModel.slug,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('redeemBookingCoupon', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();

    if( responseJSON['decodedData']['status'].toString()=='success'){

      _showOTPDialog(pos);

    }else{
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }

  _showOTPDialog(int pos){
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 22,horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
                  Row(
                    children: [
                      Spacer(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('Verify ',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text('Booking OTP',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                    fontSize: 16)),
                            SizedBox(height: 3),
                            Container(
                              width: 38,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppTheme.themeColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/ic_otp_sms.png",height: 64,width: 64,),
                        SizedBox(height: 15,),
                        Text("Please enter the one time password to verify your Booking Otp",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.blueColor
                          ),),
                        SizedBox(height: 15,),
                        Text("We have sent the OTP on Your registered Mobile",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.blueColor
                          ),),
                        SizedBox(height: 15,),
                        Container(
                          margin: const EdgeInsets
                              .symmetric(
                              horizontal: 20),
                          height: 55,
                          child: Center(
                            child: OtpTextField(
                              borderRadius: BorderRadius.circular(4),
                              borderColor:AppTheme.otpColor.withOpacity(0.5),
                              fillColor: AppTheme.otpColor.withOpacity(0.5),
                              filled: true,
                              numberOfFields: 4,
                              focusedBorderColor:
                              AppTheme.blueColor,
                              //set to true to show as box or false to show as dash
                              showFieldAsBox: true,
                              //runs when a code is typed in
                              onCodeChanged:
                                  (String code) {
                                //handle validation or checks here
                              },

                              //runs when every textfield is filled
                              onSubmit: (String
                              verificationCode) {
                                Navigator.pop(context);
                                _verifyReedemOTP(context, pos, verificationCode);
                              }, // end onSubmit
                            ),
                          ),
                        ),


                      ],
                    ) ,
                  ),




                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  _verifyReedemOTP(BuildContext context,int pos,String otp) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id=await MyUtils.getSharedPreferences('_id');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "verifyOtpForCouponRedemption",
      "data": {
        "action_performed_by": id,
        "booking_id":bookingList[pos]['_id'],
        "otp":otp,
        "current_category_id": catId,
        "current_role": currentRole,
        "slug": AppModel.slug,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('verifyOtpForCouponRedemption', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();

    if( responseJSON['decodedData']['status'].toString()=='success'){

      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

    }else{
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }

  _cancelBooking(BuildContext context,int pos) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id=await MyUtils.getSharedPreferences('_id');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "cancelBooking",
      "data": {
        "action_performed_by": id,
        "booking_id":bookingList[pos]['_id'],
        "current_category_id": catId,
        "current_role": currentRole,
        "slug": AppModel.slug,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('cancelBooking', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();

    if( responseJSON['decodedData']['status'].toString()=='success'){

      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

    }else{
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }

  _showChooseDate(int pos) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
                  Row(
                    children: [
                      Spacer(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('Reschedule ',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text('Now',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                    fontSize: 16)),
                            SizedBox(height: 3),
                            Container(
                              width: 38,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppTheme.themeColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Text("Select Date",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w500
                  ),),
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,

                        minimumDate: DateTime.now(),
                        initialDateTime: DateTime.now(),
                        maximumDate: DateTime.now().add(Duration(days: 60)),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                            _formatedDateTime = _chosenDateTime.toString();
                            print(_formatedDateTime);
                          });
                        }),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Find Slot',
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.5)),
                        style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ))),
                        onPressed: () {
                          if(_formatedDateTime.isNotEmpty){
                            Navigator.pop(context);
                            _findSlot(context, pos);
                          }else{
                            Toast.show("Please Select a Date First",
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                          }


                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
  _findSlot(BuildContext context,int pos) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id=await MyUtils.getSharedPreferences('_id');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getRescheduleBookingSlots",
      "data": {
        "action_performed_by": id,
        "booking_id":bookingList[pos]['_id'],
        "booking_slug":bookingList[pos]['booking_slug'],
        "booking_type":bookingList[pos]['booking_type'],
        "current_category_id": catId,
        "current_role": currentRole,
        "date":_formatedDateTime,
        "slug": AppModel.slug,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getRescheduleBookingSlots', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();

    _formatedDateTime="";
    _chosenDateTime=null;

    if( responseJSON['decodedData']['status'].toString()=='success'){

      List<dynamic> slotList=[];
      slotList=responseJSON['decodedData']['result'];
      if(slotList.isEmpty){
        Toast.show("No Available Slots Found.",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }else{
        _slotsBottomSheet(slotList, pos);
      }

    }else{
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }

  _slotsBottomSheet(List<dynamic> slotsList,int pos) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, dialogState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                          width: 80, height: 3, color: Color(0xFFAAAAAA)),
                    ),
                    Row(
                      children: [
                        Spacer(),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Available ',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text('Slots',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.none,
                                      fontSize: 16)),
                              SizedBox(height: 3),
                              Container(
                                width: 38,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: AppTheme.themeColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 5),
                    Container(
                      height: 40,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: slotsList.length,
                          itemBuilder: (BuildContext context, int pos) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    dialogState(() {
                                      selectedSlotIndex = pos;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: selectedSlotIndex == pos
                                            ? AppTheme.blueColor
                                            : AppTheme.greyColor,
                                        borderRadius: BorderRadius.circular(4)),
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child: Center(
                                      child: Text(
                                          slotsList[pos]['start_date'] +
                                              '-' +
                                              slotsList[pos]['end_date'],
                                          style: TextStyle(
                                              color: selectedSlotIndex == pos
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5)
                              ],
                            );
                          }),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 46,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                          child: Text('Book Now',
                              style:
                              TextStyle(color: Colors.white, fontSize: 14)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ))),
                          onPressed: () {

                            if(selectedSlotIndex!=9999)
                            {
                              /*
                                * Need to change this
                               */
                              selectedSlotIndex=9999;
                              Navigator.pop(context);

                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, false ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }




}
