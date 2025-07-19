

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget
{
  final String labelText,description;
  ListTileWidget(this.labelText,this.description);
  @override
  Widget build(BuildContext context) {
   
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


        Expanded(child:   Text(labelText,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14)),flex: 1),

          Expanded(child: Text(": "+description,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),flex: 1)

        ],
      ),
    );
  }
  
}