

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:toast/toast.dart';

class AddRestDayScreen extends StatefulWidget
{
  final String date;
  AddRestDayScreen(this.date);
  AddRestState createState()=>AddRestState();
}
class AddRestState extends State<AddRestDayScreen>
{
  int selectedIndex=1;
  var titleController=TextEditingController();
  var descController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Form(
      key: _formKey,
      child: Scaffold(
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
                  text: 'Mark ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Rest Day',
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
            SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/sub1.png',
                        width: 37, height: 37),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset('assets/run_ic.png',
                          width: 35, height: 35),
                    ),
                    Image.asset('assets/sub4.png',
                        width: 30, height: 30),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Title',
                  style: TextStyle(
                      color: AppTheme.blueColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
            SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),

              ),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: titleController,
                  validator: checkEmptyString,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor:Color(0xFFF6F6F6),
                      contentPadding: EdgeInsets.only(left: 5),
                      hintText: 'Add Title...',
                      hintStyle: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF9A9CB8),
                      ))),
            ),
            SizedBox(height: 15),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex=1;
                          });
                        },
                        child: Container(
                          height: 38,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                              selectedIndex==1?
                              AppTheme.themeColor
                                  :Color(0xFFF3F3F3)

                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/skill_ic.png',
                                  width: 21, height: 18.17,color: selectedIndex==1?Colors.black:Color(0xFF9A9CB8)),
                              SizedBox(width: 5),
                              Text('Skill Set',
                                  style: TextStyle(
                                      color: selectedIndex==1?Colors.black:Color(0xFF9A9CB8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.5)),
                            ],
                          ),
                        ),
                      ),
                      flex: 1),
                  SizedBox(width: 7),
                  Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex=2;
                          });
                        },
                        child: Container(
                          height: 38,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                              selectedIndex==2?
                              AppTheme.themeColor
                                  :Color(0xFFF3F3F3)),
                          child: Row(
                            children: [
                              Image.asset('assets/fitness_ic.png',
                                width: 22, height: 18.17,color: selectedIndex==2?Colors.black:Color(0xFF9A9CB8),),
                              SizedBox(width: 5),
                              Text('Fitness',
                                  style: TextStyle(
                                      color: selectedIndex==2?Colors.black:Color(0xFF9A9CB8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.5)),
                            ],
                          ),
                        ),
                      ),
                      flex: 1),
                  SizedBox(width: 7),
                  Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex=3;
                          });
                        },
                        child: Container(
                          height: 38,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                              selectedIndex==3?
                              AppTheme.themeColor
                                  :Color(0xFFF3F3F3)),
                          child: Row(
                            children: [
                              Image.asset('assets/nutrition_ic.png',
                                width: 22, height: 18.17, color: selectedIndex==3?Colors.black:Color(0xFF9A9CB8),),
                              SizedBox(width: 5),
                              Text('Nutrition',
                                  style: TextStyle(
                                      color: selectedIndex==3?Colors.black:Color(0xFF9A9CB8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.5)),
                            ],
                          ),
                        ),
                      ),
                      flex: 1)
                ],
              ),
            ),
            SizedBox(height: 25),


            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                  child: Text('Submit',
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

                    _submitHandler(context);

                  }),
            ),
          ],
        ),
      ),
    );
  }
  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }
  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // All validations Passed

    saveMyCalender(context);
  }


  saveMyCalender(BuildContext context) async {

    APIDialog.showAlertDialog(context, "Please wait");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    String type='';
    if(selectedIndex==1)
    {
      type='skill-set';
    }
    else if(selectedIndex==2)
    {
      type='fitness';
    }
    else
    {
      type='nutrition';
    }



    var data={
      "data":{
        "calendar_token":"",
        "type": type,
        "start_date": widget.date,
        "end_date": widget.date,
        "start_time":"00:00",
        "end_time":"23:59",
        "is_off_day":1,
        "title":titleController.text,
        "description":descController.text,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      },
      "method_name":"saveMyCalendar"
    };


    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saveMyCalendar', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    //calenderList = responseJSON['decodedData']['result'];

    if(responseJSON['decodedData']['status']=='success')
    {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,"Refresh Data");

    }
    else
    {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print('test started');


    setState(() {});
  }
}