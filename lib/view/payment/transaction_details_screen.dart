import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/heading_text_widget.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';

import 'package:dio/dio.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class TransactionDetail extends StatefulWidget {
  final String orderId;
  final int oderStatus;
  const TransactionDetail(this.orderId,this.oderStatus, {
    super.key
  });
  TransactionState createState() => TransactionState();
}

class TransactionState extends State<TransactionDetail> {
  List<dynamic> orderItems = [];

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
                text: 'Transaction ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Details',
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
      body: isLoading ? Center( child: Loader(),):orderItems.length==0?Center(child: Text('Order Details Not Found'),):
      Column(
       children: [
         SizedBox(height: 5),
         Expanded(
           child: ListView.builder(
               itemCount: orderItems.length,
               scrollDirection: Axis.vertical,
               itemBuilder: (BuildContext context,int pos){
                 List<dynamic> orders=[];
                 List<dynamic> ordersTransactions=[];
                 List<dynamic> taxs=[];

                 orders=orderItems[pos]['order_items'];
                 ordersTransactions=orderItems[pos]['order_transactions'];
                 taxs=orderItems[pos]['taxs'];
                 return Column(
                   children: [
                     HeadingTextWidget('Product ', 'Details'),
                     SizedBox(height: 10),

                     Container(
                       height: MediaQuery.of(context).size.height*0.4,
                       child: Column(
                         children: [
                           SizedBox(height: 5,),
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
                                                 orders[0]['product_name']??'Product Name',
                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.w500,
                                                     fontSize: 12)),
                                           )),
                                       Padding(
                                         padding: EdgeInsets.only(left: 15, right: 10),
                                         child: Text('₹ '+orders[0]['price'].toString(),
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
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Expanded(
                                         child: Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 10),
                                           child: Column(
                                             children: [
                                               Text('Booking ID',
                                                   style: TextStyle(
                                                       color: AppTheme.blueColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 11)),
                                               Text(orders[0]['_id'],
                                                   style: TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 13)),
                                               SizedBox(height: 10),
                                               Text('Date',
                                                   style: TextStyle(
                                                       color: AppTheme.blueColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 11)),
                                               Text(ordersTransactions[0]['created'],
                                                   style: TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 13)),
                                               SizedBox(height: 10),
                                               Text('Quantity',
                                                   style: TextStyle(
                                                       color: AppTheme.blueColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 11)),
                                               Text(orders[0]['quantity'].toString(),
                                                   style: TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 13)),
                                               SizedBox(height: 10),
                                               Text('Order Status',
                                                   style: TextStyle(
                                                       color: AppTheme.blueColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 11)),
                                               SizedBox(height: 10),
                                               widget.oderStatus==1?
                                               Container(
                                                 height: 28,
                                                 width: 100,
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(2),
                                                     color: Color(0xFF0BB500)),
                                                 child: Center(
                                                   child: Text('Successfully',
                                                       style: TextStyle(
                                                           color: Colors.white,
                                                           fontWeight: FontWeight.w500,
                                                           fontSize: 11)),
                                                 ),
                                               )
                                                   :
                                               Container(
                                                 height: 28,
                                                 width: 100,
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(2),
                                                     color: Color(0xFFEA0A3B)),
                                                 child: Center(
                                                   child: Text('Pending',
                                                       style: TextStyle(
                                                           color: Colors.white,
                                                           fontWeight: FontWeight.w500,
                                                           fontSize: 11)),
                                                 ),
                                               ),

                                               SizedBox(height: 12),
                                             ],
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                           ),
                                         ),
                                         flex: 1),
                                     SizedBox(width: 10),
                                     Expanded(
                                         child: Padding(
                                           padding: EdgeInsets.symmetric(horizontal: 10),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text('Transaction Number',
                                                   style: TextStyle(
                                                       color: AppTheme.blueColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 11)),
                                               Text(ordersTransactions[0]['transaction_number'],
                                                   style: TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 13)),
                                               SizedBox(height: 10),
                                               Text('Payment Method',
                                                   style: TextStyle(
                                                       color: AppTheme.blueColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 11)),
                                               Text(ordersTransactions[0]['payment_type'],
                                                   style: TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 13)),
                                               SizedBox(height: 10),
                                               Text('Per Person',
                                                   style: TextStyle(
                                                       color: AppTheme.blueColor,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 11)),
                                               Text('₹ '+ordersTransactions[0]['amount'].toString(),
                                                   style: TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.w500,
                                                       fontSize: 13)),
                                               SizedBox(height: 10),
                                               SizedBox(height: 25),
                                               orders[0]['status']==0?Align(
                                                   alignment: Alignment.bottomRight,
                                                   child: SizedBox(height: 5,width: 5,)
                                               ):
                                               Align(
                                                 alignment: Alignment.bottomRight,
                                                 child: InkWell(
                                                   onTap: ()=>{
                                                     _fetchInvoiceUrl(context)
                                                   },
                                                   child: Container(
                                                       margin: EdgeInsets.only(right: 10, bottom: 20),
                                                       child: Image.asset('assets/download_ic.png',
                                                           width: 22, height: 22)),
                                                 ),
                                               )
                                             ],
                                           ),
                                         ))
                                   ],
                                 ),
                               ],
                             ),
                           )
                         ],
                       ),
                     ),

                     /*Container(
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
                                           'Drawing Competition (11Th To 12Th Senior- 2)',
                                           style: TextStyle(
                                               color: Colors.white,
                                               fontWeight: FontWeight.w500,
                                               fontSize: 12)),
                                     )),
                                 Padding(
                                   padding: EdgeInsets.only(left: 15, right: 10),
                                   child: Text('₹ 2400.00',
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
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Expanded(
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 10),
                                     child: Column(
                                       children: [
                                         Text('Booking ID',
                                             style: TextStyle(
                                                 color: AppTheme.blueColor,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 11)),
                                         Text('0021010200000002',
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 13)),
                                         SizedBox(height: 10),
                                         Text('Date',
                                             style: TextStyle(
                                                 color: AppTheme.blueColor,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 11)),
                                         Text('18/11/2022',
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 13)),
                                         SizedBox(height: 10),
                                         Text('Quantity',
                                             style: TextStyle(
                                                 color: AppTheme.blueColor,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 11)),
                                         Text('6',
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 13)),
                                         SizedBox(height: 10),
                                         Text('Order Status',
                                             style: TextStyle(
                                                 color: AppTheme.blueColor,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 11)),
                                         SizedBox(height: 10),
                                         Container(
                                           height: 28,
                                           width: 100,
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(2),
                                               color: Color(0xFF0BB500)),
                                           child: Center(
                                             child: Text('Successfully',
                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.w500,
                                                     fontSize: 11)),
                                           ),
                                         ),
                                         SizedBox(height: 12),
                                       ],
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                     ),
                                   ),
                                   flex: 1),
                               SizedBox(width: 10),
                               Expanded(
                                   child: Padding(
                                     padding: EdgeInsets.symmetric(horizontal: 10),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text('Transaction Number',
                                             style: TextStyle(
                                                 color: AppTheme.blueColor,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 11)),
                                         Text('1421010200003805',
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 13)),
                                         SizedBox(height: 10),
                                         Text('Payment Method',
                                             style: TextStyle(
                                                 color: AppTheme.blueColor,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 11)),
                                         Text('Credit Card',
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 13)),
                                         SizedBox(height: 10),
                                         Text('Per Person',
                                             style: TextStyle(
                                                 color: AppTheme.blueColor,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 11)),
                                         Text('₹ 400.00',
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.w500,
                                                 fontSize: 13)),
                                         SizedBox(height: 10),
                                         SizedBox(height: 25),
                                         Align(
                                           alignment: Alignment.bottomRight,
                                           child: Container(
                                               margin: EdgeInsets.only(right: 10, bottom: 20),
                                               child: Image.asset('assets/download_ic.png',
                                                   width: 22, height: 22)),
                                         )
                                       ],
                                     ),
                                   ))
                             ],
                           ),
                         ],
                       ),
                     ),*/
                     SizedBox(height: 5),
                     HeadingTextWidget('Order ', 'Summary'),
                     SizedBox(height: 10),
                     Container(
                       margin: EdgeInsets.symmetric(horizontal: 12),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(4),
                           color: Color(0xFFF3F3F3)),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 Text('Order Number',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                                 Text(orderItems[pos]['order_number'],
                                     style: TextStyle(
                                         fontSize: 13.5,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),
                               ],
                             ),
                           ),

                           const SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 Text('Order Date',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),
                                 Text(orderItems[pos]['order_date'].toString(),
                                     style: TextStyle(
                                         fontSize: 13.5,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                               ],
                             ),
                           ),


                           const SizedBox(height: 10),



                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 Text('Order Status',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),
                                 Text(orderItems[pos]['status'].toString()=="1"?"Success":"Pending",
                                     style: TextStyle(
                                         fontSize: 13.5,
                                         fontWeight: FontWeight.w600,
                                         color:
                                         orderItems[pos]['status'].toString()=="1"?Colors.greenAccent:

                                         Colors.redAccent)),
                               ],
                             ),
                           ),


                           const SizedBox(height: 10),


                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 Text('Total Quantity',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),
                                 Text(orderItems[pos]['total_quantity'].toString(),
                                     style: TextStyle(
                                         fontSize: 13.5,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                               ],
                             ),
                           ),


                           const SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 Text('Total Before Tax',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),
                                 Text('₹ '+orderItems[pos]['taxable_total'].toStringAsFixed(2),
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                               ],
                             ),
                           ),
                           const SizedBox(height: 10),


                           orderItems[pos]['coupon_code']==null?Container():
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 Text('Coupon: '+orderItems[pos]['coupon_code'],
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w500,
                                         color: Colors.black)),
                                 Text('₹ '+orderItems[pos]['coupon_amount'].toStringAsFixed(2),
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                               ],
                             ),
                           ),


                           orderItems[pos]['coupon_code']==null?Container():
                            SizedBox(height: 10),


                           taxs.length==0?Container():
                           Container(
                             height: 50,
                             child: ListView(
                               children: [
                                 ListView.builder(
                                     itemCount: taxs.length,
                                     shrinkWrap: true,
                                     physics: NeverScrollableScrollPhysics(),
                                     scrollDirection: Axis.vertical,
                                     itemBuilder: (BuildContext context,int taxPos){
                                       return Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 8),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children:  [
                                             Text(taxs[taxPos]['label']+"("+taxs[taxPos]['tax_rate']+")",
                                                 style: TextStyle(
                                                     fontSize: 13,
                                                     fontWeight: FontWeight.w500,
                                                     color: Colors.black)),
                                             Text('₹ '+taxs[taxPos]['amount'].toStringAsFixed(2),
                                                 style: TextStyle(
                                                     fontSize: 13,
                                                     fontWeight: FontWeight.w600,
                                                     color: Colors.black)),
                                           ],
                                         ),
                                       );
                                     }) ,


                               ],
                             ),
                           ),

                           /*Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: const [
                                 Text('CGST(9%)',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                                 Text('₹ 09.00',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                               ],
                             ),
                           ),
                           const SizedBox(height: 10),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: const [
                                 Text('SGST(9%)',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                                 Text('₹ 09.00',
                                     style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black)),
                               ],
                             ),
                           ),*/
                           const SizedBox(height: 14),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:  [
                                 Text('Net Payable',
                                     style: TextStyle(
                                         fontSize: 14,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black)),

                                 orderItems[pos]['total'].toString()=="0"?

                                 Text('Free',
                                     style: TextStyle(
                                         fontSize: 14,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black)):
                                 Text('₹ '+orderItems[pos]['total'].toString(),
                                     style: TextStyle(
                                         fontSize: 14,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.black)),
                               ],
                             ),
                           ),
                           const SizedBox(height: 15),
                         ],
                       ),
                     ),
                     SizedBox(height: 5),
                     HeadingTextWidget('Billing ', 'Information'),
                     SizedBox(height: 10),
                     Container(
                       width:MediaQuery.of(context).size.width,
                       padding: EdgeInsets.symmetric(horizontal: 7),
                       margin: const EdgeInsets.symmetric(horizontal: 12),

                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(4),
                           color: Color(0xFFF3F3F3)),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           SizedBox(height: 12),
                           Text('Customer Name',
                               style: TextStyle(
                                   color: AppTheme.blueColor,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 11)),
                           Text(orderItems[pos]['billing_info']['first_name']+" "+orderItems[pos]['billing_info']['last_name'],
                               style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 13)),
                           SizedBox(height: 10),
                           Text('Email',
                               style: TextStyle(
                                   color: AppTheme.blueColor,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 11)),
                           Text(orderItems[pos]['billing_info']['email'],
                               style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 13)),
                           SizedBox(height: 10),
                           Text('Mobile',
                               style: TextStyle(
                                   color: AppTheme.blueColor,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 11)),
                           Text(orderItems[pos]['billing_info']['phone_country_code']+" "+orderItems[pos]['billing_info']['mobile_number'],
                               style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 13)),
                           SizedBox(height: 10),
                           Text('Address',
                               style: TextStyle(
                                   color: AppTheme.blueColor,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 11)),
                           Text(
                               orderItems[pos]['billing_info']['address_line_1']+","+orderItems[pos]['billing_info']['address_line_2']+","+orderItems[pos]['billing_info']['city_name']+","+orderItems[pos]['billing_info']['district_name']+","+orderItems[pos]['billing_info']['state_name']+" "+orderItems[pos]['billing_info']['country']+" "+orderItems[pos]['billing_info']['post_code'],
                               style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 13)),
                           SizedBox(height: 15),
                         ],
                       ),
                     ),
                     SizedBox(height: 20),
                   ],
                 );
               }),
         )
       ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchOrderDetails(context);
    });
  }

  _fetchOrderDetails(BuildContext context) async{
    setState(() {
      isLoading=true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var data = {
      "method_name": "getOrderDetail",
      "data": {
        "current_role": currentRole,
        "slug": AppModel.slug,
        "order_number": widget.orderId,
        "current_category_id": null,
        "action_performed_by": _id,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getOrderDetail', requestModel, context);
    var responseJSON = json.decode(response.body);
    orderItems=responseJSON['decodedData']['result'];
    isLoading = false;
    setState(() {});

  }

  _fetchInvoiceUrl(BuildContext context) async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");
    var data = {
      "method_name": "getOrderPDF",
      "data": {
        "order_number": widget.orderId,
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
        _showProgressDialog(urlStr);
      }
     // _showProgressDialog("https://www.africau.edu/images/default/sample.pdf");

    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }

  }

  _showProgressDialog(String fileUrl) async{
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
          String savename = "klubba${widget.orderId}.pdf";
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


}
