import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/performance_assesment/current_week_screen.dart';
import 'package:klubba/widgets/heading_text_widget.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class AddAssesmentScreen extends StatefulWidget {
  List<dynamic> draftMap;

  AddAssesmentScreen(this.draftMap);

  AddAssesmentState createState() => AddAssesmentState();
}

class AddAssesmentState extends State<AddAssesmentScreen> {
  int selectedWeekIndex = 0;
  List<dynamic> assesmentList = [];
  bool isLoading = false;
  List<dynamic> draftMap = [];
  Map<String, dynamic> attributes = {};
  String currentCategoryImageUrl = '';
  int selectedCategoryIndex = 9999;
  List<dynamic> categoryList = [];
  String imageURL = '';

  List<TextEditingController>? _controllers = [];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
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
                  text: 'Current ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Week',
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
            Expanded(
                child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFF3F3F3)),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Attributes',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          Padding(
                            padding: EdgeInsets.only(right: 25),
                            child: Text('Enter Marks',
                                style: TextStyle(
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ListView.builder(
                          itemCount: widget.draftMap.length,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int pos) {
                            if (widget.draftMap[pos].toString().contains("grades")) {
                              _controllers!.add(TextEditingController(
                                  text: widget.draftMap[pos]['grades']['week ' +
                                      widget.draftMap[pos]['week']
                                          .toString()]));
                            } else {
                              _controllers!
                                  .add(TextEditingController(text: "0"));
                            }

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        widget.draftMap[pos]
                                            ['subcategory_attribute_name'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                    Container(
                                      margin: const EdgeInsets.only(right: 25),
                                      width: 75,
                                      height: 40,
                                      child: TextFormField(
                                          inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                          controller: _controllers![pos],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                          ),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsets.only(left: 8,bottom: 6),
                                              hintStyle: TextStyle(
                                                fontSize: 13.0,
                                                color: Color(0xFF9A9CB8),
                                              ))),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10)
                              ],
                            );
                          }),

                      /*  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Marks Total',
                                style: TextStyle(
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.5)),
                            Padding(
                              padding: const EdgeInsets.only(right: 55),
                              child: Text('00',
                                  style: TextStyle(
                                      color: AppTheme.blueColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.5)),
                            ),
                          ],
                        ),*/
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            )),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                    child: Text('Submit',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ))),
                    onPressed: () {

                      bool isValid=true;

                       for(int i=0;i<widget.draftMap.length;i++)
                         {
                           if(int.parse(_controllers![i].text)>10 || int.parse(_controllers![i].text)<0)
                             {

                               Toast.show("Please enter a range between 0-10",
                                   duration: Toast.lengthShort,
                                   gravity: Toast.bottom,
                                   backgroundColor: Colors.red);
                               isValid=false;
                               break;
                             }
                         }

                       if(isValid)
                         {
                           submitAssesment();
                         }






                    }),
              ),
            ),
          ],
        ));
  }

  submitAssesment() async {
    APIDialog.showAlertDialog(context, 'Please wait...');

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');


    List<dynamic> assesmentData=[];

    assesmentData=widget.draftMap;





    for(int i=0;i<assesmentData.length;i++)
      {
        assesmentData[i]['isChange']=true;

        if(assesmentData[i].toString().contains("grades"))
          {

            assesmentData[i]['grades']['week ' +
                assesmentData[i]['week']
                    .toString()]=_controllers![i].text;
          }
        else
          {
            assesmentData[i]['grades']={
              "week 1":_controllers![i].text
            };
          }



      }




    var data = {
      "method_name": "updateCompletedAttributes",
      "data": {
        "update_arr": assesmentData,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('updateCompletedAttributes', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);

    print(responseJSON);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,"refresh");
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('&&&');
    print(widget.draftMap.toString());
  }
}
