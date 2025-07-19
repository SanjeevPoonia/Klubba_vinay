
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class HowReferWork extends StatefulWidget{
  _howWorkState createState()=>_howWorkState();
}
class _howWorkState extends State<HowReferWork>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        elevation: 0,
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
                text: 'How it ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Works',
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
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Klubba runs a refer program, where you can earn and redeem klubba kandies, klubba kandies can be used to buy membership,to avail discount."
            ),
          )
        ],
      ),
    );
  }



}