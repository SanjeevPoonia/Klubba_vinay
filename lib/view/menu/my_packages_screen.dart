import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/dialog/dialog_screen.dart';
import 'package:klubba/view/dialog/dialog_screen_pro.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';

class MyPackagesScreen extends StatefulWidget {
  MyPackageState createState() => MyPackageState();
}

class MyPackageState extends State<MyPackagesScreen> {
  List<dynamic> packageItems = [];
  bool isLoading = true;
  String email = "";

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
                email == "govindshringi9883@gmail.com"
                    ? Container()
                    : Row(
                        children: [
                          // Spacer(),

                          Container(
                            width: 120,
                            height: 39,
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: ElevatedButton(
                                child: Text(
                                  'Upgrade To Pro',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.5),
                                  textAlign: TextAlign.center,
                                ),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProDialogScreen()));
                                }),
                          ),
                        ],
                      ),
                SizedBox(height: 5),
                packageItems.isEmpty
                    ? const Center(
                        child: Text('Your Transaction History is empty'))
                    : ListView.builder(
                        itemCount: packageItems.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int pos) {
                          return Column(
                            children: [
                              SizedBox(height: 10),
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
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: AppTheme.blueColor),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                                packageItems[pos]
                                                        ['package_name'] ??
                                                    '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12)),
                                          )),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 10),
                                            child: Text(
                                                '₹ ' +
                                                        packageItems[pos]
                                                                ['price']
                                                            .toString() ??
                                                    '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                children: [
                                                  Text('Package Of',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11)),
                                                  Text(
                                                      packageItems[pos]
                                                              ['package_for'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13)),
                                                  SizedBox(height: 10),
                                                  Text('Date',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11)),
                                                  Text(
                                                      packageItems[pos][
                                                              'package_expiry_date'] ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13)),
                                                  SizedBox(height: 10),
                                                  Text('Order Status',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .blueColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11)),
                                                  SizedBox(height: 10),
                                                  packageItems[pos]['status'] ==
                                                          0
                                                      ? Container(
                                                          height: 28,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                              color: Color(
                                                                  0xFFFF0200)),
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
                                                        ),
                                                  SizedBox(height: 12),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                            ),
                                            flex: 1),
                                        SizedBox(width: 10),
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Purchase Date',
                                                  style: TextStyle(
                                                      color: AppTheme.blueColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11)),
                                              Text(
                                                  packageItems[pos]
                                                          ['created_at'] ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13)),
                                              SizedBox(height: 10),
                                              Text('Duration',
                                                  style: TextStyle(
                                                      color: AppTheme.blueColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11)),
                                              Text(
                                                  packageItems[pos][
                                                                  'package_member_ship_duration']
                                                              .toString() +
                                                          " " +
                                                          packageItems[pos][
                                                              'package_member_ship'] ??
                                                      "",
                                                  style:
                                                      TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13)),
                                              SizedBox(height: 25),
                                             /* packageItems[pos]['status'] == 0
                                                  ? const Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: SizedBox(
                                                        width: 5,
                                                        height: 5,
                                                      ),
                                                    )
                                                  : Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: InkWell(
                                                        onTap: () => {
                                                          _fetchInvoiceUrl(
                                                              context,
                                                              packageItems[pos][
                                                                      'order_number']
                                                                  .toString())
                                                        },
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 10,
                                                                    bottom: 20),
                                                            child: Image.asset(
                                                                'assets/download_ic.png',
                                                                width: 22,
                                                                height: 22)),
                                                      ),
                                                    )*/
                                            ],
                                          ),
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        })
              ],
            ),
    );
  }

  _fetchMyPackaged(BuildContext context, String PageNo) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var _catId = await MyUtils.getSharedPreferences("current_category_id");
    var data = {
      "method_name": "getMyPackage",
      "data": {
        "current_role": currentRole,
        "slug": AppModel.slug,
        "orderColumn": "S",
        "orderDir": "desc",
        "pageNumber": PageNo,
        "pageSize": "10",
        "current_category_id": _catId,
        "action_performed_by": _id,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getMyPackage', requestModel, context);
    var responseJSON = json.decode(response.body);
    packageItems = responseJSON['decodedData']['result'];
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchMyPackaged(context, "0");
    });
  }

  fetchUserEmail() async {
    email = (await MyUtils.getSharedPreferences("email")) ?? "";
    setState(() {});
    print(email + "hgefy");
  }

  _fetchInvoiceUrl(BuildContext context, String orderNumber) async {
    APIDialog.showAlertDialog(context, "Please Wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var data = {
      "method_name": "getOrderPDF",
      "data": {
        "order_number": orderNumber,
        "user_id": _id,
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

    if (responseJSON['decodedData']['status'].toString() == 'success') {
      String urlStr = responseJSON['decodedData']['result'].toString();
      if (urlStr.isEmpty) {
        Toast.show("Invoice Not Found!!!",
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      } else {
        _showProgressDialog(urlStr, orderNumber);
      }
      // _showProgressDialog("https://www.africau.edu/images/default/sample.pdf",orderNumber);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _showProgressDialog(String fileUrl, String orderNumber) async {
    ProgressDialog pd = ProgressDialog(context: context);

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if (statuses[Permission.storage]!.isGranted) {
      pd.show(
          max: 100,
          msg: 'File Downloading...',
          progressType: ProgressType.valuable,
          completed: Completed(
              completedMsg: "Downloading Done !",
              completedImage: const AssetImage('assets/ic_dn_complt.png'),
              completionDelay: 2500),
          backgroundColor: Colors.white,
          progressValueColor: AppTheme.primarySwatch.shade800,
          progressBgColor: AppTheme.primarySwatch.shade50,
          msgColor: AppTheme.blueColor,
          valueColor: AppTheme.blueColor);
      var dir = await getApplicationDocumentsDirectory();
      if (dir != null) {
        String savename = "klubba$orderNumber.pdf";
        String savePath = dir.path + "/$savename";
        print(savePath);
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(fileUrl, savePath,
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
          pd.update(value: 100, msg: "Error!! Downloading Failed...");
        }
      }
    } else {
      Toast.show("No permission to read and write.",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}
