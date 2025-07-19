import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:toast/toast.dart';

class ProgressPictures extends StatefulWidget {
  ProgressState createState() => ProgressState();
}

class ProgressState extends State<ProgressPictures> {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  XFile? image1, image2, image3;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  DateTime? _selectedDate;
  int fileCount=0;
  bool uploadCommunity=false;

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
                  text: 'Progress Pictures',
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
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Title*',
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    validator: checkEmptyString,
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xFFF6F6F6),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: 'Enter title',
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF9A9CB8),
                        ))),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Taken on (DD/MM/YYYY)*',
                    style: TextStyle(
                        color: AppTheme.blueColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  _pickDateDialog();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                      enabled: false,
                      controller: dateController,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xFFF6F6F6),
                          filled: true,
                          contentPadding: EdgeInsets.only(left: 8),
                          hintText: 'Select Date',
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFF9A9CB8),
                          ))),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFF6F6F6)),
                                child: image1 == null
                                    ? Center(
                                        child: Image.asset(
                                            'assets/add_image.png',
                                            width: 50,
                                            height: 50))
                                    : Center(
                                        child: Image.file(File(image1!.path)))),
                            onTap: () {
                              _pickImage1();
                            },
                          ),
                          SizedBox(height: 5),
                          Text('Upload Front',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFF6F6F6)),
                                child: image2 == null
                                    ? Center(
                                        child: Image.asset(
                                            'assets/add_image.png',
                                            width: 50,
                                            height: 50))
                                    : Center(
                                        child: Image.file(File(image2!.path)))),
                            onTap: () {
                              _pickImage2();
                            },
                          ),
                          SizedBox(height: 5),
                          Text('Upload Side',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFF6F6F6)),
                                child: image3 == null
                                    ? Center(
                                        child: Image.asset(
                                            'assets/add_image.png',
                                            width: 50,
                                            height: 50))
                                    : Center(
                                        child: Image.file(File(image3!.path)))),
                            onTap: () {
                              _pickImage3();
                            },
                          ),
                          SizedBox(height: 5),
                          Text('Upload Back',
                              style: TextStyle(
                                  color: AppTheme.blueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  SizedBox(width: 13),
                  uploadCommunity?
                  GestureDetector(
                      onTap: (){
                       setState(() {
                         uploadCommunity=false;
                       });
                      },

                      child: Icon(Icons.check_box,color: AppTheme.themeColor)):GestureDetector(
                      onTap: (){
                        setState(() {
                          uploadCommunity=true;
                        });
                      },

                      child: Icon(Icons.check_box_outline_blank)),

                  SizedBox(width: 5),

                  Text('Want to share on community',
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ],
              ),







              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                    child: Text('Save',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
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
                      _submitHandler(context);
                    }),
              ),
            ],
          ),
        ));
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
    validateImages();
  }

  validateImages() {

    if(dateController.text.isEmpty)
      {
        Toast.show('Please select a Date!!',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }


   else if (image1 == null && image2 == null && image3 == null) {
      Toast.show('Please upload at least one image',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      _uploadProgressPictures();
    }
  }

  _pickImage1() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      image1 = image;
      fileCount=fileCount+1;
      setState(() {});
    }
  }

  _pickImage2() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      image2 = image;
      fileCount=fileCount+1;
      setState(() {});
    }
    print('Image value');
  }

  _pickImage3() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      image3 = image;
      fileCount=fileCount+1;
      setState(() {});
    }
    print('Image value');
  }

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String formatted = formatter.format(_selectedDate!);
      print(formatted);
      dateController.text = formatted.toString();
      setState(() {});
    });
  }

  _uploadProgressPictures() async {
    APIDialog.showAlertDialog(context, 'Uploading images');




    var data = {
      "data": {
        "slug": AppModel.slug,
        "title": titleController.text,
        "taken_on_date": dateController.text
      },
      "method_name": "saveProgressivePicture"
    };

   // String fileName1 = image1!.path.split('/').last;
    FormData formData = FormData.fromMap({
      "progress_picture_0": image1!=null?await MultipartFile.fromFile(image1!.path):null,
      "progress_picture_1":image2!=null? await MultipartFile.fromFile(image2!.path):null,
      "progress_picture_2":image3!=null? await MultipartFile.fromFile(image3!.path):null,
      "req": base64.encode(utf8.encode(json.encode(data))),
      "total_attachments":fileCount
    });
    Dio dio = Dio();
    var response = await dio.post(AppConstant.appBaseURL, data: formData);
    Navigator.pop(context);
    if (response.data['decodedData']['status'] == "success") {
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,"Refresh");
    } else {
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }
}
