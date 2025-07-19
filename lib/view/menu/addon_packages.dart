

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';
import 'cart_screen.dart';

class addOnPackages extends StatefulWidget{
  _addOnPackages createState()=>_addOnPackages();
}
class _addOnPackages extends State<addOnPackages>{
  List<dynamic> packagesList = [];
  bool isLoading = true;
  bool _fromTop = true;

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
                text: 'Add On ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Package',
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
      body: isLoading ? Center(
        child: Loader(),
      ) : packagesList.length==0?
      Center(
        child: Text('No Add On Package Available'),
      ): ListView(
        children: [
          SizedBox(height: 5),
          ListView.builder(
              itemCount: packagesList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int pos){
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.35,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: AppTheme.gratitudeBg
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: AppTheme.greenColor
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                              child: const Text("Best Plan",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Text("Price",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.blueColor
                          ),),
                          const SizedBox(height: 5,),
                          Text("₹ "+packagesList[pos]['package_mrp'].toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,

                          ),),
                          const SizedBox(height: 5,),



                        ],
                      ),


                    ),

                    Container(
                      width: MediaQuery.of(context).size.width*0.619,
                      height: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: AppTheme.gratitudeBg
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(packagesList[pos]['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black,
                            ),),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(flex: 1,child: InkWell(
                                  onTap: ()=>{
                                    _showDetailsDialog(pos)
                                  },
                                  child: const Text("View Details",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.blueColor,
                                      decoration: TextDecoration
                                          .underline,
                                    fontSize: 12
                                  ),),
                                ),),
                                Expanded(flex: 1,child: InkWell(
                                  onTap: ()=>{
                                    _showDetailsDialog(pos)
                                  },
                                  child: Container(
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const Text("Buy Now",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),),
                                  ),
                                ),)
                              ],
                            )

                          ],
                        ),
                      ),
                    )
                  ],

                ),);

              })
        ],
      ),

    );
  }


  _fetchPackagesDetails(BuildContext context) async{
    setState(() {
      isLoading=true;
    });

    APIDialog.showAlertDialog(context, "Please wait...");
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getAddonPackageOnRole",
      "data": {
        "current_role": role,
        "slug": AppModel.slug,
        "current_category_id": catId,
        "action_performed_by": id,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getTransactions', requestModel, context);
    var responseJSON = json.decode(response.body);


    if(responseJSON['decodedData']['status']=='success'){
      packagesList.clear();

      List<dynamic> smsList=[];
      List<dynamic> emailList=[];
      List<dynamic> spaceList=[];
      List<dynamic> premimumList=[];
      List<dynamic> hotList=[];
      List<dynamic> exclusiveList=[];

      smsList=responseJSON['decodedData']['result']['sms_package_list'];
      emailList=responseJSON['decodedData']['result']['email_package_list'];
      spaceList=responseJSON['decodedData']['result']['space_package_list'];
      premimumList=responseJSON['decodedData']['result']['premium_package_list'];
      hotList=responseJSON['decodedData']['result']['hot_package_list'];
      exclusiveList=responseJSON['decodedData']['result']['exclusive_package_list'];
      for(int i=0;i<smsList.length;i++){
        packagesList .add(smsList[i]);
      }
      for(int i=0;i<emailList.length;i++){
        packagesList .add(emailList[i]);
      }
      for(int i=0;i<spaceList.length;i++){
        packagesList .add(spaceList[i]);
      }
      for(int i=0;i<premimumList.length;i++){
        packagesList .add(premimumList[i]);
      }
      for(int i=0;i<hotList.length;i++){
        packagesList .add(hotList[i]);
      }
      for(int i=0;i<exclusiveList.length;i++){
        packagesList .add(exclusiveList[i]);
      }
    }


    Navigator.of(context).pop();
    isLoading = false;
    setState(() {

    });

    print(packagesList);

  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchPackagesDetails(context);
    });
  }

  _showDetailsDialog(int pos) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25),),
                      color: AppTheme.primarySwatch.shade400
                    ),
                    child: Column(

                      children: [
                        Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
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
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(packagesList[pos]['title'],
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("₹ "+packagesList[pos]['package_mrp'].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text("Plan ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Text("Benefits",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 5,
                        margin: EdgeInsets.only(left: 50),
                        width: 50,
                        color: AppTheme.themeColor,
                        alignment: Alignment.topLeft,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Padding(padding: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    children: [
                      Text("Pack Validity",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),),
                      Spacer(),
                      Text(packagesList[pos]['membership_duration'].toString()+" "+packagesList[pos]['membership'].toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),),

                    ],
                  ),),
                  SizedBox(height: 10),
                  Padding(padding: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    children: [
                      packagesList[pos]['package_type']=='space'?Text("Space Size",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),):
                      Text("Count",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),),
                      Spacer(),
                      packagesList[pos]['package_type']=='space'? Text(packagesList[pos]['count'].toString()+" MB",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),):
                      Text(packagesList[pos]['count'].toString().toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),),

                    ],
                  ),),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Buy Now',
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
                          Navigator.pop(context);
                          _addToCartPackage(context, pos);
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


  _addToCartPackage(BuildContext context,int pos) async {
    APIDialog.showAlertDialog(context, 'Package Adding to Cart...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id=await MyUtils.getSharedPreferences('_id');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "addToCart",
      "data": {
        "product_slug": packagesList[pos]['slug'],
        "product_type": packagesList[pos]['package_type'],
        "current_role": currentRole,
        "slug": AppModel.slug,
        "isGuestCheckout":0,
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CartScreen(false)));
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}