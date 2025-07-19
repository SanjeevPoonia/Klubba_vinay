import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/view/payment/transaction_history_screen.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;
  PaymentSuccessScreen(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 200,
              child: OverflowBox(
                minHeight: 320,
                maxHeight: 320,
                child: Lottie.asset('assets/check_animation.json'),
              )),
          Text('Payment Successful',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345D7C),
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text('Booking ID # '+orderId,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              )),
          SizedBox(height: 35),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 90),
            child: ElevatedButton(
                child: Text('Transaction History',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionsScreen()));
                }),
          ),

          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 90),
            child: ElevatedButton(
                child: Text('Back to Home',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(AppTheme.blueColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ))),
                onPressed: () {

                  MyUtils.saveSharedPreferences('tmp',
                      "not subscribed");


                   Route route = MaterialPageRoute(builder: (context) => LandingScreen());
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
                }),
          ),
        ],
      ),
    );
  }




}
