import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/view/my_profile/upload_Kyc_document.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class KycDocumentScreen extends StatefulWidget{
  _kycDocumentScreen createState()=>_kycDocumentScreen();
}
class _kycDocumentScreen extends State<KycDocumentScreen>{
  bool isLoading=false;
  List<dynamic> dropList=[];
  String baseImageUrl="";

  String dlID="";
  String dlOrder="";
  String dlUrl="";
  String dlStatue="";

  String addId="";
  String addOrd="";
  String addUrl="";
  String addStatue="";

  String idID="";
  String idOrd="";
  String idUrl="";
  String idStatue="";

  String panID="";
  String panOrd="";
  String panUrl="";
  String panStatue="";


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
                text: 'Upload ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Document',
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
      body: isLoading?
      Center(
        child: Loader(),
      ):ListView(
        children: [

          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            child:  Text(
              "Choose Your Document Type",
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.blueColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: ()=>{
              _navigateAndVerify(context, dlID, dlOrder, dlUrl,dlStatue)
            },
            child:Container(
              color: AppTheme.greyColor,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: AppTheme.themeColor),
                          color: AppTheme.themeColor,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Image.asset('assets/ic_kyc_driving.png'),


                    ),
                    const Expanded(
                      child: Text(
                        "Driving Licence",
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      flex: 1,
                    ),
                    Icon(Icons.chevron_right_sharp,color: Colors.black,)


                  ],
                ),
              ),
            ) ,
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: ()=>{
              _navigateAndVerify(context, addId, addOrd, addUrl,addStatue)
            },
            child:Container(
              color: AppTheme.greyColor,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: AppTheme.themeColor),
                        color: AppTheme.themeColor,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Image.asset('assets/ic_kyc_address.png'),


                    ),
                    const Expanded(
                      child: Text(
                        "Address Proof",
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      flex: 1,
                    ),
                    Icon(Icons.chevron_right_sharp,color: Colors.black,)


                  ],
                ),
              ),
            ) ,
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: ()=>{
              _navigateAndVerify(context, idID, idOrd, idUrl,idStatue)
            },
            child:Container(
              color: AppTheme.greyColor,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: AppTheme.themeColor),
                        color: AppTheme.themeColor,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Image.asset('assets/ic_kyc_id.png'),


                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "ID Proof",
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(Icons.chevron_right_sharp,color: Colors.black,)


                  ],
                ),
              ),
            ) ,
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: ()=>{
              _navigateAndVerify(context, panID, panOrd, panUrl,panStatue)
            },
            child:Container(
              color: AppTheme.greyColor,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: AppTheme.themeColor),
                        color: AppTheme.themeColor,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Image.asset('assets/ic_kyc_pan.png'),


                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "PAN Card",
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Icon(Icons.chevron_right_sharp,color: Colors.black,)


                  ],
                ),
              ),
            ) ,
          ),

        ],
      )

    );
  }
  @override
  void initState(){
    super.initState();
    // _fetchName();
    _fetchMasterDetails(context);
  }
  _fetchMasterDetails(BuildContext context) async{
    setState(() {
      isLoading=true;
    });
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');
    APIDialog.showAlertDialog(context, "Please Wait...");
    var data = {
      "method_name": "getMasterDropDown",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
        "dropdown_type":"kyc_document"
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getMasterDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);


    if(responseJSON['decodedData']['status']=='success'){
      dropList.clear();
      dropList=responseJSON['decodedData']['result'];

      for(int i=0;i<dropList.length;i++){
        if(dropList[i]['text']=="Driving Licence"){
          dlID=dropList[i]['id'];
          dlOrder=dropList[i]['order'].toString();
        }else if(dropList[i]['text']=="Address Proof"){
          addId=dropList[i]['id'];
          addOrd=dropList[i]['order'].toString();
        }else if(dropList[i]['text']=="ID Proof"){
          idID=dropList[i]['id'];
          idOrd=dropList[i]['order'].toString();
        }else if(dropList[i]['text']=="PAN"){
          panID=dropList[i]['id'];
          panOrd=dropList[i]['order'].toString();
        }
  }

      _fetchUserDocumentList(context);

    }else{
      Navigator.of(context).pop();
      isLoading = false;
      setState(() {});
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _finishActivity();
    }





  }

  _finishActivity(){
    Navigator.of(context).pop();
  }

  _fetchUserDocumentList(BuildContext context) async{

    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "getUserKycDocumentList",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getUserKycDocumentList', requestModel, context);
    var responseJSON = json.decode(response.body);

    Navigator.of(context).pop();
    if(responseJSON['decodedData']['status']=='success'){
      baseImageUrl=responseJSON['decodedData']['image_url'];
      List<dynamic> docList=[];
      docList=responseJSON['decodedData']['result'];
      for(int i=0;i<docList.length;i++){
        if(dlID==docList[i]['document_type_id']){
          dlUrl=baseImageUrl+docList[i]['image'];
          dlStatue=docList[i]['status'].toString();
        }else if(addId==docList[i]['document_type_id']){
          addUrl=baseImageUrl+docList[i]['image'];
          addStatue=docList[i]['status'].toString();
        }else if(idID==docList[i]['document_type_id']){
          idUrl=baseImageUrl+docList[i]['image'];
          idStatue=docList[i]['status'].toString();
        }else if(panID==docList[i]['document_type_id']){
          panUrl=baseImageUrl+docList[i]['image'];
          panStatue=docList[i]['status'].toString();
        }
      }
    }else{


      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _finishActivity();
    }

    isLoading = false;
    setState(() {});



  }

  Future<void> _navigateAndVerify(BuildContext context,String docId,String docOrder,String docUrl,String docStatus) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadKycDocument(docId,  docOrder, docUrl,docStatus)));
    if(!mounted) return;


    if(result=="1"){
      _fetchMasterDetails(context);
    }

  }
}