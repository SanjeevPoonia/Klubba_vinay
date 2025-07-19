import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';

class DialogScreen2 extends StatefulWidget {
  DialogState createState() => DialogState();
}

class DialogState extends State<DialogScreen2> {
  List<dynamic> packageList = [];
  List<dynamic> packageFeatureList = [];
  List<String> featureListId = [];
  List<dynamic> packFeatures = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
        child: Scaffold(
            body: isLoading
                ? Center(
              child: Loader(),
            )
                : Container()),
        onWillPop: () {
          return Future.value(false);
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPackageDetails(context);
  }

  _showPackageDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
            child: Align(
              alignment: Alignment.center,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('₹',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.5)),
                            Text(
                                packageList[0]['package_mrp'].toString() +
                                    '.00',
                                style: TextStyle(
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27)),
                          ],
                        ),
                        Center(
                          child: Text('/For 365 Days',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.5)),
                        ),
                        SizedBox(height: 15),
                        Center(
                            child: Text('Features',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16))),
                        SizedBox(height: 18),
                        Row(
                          children: [
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: Center(
                                  child: Text('Book a Coach',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            ),
                            SizedBox(width: 8),
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: Center(
                                  child: Text('Klubba Library',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                                height: 33,
                                padding:
                                EdgeInsets.only(left: 7, right: 7, top: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:
                                    AppTheme.themeColor.withOpacity(0.65)),
                                child: const Text(
                                    'Goal,limitation,Equipment\'s,Progress Picture',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.5))),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: Center(
                                  child: Text('My Library',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            ),
                            SizedBox(width: 8),
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: Center(
                                  child: Text('Performance Test',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: const Center(
                                  child: Text('Parent Access',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            ),
                            SizedBox(width: 8),
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: const Center(
                                  child: Text('Self Assessment',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: Center(
                                  child: Text('Planner',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            ),
                            SizedBox(width: 8),
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: Center(
                                  child: Text('1024 MB Space',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 33,
                              padding: EdgeInsets.symmetric(horizontal: 11),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppTheme.themeColor.withOpacity(0.65)),
                              child: Center(
                                  child: Text('Review & Rating',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5))),
                            ),
                          ],
                        ),
                        SizedBox(height: 35),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 25),
                                  height: 50,
                                  child: ElevatedButton(
                                      child: Text('Skip',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5)),
                                      style: ButtonStyle(
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppTheme.blueColor),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppTheme.blueColor),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(4),
                                              ))),
                                      onPressed: () {
                                        appExitDialog();
                                        /*  Route route = MaterialPageRoute(
                                            builder: (context) =>
                                                LandingScreen());
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            route,
                                            (Route<dynamic> route) => false);*/
                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingScreen()));
                                      }),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 25),
                                    height: 50,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                            MaterialStateProperty.all<
                                                Color>(Colors.black),
                                            backgroundColor:
                                            MaterialStateProperty.all<
                                                Color>(Colors.black),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(4),
                                                ))),
                                        onPressed: () {
                                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
                                          _addToCartPackage(context);
                                        },
                                        child: const Text('Proceed',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.5))),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            onWillPop: () {
              return Future.value(false);
            });
      },
    );
  }

  _addToCartPackage(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Package Adding to Cart...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');

    var data = {
      "method_name": "addToCart",
      "data": {
        "product_slug": "basic-1",
        "product_type": "primary",
        "current_role": currentRole,
        "slug": AppModel.slug,
        "current_category_id": null,
        "action_performed_by": null
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
      Route route = MaterialPageRoute(builder: (context) => CartScreen(true));
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _getPackageDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    /* var data = {
      "method_name": "getMembershipPackageOnRole",
      "data": {
        "current_role": currentRole,
        "slug": AppModel.slug,
      }
    };*/

    var data = {
      "method_name": "getMembershipPackageOnRole",
      "data": {
        "slug": "ankit-pareek",
        "current_role": "5d4d4f960fb681180782e4f4"
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'getMembershipPackageOnRole', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    if (responseJSON['decodedData']['status'] == 'success') {
      packageList.clear();
      packageFeatureList.clear();
      featureListId.clear();
      packFeatures.clear();

      packageList = responseJSON['decodedData']['result']['package_list'];
      packageFeatureList =
      responseJSON['decodedData']['result']['package_feature_list'];
/*      for (int i = 0; i < packageList.length; i++) {
        featureListId = packageList[i]['features_id'];
      }
      for (int i = 0; i < packageFeatureList.length; i++) {
        if (featureListId.contains(packageFeatureList[i]['_id'])) {
          packFeatures.add(packageFeatureList[i]);
        }
      }*/

      _showPackageDialog();

      print(packFeatures);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    }
  }

  appExitDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Exit",
          style: TextStyle(
              color: AppTheme.blueColor, fontWeight: FontWeight.w600)),
      onPressed: () {
        Navigator.pop(context);
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Exit App?",
          style: TextStyle(
              color: AppTheme.blueColor, fontWeight: FontWeight.w600)),
      content: Text("Are you sure you want to exit Klubba?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
