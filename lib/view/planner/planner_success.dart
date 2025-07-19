import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/payment/transaction_history_screen.dart';
import 'package:lottie/lottie.dart';

class PlannerSuccessScreen extends StatelessWidget {
  final String orderId;
  PlannerSuccessScreen(this.orderId);
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
          Text('Congratulations!!',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF345D7C),
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 5),
          Text('You have Successfully Active Tailor Made Program!!',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF345D7C),
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 35),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 90),
            child: ElevatedButton(
                child: Text('Go To Planner',
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
                  Navigator.pop(context);

                }),
          ),
        ],
      ),
    );
  }
}
