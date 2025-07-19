import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/view/performance_assesment/apply_performance_test.dart';
import 'package:klubba/widgets/listile_widget.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class performanceTest extends StatefulWidget {
  _performanceTest createState() => _performanceTest();
}

class _performanceTest extends State<performanceTest> {
  List<dynamic> performanceItems = [];
  bool isLoading = true;
  String? userName;
  Map<String, dynamic> testDetails = {};
  var reasonController = TextEditingController();

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
                  text: 'Performance ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Test',
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
            : performanceItems.isEmpty
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your have not applied for performance test yet',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          height: 47,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                              child: Text('Apply Performance Test',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.5)),
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
                                _navigateAndApply(context);
                              }),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            const SizedBox(height: 5),
                            ListView.builder(
                                itemCount: performanceItems.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int pos) {
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        padding: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Color(0xFFF3F3F3)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 51,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: AppTheme.blueColor),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                        "Date of Application: " +
                                                            performanceItems[
                                                                        pos][
                                                                    'preferred_date']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12)),
                                                  )),
                                                  /*  Padding(
                                          padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                          child: Text('Time Slot : '+performanceItems[pos]['preferred_time'].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),
                                        )*/
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                            'Applied For',
                                                            style: TextStyle(
                                                                color: AppTheme
                                                                    .blueColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 11)),
                                                        Text(
                                                            performanceItems[
                                                                        pos][
                                                                    'applied_skill']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Payment Status',
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .blueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11)),
                                                      performanceItems[pos][
                                                                  'payment_status'] ==
                                                              1
                                                          ? Container(
                                                              height: 28,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                  color: Color(
                                                                      0xFF0BB500)),
                                                              child: Center(
                                                                child: Text(
                                                                    'Successfully',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            11)),
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 28,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                  color: Color(
                                                                      0xFFEA0A3B)),
                                                              child: Center(
                                                                child: Text(
                                                                    'Pending',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            11)),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ))
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                      'Application Status',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11)),
                                                  Text(
                                                      performanceItems[pos]
                                                              ['status_label']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                            'Your Acceptance',
                                                            style: TextStyle(
                                                                color: AppTheme
                                                                    .blueColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 11)),
                                                        Text("-",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: performanceItems[pos]
                                                                [
                                                                'status_label'] ==
                                                            "Coach accepted" && performanceItems[pos][
                                                    'payment_status'] ==
                                                        1
                                                        ? Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .end,
                                                        children: [
                                                          Text('Action',
                                                              style: TextStyle(
                                                                  color: AppTheme
                                                                      .blueColor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  fontSize:
                                                                  11)),
                                                          SizedBox(
                                                              height: 5),



                                                          Container(
                                                          //  width: 120,
                                                            height: 39,
                                                            child: ElevatedButton(
                                                                child: Text('View Details', style: TextStyle(color: Colors.white, fontSize: 12.5)),
                                                                style: ButtonStyle(
                                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(4),
                                                                    ))),
                                                                onPressed: () {
                                                                  _fetchAssesmentDetails(performanceItems[pos]
                                                                  [
                                                                  '_id']);
                                                                }),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                        : Container())
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  );
                                })
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 47,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ElevatedButton(
                            child: Text('Apply Performance Test',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.5)),
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
                              _navigateAndApply(context);
                            }),
                      ),
                    ],
                  ));
  }

  _fetchTransactionDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var _catId = await MyUtils.getSharedPreferences("current_category_id");

    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {
      "method_name": "getPerformanceAssessmentList",
      "data": {
        "current_role": currentRole,
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": "0",
        "pageSize": "10",
        "current_category_id": _catId,
        "action_performed_by": _id,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getPerformanceAssessmentList', requestModel, context);
    var responseJSON = json.decode(response.body);

    Navigator.of(context).pop();

    if (responseJSON['decodedData']['status'] == 'success') {
      performanceItems = responseJSON['decodedData']['result'];
    } else {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    isLoading = false;
    setState(() {});
  }

  _fetchAssesmentDetails(String assesmentID) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var _catId = await MyUtils.getSharedPreferences("current_category_id");

    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "method_name": "getPerformanceAssessmentRequestDetail",
      "data": {
        "test_token": assesmentID,
        "current_role": currentRole,
        "slug": AppModel.slug,
        "current_category_id": _catId,
        "action_performed_by": _id,
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getPerformanceAssessmentRequestDetail', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    testDetails = responseJSON["decodedData"]["result"];

    showCustomDialog(context);
  }

  submitReason(String testID) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var _catId = await MyUtils.getSharedPreferences("current_category_id");

    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "method_name": "raiseRequestForRescheduleTestRequest",
      "data": {
        "slug": AppModel.slug,
        "test_token": testID,
        "learner_reschedule_reason": reasonController.text,
        "current_role": currentRole,
        "current_category_id": _catId,
        "action_performed_by": _id,
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'raiseRequestForRescheduleTestRequest', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              // height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 53,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: AppTheme.blueColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Performance Test Detail',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset("assets/cross_ic.png",
                                width: 22, height: 22)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text('Dear ',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 15)),
                        Text(userName.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.5)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  testDetails.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              'Your application for Performance test to upgrade learner stage is received ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              'Your application for Performance test to upgrade learner stage - (' +
                                  testDetails["currentSkillLevel"]["name"] +
                                  ' to ' +
                                  testDetails["learnerStage"]["name"] +
                                  ') is received ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                        ),
                  testDetails.isEmpty?Container():
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Your Performance Test Schedule ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                        ),
                        SizedBox(height: 7),
                        ListTileWidget('Examiner Name',
                            testDetails["coachDetail"]["full_name"]),
                        SizedBox(height: 5),
                        ListTileWidget(
                            'Mobile Number',
                            testDetails["coachDetail"]["mobile_number"]
                                .toString()),
                        SizedBox(height: 5),
                        ListTileWidget(
                            'Email', testDetails["coachDetail"]["email"]),
                        SizedBox(height: 5),
                        ListTileWidget(
                            'Preferred Date & Time',
                            testDetails["preferred_date"].toString() +
                                ", " +
                                testDetails["preferred_time"]),
                        SizedBox(height: 5),
                        ListTileWidget(
                            'New Date & Time',
                            testDetails["test_date"].toString() +
                                ", " +
                                testDetails["test_time"].toString()),
                        SizedBox(height: 5),
                        ListTileWidget('Venue', testDetails["test_venue"]),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              'If you agree on above schedule then please accept, if not then reject or Reschedule',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 30, right: 30, top: 5, bottom: 25),
                            height: 45,
                            width: 140,
                            child: ElevatedButton(
                                child: Text('Reschedule',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.5)),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFFC3F3F)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ))),
                                onPressed: () {
                                  Navigator.pop(context);
                                  reasonController.text="";
                                  rescheduleDialog(context);
                                }),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  )
                ],
              ),

              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void rescheduleDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              // height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 53,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: AppTheme.blueColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reschedule Request',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset("assets/cross_ic.png",
                                width: 22, height: 22)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text('Enter reason for rescheduling',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppTheme.greyColor,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: reasonController,
                      decoration: const InputDecoration(
                          hintText: "Enter Reason",
                          contentPadding: EdgeInsets.only(left: 12),
                          hintStyle: TextStyle(
                              color: AppTheme.hintColor, fontSize: 13),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                              height: 45,
                              child: ElevatedButton(
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.5)),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppTheme.blueColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            flex: 1),
                        SizedBox(width: 20),
                        Expanded(
                            child: Container(
                              height: 45,
                              child: ElevatedButton(
                                  child: Text('Submit',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.5)),
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
                                    Navigator.pop(context);


                                    if(reasonController.text!="")
                                      {
                                        submitReason(testDetails["_id"]);
                                      }

                                    // call API
                                  }),
                            ),
                            flex: 1)
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),

              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchTransactionDetails(context);
    });
  }

  fetchUserName() async {
    userName = await MyUtils.getSharedPreferences("name");
  }

  Future<void> _navigateAndApply(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => applyPerformanceTest()));
    if (!mounted) return;

    if (result == "1") {
      Future.delayed(const Duration(milliseconds: 0), () {
        _fetchTransactionDetails(context);
      });
    }
  }
}
