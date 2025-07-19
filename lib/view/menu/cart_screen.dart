import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/payment/select_address_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';

class CartScreen extends StatefulWidget {
  bool firstScreen;
  CartScreen(this.firstScreen);
  CartState createState() => CartState();
}

class CartState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  bool kandyCheckbox = false;
  Map<String, dynamic> couponDetails = {};
  String kandyAmount = '';
  var kandyAmountController = TextEditingController();
  int kandyAmoutAsInt = 0;
  String imageBaseUrl = '';
  List<dynamic> taxList = [];
  String subTotal = '',
      discount = '',
      netPrice = '',
      netPay = '',
      savings = '',
      finalAmountCopy = '',
      finalAmount = '';
  Map<String, dynamic> shippingDetails = {};

  var couponController = TextEditingController();
  String? couponCode;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () {
            if(widget.firstScreen)
            {
              appExitDialog();
            }
            else
            {
              Navigator.pop(context);
            }
          },
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
      body: WillPopScope(
        onWillPop: () {

          if(widget.firstScreen)
            {
              appExitDialog();
            }
          else
            {
              Navigator.pop(context);
            }
          return Future.value(true);
        },

        child: isLoading
            ? Center(
          child: Loader(),
        )
            : cartItems.length == 0
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [


            Center(child: Image.asset("assets/cart_empty.png",width: 140,height: 140)),
            SizedBox(height: 15),


            Center(
              child: Text('Your Cart is Empty ',
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontSize: 13)),
            ),


          ],
        )
            : ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Product ',
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
            SizedBox(height: 5),
            ListView.builder(
                itemCount: cartItems.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int pos) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(4)),
                        padding: EdgeInsets.only(
                            left: 8, right: 6, top: 10, bottom: 7),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  image: cartItems[pos]['image'] == ''
                                      ? const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/ic_no_photo.png"))
                                      : DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          imageBaseUrl +
                                              cartItems[pos]
                                              ['image']))),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(cartItems[pos]['product_name'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                    SizedBox(height: 27),
                                    Row(
                                      children: [
                                        cartItems[pos]['product_type'] ==
                                            'primary'
                                            ? Row(
                                          children: [
                                            Text("Qty: ",
                                                style: TextStyle(
                                                    color: AppTheme
                                                        .blueColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize: 13)),
                                            Text("1",
                                                style: TextStyle(
                                                    color:
                                                    Colors.black,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize: 13)),
                                          ],
                                        )
                                            : Container(
                                          width: 62,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                child: Image.asset(
                                                  'assets/minus_ic.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                onTap: () {





                                                  if (cartItems[pos][
                                                  'quantity'] !=
                                                      1) {
                                                    updateCount(
                                                        cartItems[
                                                        pos],
                                                        0);
                                                  }
                                                },
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                  cartItems[pos]
                                                  ['quantity']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors
                                                          .black)),
                                              SizedBox(width: 6),
                                              GestureDetector(
                                                child: Image.asset(
                                                  'assets/plus_ic.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                onTap: () {
                                                  updateCount(
                                                      cartItems[pos],
                                                      1);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 27),
                                        GestureDetector(
                                          child: Icon(Icons.delete_rounded,
                                              color: AppTheme.blueColor,
                                              size: 20),
                                          onTap: () {

                                            if(cartItems[pos]["product_type"]=="assessment")
                                              {
                                                showProductRemoveDialog(
                                                    cartItems[pos]
                                                    ['product_id']
                                                    ,
                                                    cartItems[pos]
                                                    ['product_type']);
                                              }
                                            else
                                              {
                                                showProductRemoveDialog(
                                                    cartItems[pos]
                                                    ['product_details']
                                                    ['slug'],
                                                    cartItems[pos]
                                                    ['product_type']);
                                              }





                                          },
                                        ),
                                        Spacer(),
                                        Text(
                                            '₹ ' +
                                                cartItems[pos]['price']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  );
                }),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Promo ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.5)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('Code',
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                        controller: couponController,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter Promo Code',
                          contentPadding: EdgeInsets.only(left: 15),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        )),
                  ),
                ),
                couponCode == null
                    ? GestureDetector(
                  onTap: () {
                    if (couponController.text.isEmpty) {
                      Toast.show('Coupon name cannot be blank!!',
                          duration: Toast.lengthShort,
                          gravity: Toast.bottom,
                          backgroundColor: Colors.blue);
                    } else {
                      applyCoupon(context);
                    }
                  },
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: const BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5))),
                    child: const Center(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 18),
                        child: Text('Apply',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    showCouponRemoveDialog();
                  },
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: const BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5))),
                    child: const Center(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 18),
                        child: Text('Remove',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      kandyAmountController.text="";
                      setState(() {
                        kandyCheckbox = !kandyCheckbox;
                      });

                      if (!kandyCheckbox) {
                        int amount =
                            int.parse(finalAmount) + kandyAmoutAsInt;
                        finalAmount = amount.toString();
                        kandyAmoutAsInt = 0;
                        setState(() {});
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: kandyCheckbox
                          ? Icon(Icons.check_box,
                          color: AppTheme.themeColor)
                          : Icon(Icons.check_box_outline_blank),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(kandyAmount + ' Klubba Kandy Available',
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ],
              ),
            ),
            SizedBox(height: 7),
            kandyCheckbox
                ? Row(
              children: [
                Container(
                  height: 45,
                  width: 120,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                      controller: kandyAmountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Kandy',
                        contentPadding:
                        EdgeInsets.only(left: 10, bottom: 10),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    int inputValue =
                    int.parse(kandyAmountController.text);
                    if (inputValue % 100 != 0) {
                      Toast.show(
                          'Klubba kandies can be redeemed in the multiple of 100 only',
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                          backgroundColor: Colors.red);
                    } else if (inputValue >
                        int.parse(kandyAmount)) {
                      Toast.show(
                          'You do not have ' +
                              inputValue.toString() +
                              ' kandies, you can earn more by refer and earn program',
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                          backgroundColor: Colors.red);
                    } else {
                      double kandyAmoutAsInt22 =
                      (int.parse(kandyAmountController.text) /
                          100);
                      int finalAmountAsString =
                          int.parse(finalAmountCopy) -
                              kandyAmoutAsInt22.toInt();
                      finalAmount =
                          finalAmountAsString.toString();
                      kandyAmoutAsInt = kandyAmoutAsInt22.toInt();
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: const BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5))),
                    child: const Center(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 18),
                        child: Text('Use',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                )
              ],
            )
                : Container(),
            kandyCheckbox
                ? Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Text(
                  'You can save ₹ ' + kandyAmoutAsInt.toString(),
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.5)),
            )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Price ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.5)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('Detail',
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sub Total',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  Text('₹ ' + subTotal,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black))
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  Text('₹ ' + discount,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Net Price(Ex. of Taxes)',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  Text('₹ ' + netPrice,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
            ),

            /*   sgstPrice == 'NO TAX'
                        ? Container()
                        : const SizedBox(height: 10),
                    sgstPrice == 'NO TAX'
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('CGST(9%)',
                                    style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                Text('₹ ' + cgstPrice,
                                    style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                    sgstPrice == 'NO TAX'
                        ? Container()
                        : const SizedBox(height: 10),
                    sgstPrice == 'NO TAX'
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('SGST(9%)',
                                    style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                Text('₹ ' + sgstPrice,
                                    style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                              ],
                            ),
                          ),



*/

            ListView.builder(
                padding: EdgeInsets.only(left: 12, right: 12, top: 10),
                itemCount: taxList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int pos) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              taxList[pos]['label'] +
                                  '(' +
                                  taxList[pos]['tax_rate'].toString() +
                                  ')',
                              style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(
                              '₹ ' +
                                  taxList[pos]['amount']
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }),

            kandyAmoutAsInt==0?Container():
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kandy Discount',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  Text('₹ ' + kandyAmoutAsInt.toString(),
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
            ),


            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Net Payable',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  taxList.length == 0
                      ? Text('₹ 0',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                      : Text('₹ ' + finalAmount,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 82,
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFF3F3F3),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Lottie.asset('assets/cart_animation.json'),
                  Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text('Your Total Savings on this order',
                              style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          SizedBox(height: 5),
                          Text(
                              kandyAmoutAsInt!=0?
                              '₹ ' +
                                  kandyAmoutAsInt.toString():

                              '₹ ' + savings,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.blueColor)),
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(height: 35),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 35),
              child: ElevatedButton(
                  child: Text('Checkout',
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
                    int amount = 0;
                    if (taxList.length == 0) {
                      amount = int.parse(subTotal);
                      AppModel.setKandyDiscount(
                          amount.toString());
                    }

                    if (kandyCheckbox) {
                      AppModel.setKandySelectValue(true);
                      AppModel.setKandyDiscount(
                          kandyAmoutAsInt.toString());
                    }


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectAddressScreen(
                            shippingDetails, amount,taxList.length==0?true:false),
                      ),
                    ).then((value) {
                      _fetchCartList(context);
                    });







                    /*           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectAddressScreen(
                                        shippingDetails, amount,taxList.length==0?true:false)));*/
                  }),
            ),
            const SizedBox(height: 25),
          ],
        ),
      )
    );
  }

  _fetchCartList(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    //  APIDialog.showAlertDialog(context, 'Getting Cart Items...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var data = {
      "method_name": "getCart",
      "data": {
        "current_role": currentRole,
        "slug": AppModel.slug,
        "current_category_id": null,
        "action_performed_by": null
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getCart', requestModel, context);
    var responseJSON = json.decode(response.body);
    cartItems = responseJSON['decodedData']['result']['cart_items'];
    subTotal = responseJSON['decodedData']['result']['sub_total'].toString();
    finalAmount = responseJSON['decodedData']['result']['total'].toString();
    finalAmountCopy = responseJSON['decodedData']['result']['total'].toString();
    discount =
        responseJSON['decodedData']['result']['discount'].toStringAsFixed(2);
    netPrice = responseJSON['decodedData']['result']['taxable_total']
        .toStringAsFixed(2);

    taxList = responseJSON['decodedData']['result']['taxs'];

    /* if (responseJSON['decodedData']['result']['taxs'].length != 0) {
      cgstPrice = responseJSON['decodedData']['result']['taxs'][0]['amount']
          .toStringAsFixed(2);
      sgstPrice = responseJSON['decodedData']['result']['taxs'][0]['amount']
          .toStringAsFixed(2);
    } else {
      cgstPrice = 'NO TAX';
      sgstPrice = 'NO TAX';
    }
*/
    savings =
        responseJSON['decodedData']['result']['discount'].toStringAsFixed(2);
    netPay = responseJSON['decodedData']['result']['total'].toString();
    shippingDetails = responseJSON['decodedData']['result']['billing_info'];
    couponCode = responseJSON['decodedData']['result']['coupon_code'];
    // couponDetails = responseJSON['decodedData']['result']['coupon_code'];
    imageBaseUrl = responseJSON['decodedData']['result']['image_prefix'];
    if (couponCode != null) {
      couponController.text = couponCode!;
      // finalAmount=(int.parse(finalAmount)-responseJSON['decodedData']['result']['coupon_amount']).toString();
    }

    isLoading = false;
    setState(() {});
    print(responseJSON);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchKandy(context);
    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchCartList(context);
    });
  }

  applyCoupon(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Applying coupon...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var data = {
      "method_name": "applyCoupon",
      "data": {
        "coupon_code": couponController.text,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": null,
        "action_performed_by": null
      }
    };

    print(data.toString());
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('applyCoupon', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      _fetchCartList(context);
      // success

    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  fetchKandy(BuildContext context) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getKandyDetails",
      "data": {
        "_id": id,
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
        await helper.postAPI('getKandyDetails', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if(responseJSON['decodedData']['status']!="error")
      {
        kandyAmount = responseJSON['decodedData']['result']['available'].toString();
      }

    setState(() {});
  }

  showProductRemoveDialog(String productSlug, String productType) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
        removeProduct(productSlug, productType);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Product?"),
      content: Text("Are you sure you want to remove this item ?"),
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

  showCouponRemoveDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remove"),
      onPressed: () {
        Navigator.pop(context);
        removeCoupon();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Remove Promo code?"),
      content: Text("Are you sure you want to remove this Promo code ?"),
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

  removeCoupon() async {
    APIDialog.showAlertDialog(context, 'Removing coupon...');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "removeCoupon",
      "data": {
        "coupon_code": "",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('removeCoupon', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      couponController.text="";

      _fetchCartList(context);
      // success

    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  removeProduct(String productSlug, String productType) async {
    APIDialog.showAlertDialog(context, "Removing Product...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "removeCartItem",
      "data": {
        "slug": AppModel.slug,
        "product_slug": productSlug,
        "product_type": productType,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('removeCartItem', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
      _fetchCartList(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }

  updateCount(Map<String, dynamic> productData, int operation) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    int productQuantity;
    if (operation == 1) {
      productQuantity = productData['quantity'];
      productQuantity = productQuantity + 1;
    } else {
      productQuantity = productData['quantity'];
      productQuantity = productQuantity - 1;
    }

    var data = {
      "method_name": "updateCartItem",
      "data": {
        "slug": AppModel.slug,
        "product_slug": productData["product_type"]=="assessment"?productData['product_id']:productData['product_details']
        ['slug'],
        "product_type": productData['product_type'],
        "quantity": productQuantity,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('updateCartItem', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      _fetchCartList(context);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }


  appExitDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600
      )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Exit",style: TextStyle(
          color: AppTheme.blueColor,
          fontWeight: FontWeight.w600
      )),
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
      title: const Text("Exit App?",style: TextStyle(
          color: AppTheme.blueColor,
          fontWeight: FontWeight.w600
      )),
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
