

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';

class AllMediaScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Colors.black),
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
                text: 'Cricket Group',
                style: const TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500),
              ),

            ],
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 23),

            Text("Group Media",
                style: TextStyle(
                    color: AppTheme.themeColor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 13)),


            SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 5,right: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  crossAxisCount: 4,
                  childAspectRatio: (2 / 2)),
              itemCount:15,
              itemBuilder: (context, index) {
                return   Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                          image: AssetImage("assets/group_dummy.jpeg"),
                          fit: BoxFit.fill
                      )
                  ),
                )
                ;
                // Item rendering
              },
            ),



          ],
        ),
      ),

    );
  }

}
