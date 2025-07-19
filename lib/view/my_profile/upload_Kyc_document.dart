
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';
import '../app_theme.dart';

class UploadKycDocument extends StatefulWidget{
  String docId;
  String docOrder;
  String docUrl;
  String docStatus;
  UploadKycDocument(this.docId,this.docOrder,this.docUrl,this.docStatus,{super.key});
  _uploadKycDocument createState()=> _uploadKycDocument();
}
class _uploadKycDocument extends State<UploadKycDocument>{
  String titleFirst="";
  String titleSecond="";
  String localImage="";
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    if(widget.docOrder=="8"){
      titleFirst="Driving";
      titleSecond="Licence";
      localImage="assets/ic_kycupload_dl.png";
    }else if(widget.docOrder=="1"){
      titleFirst="Address";
      titleSecond="Proof";
      localImage="assets/ic_kycupload_ap.png";
    }
    else if(widget.docOrder=="2"){
      titleFirst="ID";
      titleSecond="Proof";
      localImage="assets/ic_kycupload_id.png";
    }
    else if(widget.docOrder=="3"){
      titleFirst="PAN";
      titleSecond="Card";
      localImage="assets/ic_kycupload_pan.png";
    }



    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
            onPressed: () => Navigator.of(context).pop("0"),
          ),
          backgroundColor: AppTheme.themeColor,
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1A1A1A),
              ),
              children: <TextSpan>[
                 TextSpan(
                  text: "$titleFirst ",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: titleSecond,
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
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child:  Text(
                "Take a Photo of the Front of Your ",
                style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child:  Text(
               "$titleFirst $titleSecond",
                style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(padding: EdgeInsets.all(10),
            child: DottedBorder(
              color: AppTheme.blueColor,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.3,
                color: AppTheme.greyColor,
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                child: widget.docUrl==''?Image.asset(localImage):Image.network(widget.docUrl),

              ),
            ),),



            SizedBox(height: 10,),

            Container(
              width: double.infinity,
              height: 50,
              child: widget.docUrl==''?const Text(""):Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Approval Status",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: AppTheme.blueColor),),
                  SizedBox(height: 5,),
                  widget.docStatus=='0'?
                  const Text("Pending",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: AppTheme.themeColor),):
                  const Text("Approved",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: AppTheme.greyColor),),
                ],
              ) ,),
            ),
            
            Padding(padding: EdgeInsets.all(10),
            child:InkWell(
              onTap: (){_fetchImage(context);},
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 47,
                decoration: BoxDecoration(
                  color: AppTheme.blueColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child:widget.docUrl==''? const Text(
                  "Upload Image",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,

                  ),
                  textAlign: TextAlign.center,
                ):const Text(
                  "Re-Upload Image",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,

                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ) ,)

            

          ],
        )

    );
  }

  _fetchImage(BuildContext context) async{
    final ImagePicker _picker = ImagePicker();

    final XFile? image= await _picker.pickImage(source: ImageSource.gallery);

    print('Image File From Android'+ (image?.path).toString());
    if(image!=null){
      _uploadFile(context, image);
    }


  }

  _uploadFile(BuildContext context, XFile xFile)async{
    print ('uploading image');
    APIDialog.showAlertDialog(context, 'Uploading Image...');

    var data = {
      "method_name": "saveUserKycDocument",
      "data": {
        "slug": AppModel.slug,
        "document_type":widget.docId,
      }
    };

    String fileName=xFile.path.split('/').last;
    FormData formData= FormData.fromMap({
      "image":await MultipartFile.fromFile(xFile.path,filename: fileName),
      "req":base64.encode(utf8.encode(json.encode(data))),
    });
    Dio dio= Dio();
    var response = await dio.post(AppConstant.appBaseURLProfileImage,data: formData);
    Navigator.pop(context);
    if(response.data['decodedData']['status']=="success"){
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      _finishActivitySuccess();
    }else{
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }




  }

  _finishActivitySuccess(){
    Navigator.of(context).pop("1");
  }


}
