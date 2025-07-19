import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/payment/transaction_details_screen.dart';
import 'package:klubba/widgets/loader.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';

class TransactionsScreen extends StatefulWidget {
  TransactionState createState() => TransactionState();
}

class TransactionState extends State<TransactionsScreen> {
  List<dynamic> transactionItems = [];
  bool isLoading = true;
  Map<String, dynamic> BillingInfo = {};

  @override
  Widget build(BuildContext context) {
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
                text: 'History',
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
      ) : transactionItems.length==0?
              Center(
                child: Text('Your Transaction History is empty'),
              ): ListView(
        children: [
          SizedBox(height: 5),
          ListView.builder(
              itemCount: transactionItems.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int pos){
                return Column(
                  children: [
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
                                          transactionItems[pos]['product_name']??"Product Name",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12)),
                                    )),
                                Padding(
                                  padding:
                                  EdgeInsets.only(left: 15, right: 10),
                                  child: Text('₹ '+transactionItems[pos]['amount'].toString(),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: [
                                        Text('Booking ID',
                                            style: TextStyle(
                                                color: AppTheme.blueColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11)),
                                        Text(transactionItems[pos]['order_id'],
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
                                        Text(transactionItems[pos]['created'],
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
                                        transactionItems[pos]['status']==1?

                                        Container(
                                          height: 28,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                              color: Color(0xFF0BB500)),
                                          child: Center(
                                            child: Text('Successfully',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 11)),
                                          ),
                                        )
                                            :
                                        Container(
                                          height: 28,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                              color: Color(
                                                  0xFFEA0A3B)),
                                          child: Center(
                                            child: Text('Pending',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 11)),
                                          ),
                                        ),

                                        SizedBox(height: 12),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    ),
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      children: [
                                        Text('Transaction Number',
                                            style: TextStyle(
                                                color: AppTheme.blueColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11)),
                                        Text(transactionItems[pos]['transaction_number'],
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
                                        Text(transactionItems[pos]['payment_type'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13)),
                                        SizedBox(height: 25),
                                        Container(
                                          width: 120,
                                          height: 39,
                                          child: ElevatedButton(
                                              child: Text('View Details',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.5)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                      ))),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TransactionDetail(transactionItems[pos]['order_number'].toString(),transactionItems[pos]['status'])));
                                              }),
                                        ),
                                      ],
                                    ),
                                  ))
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

    );
  }


  _fetchTransactionDetails(BuildContext context) async{
    setState(() {
      isLoading=true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    var _id = await MyUtils.getSharedPreferences("_id");

    var data = {
      "method_name": "getTransactions",
      "data": {
        "current_role": currentRole,
        "slug": AppModel.slug,
        "orderColumn":"created",
        "orderDir":"desc",
        "pageNumber":"0",
        "pageSize":"10",
        "current_category_id": null,
        "action_performed_by": _id,
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getTransactions', requestModel, context);
    var responseJSON = json.decode(response.body);
    transactionItems = responseJSON['decodedData']['result'];

    isLoading = false;
    setState(() {});
    print("Length "+transactionItems.length.toString());
    print(transactionItems);

  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _fetchTransactionDetails(context);
    });
  }

}
