import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/utils/payData.dart';
import 'package:klubba/utils/urlList.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/payment/payment_success_screen.dart';
import 'dart:convert' show base64, json, jsonDecode, utf8;
import 'package:http/http.dart' as http;
import 'package:klubba/view/payment/webview_page.dart';

import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

class SelectAddressScreen extends StatefulWidget {
  Map<String, dynamic> shippingDetails;
  int kandyAmount;
  bool amountZero;

  SelectAddressScreen(this.shippingDetails, this.kandyAmount, this.amountZero);

  CartState createState() => CartState();
}

class CartState extends State<SelectAddressScreen> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var mobileNumberController = TextEditingController();
  var emailController = TextEditingController();
  var addressLine1Controller = TextEditingController();
  var addressLine2Controller = TextEditingController();
  var pinCodeController = TextEditingController();
  var cityController = TextEditingController();
  var stateNameController = TextEditingController();
  var businessNameController = TextEditingController();
  var gstNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool gstCheckbox = false;

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
                  text: 'Your ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Cart',
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
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Billing ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text('Information',
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
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('First Name*',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: firstNameController,
                    validator: checkEmptyString,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'First Name',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Last Name*',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: lastNameController,
                    validator: checkEmptyString,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'Last Name',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Mobile Number*',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: mobileNumberController,
                    validator: phoneValidator,
                    enabled: false,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('E-mail',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: emailController,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'Enter email',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Address Line 1*',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: addressLine1Controller,
                    validator: checkEmptyString,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'Address line 1',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Address Line 2',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: addressLine2Controller,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'Address line 2',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Pincode*',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: pinCodeController,
                    validator: checkPincode,
                    onChanged: (String value) async {
                      if (value.toString().length == 6) {
                        validatePinCode(true);
                      }
                    },
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'Enter Pincode',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('City',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    enabled: false,
                    controller: cityController,
                    validator: checkEmptyString,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        errorStyle: TextStyle(
                          color: Theme.of(context)
                              .errorColor, // or any other color
                        ),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'City',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('State',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    enabled: false,
                    controller: stateNameController,
                    validator: checkEmptyString,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        errorStyle: TextStyle(
                          color: Theme.of(context)
                              .errorColor, // or any other color
                        ),
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'State',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Container(
                        child: gstCheckbox
                            ? Icon(Icons.check_box, color: AppTheme.themeColor)
                            : Icon(Icons.check_box_outline_blank),
                      ),
                      onTap: () {
                        setState(() {
                          gstCheckbox = !gstCheckbox;
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                          'Do you need a tax invoice in a different entity\'s name ?',
                          style: TextStyle(
                              color: AppTheme.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                  ],
                ),
              ),
              gstCheckbox
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Business Name*',
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
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                                validator: checkEmptyString,
                                controller: businessNameController,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xFFF6F6F6),
                                    filled: true,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: 'Enter business name',
                                    hintStyle: TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xFF9A9CB8),
                                    ))),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('GSTIN Registration No.*',
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
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                                validator: (value) =>
                                    value!.isEmpty || value.length != 15
                                        ? "Enter a valid GST Number"
                                        : null,
                                controller: gstNumberController,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xFFF6F6F6),
                                    filled: true,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: 'Enter GSTIN',
                                    hintStyle: TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xFF9A9CB8),
                                    ))),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 27),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 35),
                child: ElevatedButton(
                    child: Text('Make Payment',
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
                      _submitHandler(context);
                    }),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ));
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    updateBillingAddress(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameController.text = widget.shippingDetails['first_name'];
    lastNameController.text = widget.shippingDetails['last_name'];
    mobileNumberController.text = widget.shippingDetails['mobile_number'];
    emailController.text = widget.shippingDetails['email'];
    addressLine1Controller.text = widget.shippingDetails['address_line_1'];
    addressLine2Controller.text = widget.shippingDetails['address_line_2'];
    pinCodeController.text = widget.shippingDetails['post_code'].toString();
    validatePinCode(false);
    /* cityController.text = widget.shippingDetails['city_name'];
    stateNameController.text = widget.shippingDetails['state_name'];*/

    /*  if(stateNameController.text=="")
      {
        pinCodeController.text="";
      }*/
  }

  String? checkPincode(String? value) {
    if (value!.length < 6) {
      return 'Invalid Pincode';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!)) {
      return 'Enter a valid Mobile Number';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  updateBillingAddress(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Saving address...');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    //"address_line_2": addressLine2Controller.text,
    var data = {
      "method_name": "updateBillingAddress",
      "data": {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "post_code": pinCodeController.text.toString(),
        "address_line_1": addressLine1Controller.text,
        "email": emailController.text,
        "mobile_number": mobileNumberController.text.toString(),
        "slug": AppModel.slug,
        "pinCodeDetails": "",
        "have_different_name": gstCheckbox ? 1 : 0,
        "business_name": businessNameController.text,
        "gstin_registration_no": gstNumberController.text,
        "current_role": currentRole,
        "current_category_id": catId!=null?catId:null,
        "action_performed_by": id!=null?id:null
      }
    };

    print(data.toString());
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    print("Base 64");
    print(requestModel.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('updateBillingAddress', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
      updateCartAddress(context);


      // success
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }



  updateCartAddress(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Verifying address...');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    //"address_line_2": addressLine2Controller.text,
    var data = {
      "method_name": "getCart",
      "data": {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "post_code": pinCodeController.text.toString(),
        "address_line_1": addressLine1Controller.text,
        "email": emailController.text,
        "mobile_number": mobileNumberController.text.toString(),
        "slug": AppModel.slug,
        "pinCodeDetails": "",
        "have_different_name": gstCheckbox ? 1 : 0,
        "business_name": businessNameController.text,
        "gstin_registration_no": gstNumberController.text,
        "current_role": currentRole,
        "current_category_id": catId!=null?catId:null,
        "action_performed_by": id!=null?id:null
      }
    };

    print(data.toString());
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    print("Base 64");
    print(requestModel.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('getCart', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {

      placeOrder(context);


      // success
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  placeOrder(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Placing order...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "placeOrder",
      "data": {
        "date": null,
        "slot":
    AppModel.slotDataList.length==0?

        null:AppModel.slotDataList,
        "payment_method": "cash",
       /* "klubbaKandyDiscount":AppModel.kandyDiscount==""?false:true,*/
        "afterKandyAmount": AppModel.kandyDiscount == ""
            ? "0"
            : int.parse(AppModel.kandyDiscount),
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId!=null?catId:null,
        "action_performed_by": id!=null?id:null
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('placeOrder', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      AppModel.setSlotData([]);
      if (responseJSON['decodedData']['result']['payment_required'] == 0) {
        AppModel.setKandyDiscount("");
        MyUtils.saveSharedPreferences("current_package", "wertet");
        Toast.show('Package has been purchased successfully !!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        MyUtils.saveSharedPreferences("current_package", "wertet");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => PaymentSuccessScreen(
                    responseJSON['decodedData']['result']['order_id'])),
            (Route<dynamic> route) => false);
      }
      /*   else if(widget.amountZero)
        {
          AppModel.setKandyDiscount(
              "");
          MyUtils.saveSharedPreferences("current_package", "wertet");
          Toast.show('Order placed Successfully !!',
              duration: Toast.lengthShort,
              gravity: Toast.bottom,
              backgroundColor: Colors.green);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => PaymentSuccessScreen(
                      responseJSON['decodedData']['result']['order_id'])),
                  (Route<dynamic> route) => false);
        }*/

      else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => WebviewPage(
                    responseJSON['decodedData']['result']['payment_key'],
                    responseJSON['decodedData']['result']['payment_enc'],
                    responseJSON['decodedData']['result']['order_id'])));
      }
    } else {
      Toast.show(responseJSON['decodedData']["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    // coachGalleryData = responseJSON['decodedData']['result']['coach_gallery'];

    setState(() {});
    print(responseJSON);
  }

  validatePinCode(bool showLoader) async {
    if (showLoader) {
      APIDialog.showAlertDialog(context, "Validating Pincode");
    }

    var data = {
      "method_name": "checkPinCode",
      "data": {
        "pin_code": pinCodeController.text.toString(),
        "slug": AppModel.slug,
        "current_role": "5d4d4f960fb681180782e4f4",
        "current_category_id": null,
        "action_performed_by": null
      }
    };

    print(data.toString());

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('checkPinCode', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (showLoader) {
      Navigator.pop(context);
    }

    if (responseJSON['decodedData']['status'] == 'success') {
      stateNameController.text =
          responseJSON['decodedData']['result']['state_name'];
      cityController.text = responseJSON['decodedData']['result']['city_name'];
      setState(() {});

      if (showLoader) {
        Toast.show("Pincode validated successfully!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
      }
    } else {
      stateNameController.text = '';
      cityController.text = '';
      setState(() {});
      Toast.show("Invalid Pincode",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}
