import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';

class menuSettings extends StatefulWidget{
  _menuSettings createState()=>_menuSettings();
}
class _menuSettings extends State<menuSettings>{
  bool value = false;
  bool memvalue = false;
  bool commuvalue = false;
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
                text: 'Manage ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Settings',
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
      body: Padding(padding: EdgeInsets.only(left: 10,right: 10),
      child: ListView(
        children: [
          SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Your ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),),
                  Text("Activity",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(left: 45),
                color: AppTheme.themeColor,
                alignment: Alignment.topLeft,
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text("Who Can See Your Posts",
            style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.greyColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child:Padding(padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(child: Text("Public",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.commTextColor
                  ),
                )),
                Icon(Icons.keyboard_arrow_down,color: AppTheme.commTextColor,)
              ],
            ),),
          ),
          SizedBox(height: 10,),
          Text("Who Can Using The Email Address You Provided?",
            style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.greyColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child:Padding(padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(child: Text("Public",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.commTextColor
                    ),
                  )),
                  Icon(Icons.keyboard_arrow_down,color: AppTheme.commTextColor,)
                ],
              ),),
          ),
          SizedBox(height: 10,),

          Text("Who Can Look You Up Using The Mobile Number You Provided ?",
            style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.greyColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child:Padding(padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(child: Text("Public",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.commTextColor
                    ),
                  )),
                  Icon(Icons.keyboard_arrow_down,color: AppTheme.commTextColor,)
                ],
              ),),
          ),
          SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Notification ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),),
                  Text("Settings",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(left: 110),
                color: AppTheme.themeColor,
                alignment: Alignment.topLeft,
              ),
            ],
          ),
          SizedBox(height: 10,),

          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (val) {
                  setState(() {
                    value = val!;
                  });
                },
              ),
              SizedBox(width: 10,),
              Text("All Posts",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w300
              ),)
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: memvalue,
                onChanged: (val) {
                  setState(() {
                    memvalue = val!;
                  });
                },
              ),
              SizedBox(width: 10,),
              Text("Klubba Members",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w300
                ),)
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: commuvalue,
                onChanged: (val) {
                  setState(() {
                    commuvalue = val!;
                  });
                },
              ),
              SizedBox(width: 10,),
              Text("Community Owner",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w300
                ),)
            ],
          ),

          SizedBox(height: 20,),

          InkWell(
            onTap: (){},
            child: Card(
              elevation: 3,
              color: Colors.black,
              child: Center(
                child: Padding(padding: EdgeInsets.all(10),
                child: Text("Update",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500
                  ),
                ),
                ),
              ),
            ),
          ),


        ],
      ),
      ),
    );
  }

}