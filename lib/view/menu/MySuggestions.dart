import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';

class MySuggestions extends StatefulWidget{
  _mySuggestions createState()=> _mySuggestions();
}
class _mySuggestions extends State<MySuggestions>{
  bool isLoading=false;
  List<dynamic> mySuggestionList=[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return isLoading?Center(child: Loader(),): mySuggestionList.length==0?
    Center(
      child: Text('You didnot added any suggestions yet!'),
    ): ListView(
      children: [
        SizedBox(height: 5),
        ListView.builder(
            itemCount: mySuggestionList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int pos){

              if(mySuggestionList[pos]['type']=='category'){
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF3F3F3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          Container(
                            alignment: Alignment.centerLeft,
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppTheme.blueColor),
                            child: Text(
                                "Category : "+mySuggestionList[pos]['name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: const Text("Category Group",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppTheme.btnColor
                            ),),),

                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(mySuggestionList[pos]['category_group_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 15),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),

                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child:  Text(mySuggestionList[pos]['message'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 15),




                        ],



                      ),

                    ),
                    SizedBox(height: 15),
                  ],
                );
              }
              else if(mySuggestionList[pos]['type']=='attribute'){

                String leanerStage="";
                List<dynamic> learners=[];
                learners=mySuggestionList[pos]['learner_stages_details'];
                for(int i=0;i<learners.length;i++){
                  if(leanerStage==''){
                    leanerStage=learners[i];
                  }else{
                    leanerStage="$leanerStage,${learners[i]}";
                  }
                }
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF3F3F3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          Container(
                            alignment: Alignment.centerLeft,
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppTheme.blueColor),
                            child: Text(
                                "Attribute : "+mySuggestionList[pos]['name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Category Group",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),
                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(mySuggestionList[pos]['category_group_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Category",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),
                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(mySuggestionList[pos]['category_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Learner Stages",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),
                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(leanerStage,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 15),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),

                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child:  Text(mySuggestionList[pos]['message'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 15),
                        ],



                      ),

                    ),
                    SizedBox(height: 15),
                  ],
                );
              }
              else if(mySuggestionList[pos]['type']=='sub_attributes'){
                String leanerStage="";
                String attributes="";
                List<dynamic> attr=[];
                List<dynamic> learners=[];
                learners=mySuggestionList[pos]['learner_stages_details'];
                attr=mySuggestionList[pos]['category_attribute_details'];
                for(int i=0;i<learners.length;i++){
                  if(leanerStage==''){
                    leanerStage=learners[i];
                  }else{
                    leanerStage="$leanerStage,${learners[i]}";
                  }
                }
                for(int i=0;i<attr.length;i++){
                  if(attributes==''){
                    attributes=attr[i];
                  }else{
                    attributes="$attributes,${attr[i]}";
                  }
                }
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF3F3F3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          Container(
                            alignment: Alignment.centerLeft,
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppTheme.blueColor),
                            child: Text(
                                "Sub Attribute : "+mySuggestionList[pos]['name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Category Group",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),
                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(mySuggestionList[pos]['category_group_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Category",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),
                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(mySuggestionList[pos]['category_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Learner Stages",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),
                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(leanerStage,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 10),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Attributes",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),
                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(attributes,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 15),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppTheme.btnColor
                              ),),),

                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child:  Text(mySuggestionList[pos]['message'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black
                              ),),),

                          SizedBox(height: 15),
                        ],



                      ),

                    ),
                    SizedBox(height: 15),
                  ],
                );
              }
              else{
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF3F3F3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppTheme.blueColor),
                            child: Text(
                                "Other : "+mySuggestionList[pos]['name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(height: 10),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Description",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppTheme.btnColor
                            ),),),

                          SizedBox(height: 3),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:  Text(mySuggestionList[pos]['message'],
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black
                            ),),),

                          SizedBox(height: 15),
                        ],



                      ),

                    ),
                    SizedBox(height: 15),
                  ],
                );
              }


            })
      ],
    );
  }


  @override
  void initState(){
    super.initState();
    _fetchmySuggestion(context);
  }
  _fetchmySuggestion(BuildContext context)async{
    setState(() {
      isLoading=true;
    });

    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "method_name": "getMySuggestions",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
        "orderColumn":"created",
        "orderDir":"desc",
        "pageNumber":0,
        "pageSize":10
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getMySuggestions', requestModel, context);
    var responseJSON = json.decode(response.body);
    if(responseJSON['decodedData']['status'].toString()=='success'){
      mySuggestionList.clear();
      mySuggestionList=responseJSON['decodedData']['result'];

    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });

  }

}