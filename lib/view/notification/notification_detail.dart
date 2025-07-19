

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';

class NotificationDetail extends StatelessWidget
{
  final String message;
  NotificationDetail(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Notification ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Detail',
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
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(message,
              style: TextStyle(
                  color: Colors.black, fontSize: 14.5)),

          )




        ],
      ),



    );
  }

}