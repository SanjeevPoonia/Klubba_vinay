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

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';

class ProDialogScreen extends StatefulWidget {
  DialogState createState() => DialogState();
}

class DialogState extends State<ProDialogScreen> {
  List<dynamic> packageList = [];
  List<dynamic> packageFeatureList = [];
  StateSetter? dialogStateGlobal;
  List<dynamic> featureListId = [];
  List<dynamic> packFeatures = [];
  bool isLoading = false;
  late PageController _pageController;
  int activePage = 0;

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
    _pageController = PageController(viewportFraction: 1.0, initialPage: 0);
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
            child: StatefulBuilder(builder: (context, dialogState) {
              dialogStateGlobal=dialogState;
              return Align(
                alignment: Alignment.center,
                child:Stack(
                  children: [
                    SizedBox(
                      //  width: MediaQuery.of(context).size.width,
                      height: 546,
                      child: PageView.builder(
                          itemCount: packageList.length,
                          pageSnapping: true,
                          controller: _pageController,
                          onPageChanged: (page) {

                            dialogState(() {
                              activePage = page;
                            });
                            updateFeaturesList(activePage);
                          },
                          itemBuilder: (context, pagePosition) {
                            bool active = pagePosition == activePage;
                            return slider(packageList, pagePosition, active);
                          }),
                    ),
                    Container(
                      height: 546,
                      child: Column(
                        children: [
                          Spacer(),
                          Container(
                            transform:
                            Matrix4.translationValues(0.0, -25.0, 0.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                indicators(packageList.length, activePage)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            onWillPop: () {
              return Future.value(false);
            });
      },
    );
  }
  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 8 : 8;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5)),
        ),
      child: Card(
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
                    Text(packageList[pagePosition]["discount_price"]==0?"":'₹',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.5)),
                    Text(



                      packageList[pagePosition]["discount_price"]==0?"Free":
                        packageList[pagePosition]['package_mrp'].toString() +
                            '.00',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 27)),
                  ],
                ),
                Center(
                  child: Text(packageList[pagePosition]["membership"].toString().toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.5)),
                ),
                SizedBox(height: 15),
                Center(
                    child: Text(packageList[pagePosition]["title"],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 17))),
                SizedBox(height: 5),

                Row(
                  children: [
                    Text('Features',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                  ],
                ),



                SizedBox(height: 18),


                Container(
                  height: 210,
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: packFeatures.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context,int pos)

                    {

                     return Column(
                       children: [

                         Row(
                           children: [
                             Container(
                            //   height: 37,
                               padding: EdgeInsets.symmetric(horizontal: 11,vertical: 11),
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(4),
                                   color: AppTheme.themeColor.withOpacity(0.65)),
                               child:Row(
                                 children: [

                                   Text(packFeatures[pos]["feature"],
                                       style: TextStyle(
                                           color: AppTheme.blueColor,
                                           fontWeight: FontWeight.w600,
                                           fontSize: 12.5)),

                                 ],
                               )
                             ),
                           ],
                         ),

                     /*    Divider(
                           color: Colors.grey.withOpacity(0.3),
                         )
                    */


                         SizedBox(height: 5)


                       ],
                     );

                    }


                    ),
                  ),
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
                              child: Text('Back',
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
                            Navigator.pop(context);
                            Navigator.pop(context);
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
                                  _addToCartPackage(context,packageList[pagePosition]["slug"]);
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
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(5),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? AppTheme.themeColor
                : Colors.grey.withOpacity(0.45),
            shape: BoxShape.circle),
      );
    });
  }
  _addToCartPackage(BuildContext context,String productSlug) async {
    APIDialog.showAlertDialog(context, 'Package Adding to Cart...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    String? id = await MyUtils.getSharedPreferences('_id');
    var data = {
      "method_name": "addToCart",
      "data": {
        "product_slug": productSlug,
        "product_type": "primary",
        "isGuestCheckout":0,
        "current_role": currentRole,
        "slug": AppModel.slug,
        "current_category_id": catId!=null?catId:null,
        "action_performed_by": id!=null?id:null
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

      Navigator.push(context,MaterialPageRoute(builder: (context)=>CartScreen(false)));

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
     var data = {
      "method_name": "getMembershipPackageOnRole",
      "data": {
        "current_role": currentRole,
        "slug": AppModel.slug,
      }
    };

   /* var data = {
      "method_name": "getMembershipPackageOnRole",
      "data": {
        "slug": "ankit-pareek",
        "current_role": "5d4d4f960fb681180782e4f4"
      }
    };*/

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

      if(featureListId.length!=0)
      {
        featureListId.clear();
      }
      if(packFeatures.length!=0)
      {
        packFeatures.clear();
      }



      if(packageList.length!=0)
        {
          featureListId = packageList[0]['features_id'];
          for (int i = 0; i < packageFeatureList.length; i++) {
            if (featureListId.contains(packageFeatureList[i]['_id'])) {
              packFeatures.add(packageFeatureList[i]);
            }
          }

          _showPackageDialog();
        }
      else
        {

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LandingScreen()));
        }






     // print(packFeatures);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    }
  }

  updateFeaturesList(int pos){
    if(packFeatures.length!=0)
    {
      packFeatures.clear();
    }
    featureListId = packageList[pos]['features_id'];

    for (int i = 0; i < packageFeatureList.length; i++) {
      if (featureListId.toString().contains(packageFeatureList[i]['_id'])) {
        packFeatures.add(packageFeatureList[i]);
      }
    }
    print(packFeatures.length.toString()+"fgfeg");
    setState(() {

    });
    dialogStateGlobal!(() {

    });
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
