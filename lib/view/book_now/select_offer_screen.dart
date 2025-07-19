import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class SelectOfferScreen extends StatefulWidget {
  final String slug;

  SelectOfferScreen(this.slug);

  OfferState createState() => OfferState();
}

class OfferState extends State<SelectOfferScreen> {
  Map<String, dynamic> packageDetails = {};
  List<dynamic> slotsList = [];
  String packageType = '';
  int selectedSlotIndex = 9999;
  bool isLoading = false;
  String packageImageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                text: 'Available ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Packages',
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
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : ListView(
              children: [
                SizedBox(height: 5),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(packageImageUrl +
                              packageDetails['cover_image']))),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(31),
                          topRight: Radius.circular(31))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Package ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.5)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Details',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                                Container(
                                  width: 35,
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
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(packageDetails['title'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5)),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10, right: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.themeColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 0.3, color: Color(0xFF707070))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Seats',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(
                                        packageDetails['total_booking_seats']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Coaching Type',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text('Individual',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Category Name',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(packageDetails['category_name'],
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Certificate of Completion',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text('Yes',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Class Starts On',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text('03/12/2022',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(
                                        '₹ ' +
                                            packageDetails['discount_price']
                                                .toString(),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Duration',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text(
                                        packageDetails['duration'].toString() +
                                            ' ' +
                                            packageDetails['duration_type'],
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Available For',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    Text('Both',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.blueColor)),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Booking Dates',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.blueColor)),
                            Text(
                                packageDetails['booking_start_date'] +
                                    ' to ' +
                                    packageDetails['booking_end_date'],
                                style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      packageDetails['weekdays'].length != 0
                          ? SizedBox(height: 11)
                          : Container(),
                      packageDetails['weekdays'].length != 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('WeekDays',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.blueColor)),
                                  Text('MO, TU, WE, TH, FR, SA',
                                      style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Description',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.blueColor)),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(packageDetails['description'],
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 20),


                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Slot and Price',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.blueColor)),
                      ),
                      SizedBox(height: 5),

                      Container(
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            scrollDirection: Axis.vertical,
                            itemCount: slotsList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int pos) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color:AppTheme.blueColor,

                                            borderRadius: BorderRadius.circular(4)),
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                        child: Center(
                                          child: Text(
                                              slotsList[pos]['start_date'] +
                                                  '-' +
                                                  slotsList[pos]['end_date']+" => Rs"+slotsList[pos]['price'].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,

                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8)
                                ],
                              );
                            }),
                      ),



                      /*  Padding(
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
                                fontWeight: FontWeight.w500,
                                fontSize: 15.5)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text('Slots',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          Container(
                            width: 35,
                            height: 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppTheme.themeColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),*/
                      /*  SizedBox(height: 12),
                Text('Date of Booking',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.blueColor)),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFF6F6F6)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('21-Dec-2022',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                      Image.asset('assets/calendar.png', width: 20, height: 20)
                    ],
                  ),
                ),*/
                      SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 46,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: ElevatedButton(
                            child: Text('Select Slot',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ))),
                            onPressed: () {
                              _slotsBottomSheet();
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  fetchPackageDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getCoachPackageDetailsForHomepage",
      "data": {
        "slug": widget.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getCoachPackageDetailsForHomepage', requestModel, context);
    var responseJSON = json.decode(response.body);
    packageDetails = responseJSON['decodedData']['package_details'];
    packageImageUrl = responseJSON['decodedData']['package_image_url'];
    packageType = responseJSON['decodedData']['packageType'];
    isLoading = false;

    setState(() {});

    getBookingSlots(context);
    print(responseJSON);
  }

  getBookingSlots(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please wait...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getBookingSlots",
      "data": {
        "booking_slug": widget.slug,
        "booking_type": packageType,
        "type": packageDetails['booking_type'],
        "date": packageDetails['booking_start_date'],
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getBookingSlots', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);

    slotsList = responseJSON['decodedData']['result'];

    setState(() {});
    print(responseJSON);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPackageDetails(context);
  }

  _slotsBottomSheet() {
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
                                Navigator.pop(context);
                                checkBasicPlan();

                              }
                          }),
                    ),
                    SizedBox(height: 25),
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

  checkBasicPlan() async {
    String? currentPlan = await MyUtils.getSharedPreferences('current_package')??"";
    print(currentPlan);
    print("llll");
    if(currentPlan!="")
      {
        _addToCartPackage();
      }
    else
      {
        Toast.show("Please buy our basic plan for booking coach",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DialogScreen()));
      }
  }

  _addToCartPackage() async {
    APIDialog.showAlertDialog(context, 'Package Adding to Cart...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    List<dynamic> slots=[];
    slots.add( {"start_date":slotsList[selectedSlotIndex]['start_date'],
      "end_date":slotsList[selectedSlotIndex]['end_date'],
      "available_seats":slotsList[selectedSlotIndex]['available_seats'],
      "slot_identification_number":slotsList[selectedSlotIndex]['slot_identification_number'],
      "booked_seats":slotsList[selectedSlotIndex]['booked_seats'],
      "available_for":slotsList[selectedSlotIndex]['available_for'],
      "price":slotsList[selectedSlotIndex]['price'],
    });

    AppModel.setSlotData(slots);



//slotsList[selectedSlotIndex]['end_date']
    var data = {
      "method_name": "addToCart",
      "data": {
        "product_slug": widget.slug,
        "slot": [
          {"start_date":slotsList[selectedSlotIndex]['start_date'],
          "end_date":slotsList[selectedSlotIndex]['end_date'],
          "available_seats":slotsList[selectedSlotIndex]['available_seats'],
          "slot_identification_number":slotsList[selectedSlotIndex]['slot_identification_number'],
          "booked_seats":slotsList[selectedSlotIndex]['booked_seats'],
          "available_for":slotsList[selectedSlotIndex]['available_for'],
          "price":slotsList[selectedSlotIndex]['price'],
          }
        ],
        "slot_identification_number":slotsList[selectedSlotIndex]['slot_identification_number'],
        "date": "",
        "product_type": packageType,
        "isGuestCheckout": 0,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('addToCart', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen(false)));
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}
