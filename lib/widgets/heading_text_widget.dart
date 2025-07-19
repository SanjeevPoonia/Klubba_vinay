

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';

class HeadingTextWidget extends StatelessWidget
{
  final String text1,text2;
  HeadingTextWidget(this.text1,this.text2);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(text1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.5)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(text2,
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
    );
  }

}