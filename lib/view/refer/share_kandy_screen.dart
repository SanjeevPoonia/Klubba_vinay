import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';

import 'package:toast/toast.dart';

class ShareKandyScreen extends StatefulWidget {
  final String kandy;
  ShareKandyScreen(this.kandy);
  KandyState createState() => KandyState();
}

class KandyState extends State<ShareKandyScreen> {
  bool isLoading = false;
  final _formKeyLogin = GlobalKey<FormState>();
  var friendID = TextEditingController();
  var friendPhoneNumber = TextEditingController();
  var friendKlubbaKandy = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                  text: 'Share ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Klubba Kandy',
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
        body: Form(
          key: _formKeyLogin,
          child: ListView(
            children: [
              SizedBox(height: 25),
              SizedBox(
                  height: 200,
                  child: OverflowBox(
                    minHeight: 320,
                    maxHeight: 320,
                    child: Lottie.asset('assets/share_kandy_animation.json'),
                  )),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                    'Here you can share your kandies with other members',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text('Friend Klubba Id',
                    style: TextStyle(
                        color: AppTheme.blueColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ),
              SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                    validator: checkEmptyString,
                    controller: friendID,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xFFF6F6F6),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 7, bottom: 5),
                        hintText: 'Enter Friend Klubba Id',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text('Friend Mobile Number',
                    style: TextStyle(
                        color: AppTheme.blueColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ),
              SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                    controller: friendPhoneNumber,
                    validator: phoneValidator,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xFFF6F6F6),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 7, bottom: 5),
                        hintText: 'Enter Friend Mobile Number',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text('Klubba Kandy',
                    style: TextStyle(
                        color: AppTheme.blueColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ),
              SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                    controller: friendKlubbaKandy,
                    validator: checkEmptyString,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xFFF6F6F6),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 7, bottom: 5),
                        hintText: 'Enter Share Klubba Kandy Quantity',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 30),
              Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                    child: Text('Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(
                                widget.kandy=="0"?Colors.grey:

                                Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ))),
                    onPressed: () {


                      if(widget.kandy=="0")
                        {
                          Toast.show("There is no Kandy available in your account!",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red);
                        }
                      else
                        {
                          _submitHandler(context);
                        }


                    }),
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKeyLogin.currentState!.validate()) {
      return;
    }
    _formKeyLogin.currentState!.save();
    shareKandyWithFriend(context);
  }

  _shareDialog() {
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
                  SizedBox(height: 25),
                  SizedBox(
                      height: 200,
                      child: OverflowBox(
                        minHeight: 320,
                        maxHeight: 320,
                        child:
                            Lottie.asset('assets/share_success_animation.json'),
                      )),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        'Congratulations!! you have successfully Shared 200 Klubba Kandy',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.blueColor,
                        ),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('simply dummy text of the printing',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: EdgeInsets.only(
                        left: 40, right: 40, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Back to Refer & Earn',
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
                        onPressed: () => null),
                  ),
                  SizedBox(height: 15),
                ],
              ),
              margin: EdgeInsets.only(top: 22),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, true ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  String? phoneValidator(String? value) {
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!)) {
      return 'Enter a valid Mobile Number';
    }
    return null;
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  shareKandyWithFriend(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please wait...');
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name": "shareKandy",
      "data": {
        "sender": id,
        "receiver": friendID.text,
        "points": friendKlubbaKandy.text,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": null,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('shareKandy', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    /* totalKandy = responseJSON['decodedData']['result']['total'].toString();
    AvailableKandy = responseJSON['decodedData']['result']['available'].toString();*/
    isLoading = false;
    setState(() {});
    print(responseJSON);
  }
}
