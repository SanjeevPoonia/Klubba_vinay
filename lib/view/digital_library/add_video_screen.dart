

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class AddLibraryScreen extends StatefulWidget
{
  String fileType;
  AddLibraryScreen(this.fileType);
  LibraryState createState()=>LibraryState();
}
class LibraryState extends State<AddLibraryScreen>
{
  final _formKeyLogin = GlobalKey<FormState>();
  File? selectedFile;
  var titleController=TextEditingController();
  var videoUrlController=TextEditingController();
  var descController=TextEditingController();
  List<dynamic> categoryList=[];
  List<String> categoryListAsString=[];
  List<dynamic> attributeList=[];
  List<String> attributeListAsString=[];
  List<dynamic> subAttributeList=[];
  List<String> subAttributeListAsString=[];
  List<String> videoTypeList=["Video URL","Upload Video"];
  bool isSwitched = true;
  String? selectedCatValue;
  String? selectedVideoTypeValue='Video URL';
  String? selectedAttributeValue;
  String? selectedSubAttributeValue;
  List<String> levelIDs=[];
  String selectedCategoryID='';
  String selectedAttributeID='';
  String selectedSubAttributeID='';
  String selectedCategoryGroupID='';
  String selectedGroupName='';
  bool isLoading=false;
  List<dynamic> levelList=[];
  String fileName='';


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor:Colors.white,
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
                text: 'Add ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: widget.fileType=='video'?'Video':widget.fileType=='image'?'Image':'PDF',
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


      body:Form(
        key: _formKeyLogin,
        child:
        isLoading?
            Center(
              child: Loader(),
            ):

        ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            SizedBox(height: 15),
            Text('Title*',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextFormField(
                  maxLength: 100,
                  controller: titleController,
                  validator: checkEmptyString,
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
            SizedBox(height: 5),
            Text('Category*',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
            SizedBox(height: 5),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xFFF6F6F6)),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.black),
                  isExpanded: true,
                  hint: Text(
                    'Select category',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: categoryListAsString
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                      .toList(),
                  value: selectedCatValue,
                  onChanged: (value) {
                    setState(() {
                      selectedCatValue = value as String;
                    });
                    String categoryID='';

                    for(int i=0;i<categoryList.length;i++)
                      {
                        if(selectedCatValue==categoryList[i]['category'])
                          {
                            categoryID=categoryList[i]['category_id'];
                            selectedCategoryGroupID=categoryList[i]['category_group_id'];
                            selectedGroupName=categoryList[i]['category_group'];
                            break;
                          }
                      }
                     selectedCategoryID=categoryID;
                    _fetchAttributeList(context,categoryID);
                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                ),
              ),
            ),

            SizedBox(height: 10),
            Text('Attribute',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),


            SizedBox(height: 5),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xFFF6F6F6)),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.black),
                  isExpanded: true,
                  hint: Text(
                    'Select attribute',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: attributeListAsString
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                      .toList(),
                  value: selectedAttributeValue,
                  onChanged: (value) {
                    setState(() {
                      selectedAttributeValue = value as String;
                    });


                    String attributeID='';

                    for(int i=0;i<attributeList.length;i++)
                    {
                      if(selectedAttributeValue==attributeList[i]['text'])
                      {
                        attributeID=attributeList[i]['id'];
                        break;
                      }
                    }

                    selectedAttributeID=attributeID;
                    _fetchSubAttributeList(context,attributeID);
                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Sub-Attribute',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),


            SizedBox(height: 5),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xFFF6F6F6)),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.black),
                  isExpanded: true,
                  hint: Text(
                    'Select category sub attribute',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: subAttributeListAsString
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                      .toList(),
                  value: selectedSubAttributeValue,
                  onChanged: (value) {
                    setState(() {
                      selectedSubAttributeValue = value as String;
                    });

                    String subAttributeID='';

                    for(int i=0;i<subAttributeList.length;i++)
                    {
                      if(selectedSubAttributeValue==subAttributeList[i]['text'])
                      {

                        subAttributeID=subAttributeList[i]['id'];
                        break;
                      }
                    }

                    selectedSubAttributeID=subAttributeID;

                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                ),
              ),
            ),

            SizedBox(height: 15),
            Text('Lavel*',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),

            Container(
              height: 40,
              child: ListView.builder(
                  itemCount: levelList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context,int pos)
                  {
                    return Row(
                      children: [

                        GestureDetector(
                            child:
                    levelIDs.contains(levelList[pos]['_id'])?

                            Icon(Icons.check_box,color: AppTheme.themeColor)
                            :
                        Icon(Icons.check_box_outline_blank)

                            ,onTap: (){

                              if(levelIDs.contains(levelList[pos]['_id']))

                                {
                                  levelIDs.remove(levelList[pos]['_id']);
                                }
                              else
                                {
                                  levelIDs.add(levelList[pos]['_id']);
                                }

                              print(levelIDs.toString());


                            setState(() {
                            });
                        }),

                        SizedBox(width: 5),
                        Text(levelList[pos]['name'],
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),

                        SizedBox(width: 10)



                      ],
                    );
                  }

              ),
            ),
            SizedBox(height: 10),
    widget.fileType=='video'?        Text('Video-Type*',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)):Container(),


            widget.fileType=='video'?           SizedBox(height: 5):Container(),
            widget.fileType=='video'?       Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xFFF6F6F6)),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.black),
                  isExpanded: true,
                  hint: Text(
                    'Select video type',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: videoTypeList
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                      .toList(),
                  value: selectedVideoTypeValue,
                  onChanged: (value) {
                    setState(() {
                      selectedVideoTypeValue = value as String;
                    });
                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                ),
              ),
            ):Container(),


            widget.fileType=='video'?          SizedBox(height: 10):Container(),

     widget.fileType=='video'? Text(selectedVideoTypeValue=="Video URL"?'Library Video Url*':'Upload Video',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)):

     Text(widget.fileType=='image'?'Upload Image':'Upload PDF',
         style: TextStyle(
             color: AppTheme.blueColor,
             fontWeight: FontWeight.w600,
             fontSize: 12)),
            SizedBox(height: 5),




            selectedVideoTypeValue=="Video URL" &&  widget.fileType=='video'?
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextFormField(
                controller: videoUrlController,
                  validator: checkEmptyString,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xFFF6F6F6),
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 8),
                      hintText: 'Library Video Url*',
                      hintStyle: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF9A9CB8),
                      ))),
            ):

            Row(
              children: [
                InkWell(child: Image.asset('assets/upload_ic.png',width: 100,height: 100),onTap: (){




                  if(widget.fileType=='video')
                    {
                      pickVideo();
                    }
                  else if(widget.fileType=='image')
                    {
                      pickImage();
                    }
                  else if(widget.fileType=='pdf')
                    {
                      pickPDF();
                    }
                },),
              ],
            ),

         selectedFile!=null? Padding(padding: EdgeInsets.only(top: 5),
            child: Text(fileName,
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),maxLines: 1),
            ):Container(),




            SizedBox(height: 15),


            Text('Description*',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextFormField(
                  maxLength: 250,
                  controller: descController,
                  validator: checkEmptyString,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xFFF6F6F6),
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 8),
                      hintText: 'Enter description',
                      hintStyle: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF9A9CB8),
                      ))),
            ),


            SizedBox(height: 3),

            Text('Library Availability',
                style: TextStyle(
                    color: AppTheme.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),



            Row(
              children: [
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      print(isSwitched);
                    });
                  },
                  activeTrackColor: AppTheme.themeColor,
                  inactiveTrackColor: Colors.grey,
                  activeColor: Colors.white,
                ),
              ],
            ),

            SizedBox(height: 10),

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
      )

    );
  }
  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }
  void _submitHandler(BuildContext context) async {
    if (!_formKeyLogin.currentState!.validate()) {
      return;
    }
    _formKeyLogin.currentState!.save();
    validateValues();
  }

  validateValues(){
    if(selectedCatValue==null)
      {
        Toast.show("Please select a Category ",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    else if(levelIDs.length==0)
      {
        Toast.show("Please select at least one level",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    else if(selectedVideoTypeValue==null)
      {
        Toast.show("Please select a video type",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    else
      {
        if(widget.fileType=='video' && selectedVideoTypeValue=='Video URL')
          {
            uploadFileAsUrl();
          }
        else
          {
            _uploadFile(context,widget.fileType);
          }

      }
  }


  _fetchCategoryList(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name": "getLearnerCategoryList",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "asc",
        "current_role": currentRole,
        "current_category_id": "5d498615ee90fb3fb1a59b9e",
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getLearnerCategoryList', requestModel, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading=false;
    });
    categoryList = responseJSON['decodedData']['result'];
    for(int i=0;i<categoryList.length;i++)
      {
        categoryListAsString.add(categoryList[i]['category']);
      }
    setState(() {});
    print(responseJSON);
  }



  _fetchLevels(BuildContext context) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name":"getDigitalLibraryDropDown",
      "data":{
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":"5d498615ee90fb3fb1a59b9e",
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getDigitalLibraryDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);
    levelList = responseJSON['decodedData']['result']['learnerStagesListData'];
    setState(() {});
    print(responseJSON);
  }

  _fetchAttributeList(BuildContext context,String categoryId) async {
    if(attributeList.length!=0)
      {
        attributeListAsString.clear();
        attributeList.clear();
      }

    APIDialog.showAlertDialog(context, 'Please wait');

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name":"getCategoryAttributesList",
      "data":{
        "category_id":categoryId,
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":catId,
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getLearnerCategoryList', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    attributeList = responseJSON['decodedData']['result']['category_attribute_list'];
    if(attributeList.length!=0)
      {
        attributeList.removeAt(0);
      }
    for(int i=0;i<attributeList.length;i++)
    {
      attributeListAsString.add(attributeList[i]['text']);
    }
    setState(() {});
    print(responseJSON);
  }


  uploadFileAsUrl() async {
    APIDialog.showAlertDialog(context, 'Please wait');
    var data = {
      "data":{
        "title":titleController.text,
        "category_group_id":selectedCategoryGroupID,
        "category_id":selectedCategoryID,
        "library_type":"video",
        "learner_stages_id":levelIDs,
        "category_attribute_id":selectedAttributeID,
        "category_sub_attribute_id":selectedSubAttributeID,
        "library_availability":isSwitched?"public":"",
        "video_type":"embed_url",
        "library_video_url":videoUrlController.text,
        "description":descController.text,
        "groupName":selectedGroupName,
        "categoryName":selectedCatValue,
        "categoryAttributeName":selectedAttributeValue,
        "categorySubAttributeName":selectedSubAttributeValue,
        "library_images_size":[
        ],
        "library_images_size_count":0,
        "slug":AppModel.slug
      },
      "method_name":"saveDigitalLibrary"
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('saveDigitalLibrary', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);

    if (responseJSON['decodedData']['status'] == 'success') {

      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context);

      // success

    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }
  }


  _uploadFile(BuildContext context,String fileType)async{
    APIDialog.showAlertDialog(context, 'Uploading File...');

    var data = {
      "data":{
        "title":titleController.text,
        "category_group_id":selectedCategoryGroupID,
        "category_id":selectedCategoryID,
        "library_type":fileType,
        "learner_stages_id":levelIDs,
        "category_attribute_id":selectedAttributeID,
        "category_sub_attribute_id":selectedSubAttributeID,
        "library_availability":isSwitched?"public":"private",
        "video_type":widget.fileType=='video' && selectedVideoTypeValue=="Video URL"?"embed_url":widget.fileType=='video'?"upload_video":"video",
        "library_video_url":videoUrlController.text,
        "description":descController.text,
        "groupName":selectedGroupName,
        "categoryName":selectedCatValue,
        "categoryAttributeName":selectedAttributeValue,
        "categorySubAttributeName":selectedSubAttributeValue,
        "library_images_size":[
        ],
        "library_images_size_count":0,
        "slug":AppModel.slug
      },
      "method_name":"saveDigitalLibrary"
    };

    print("Files");
    print(getFileExtension(fileName));

    FormData formData= FormData.fromMap({
      "library_image_0":await MultipartFile.fromFile(selectedFile!.path.toString(),filename: fileName,contentType: MediaType("image", getFileExtension(fileName))),
      "req":base64.encode(utf8.encode(json.encode(data))),
      "total_attachments":1
    });
    Dio dio= Dio();
    var response = await dio.post(AppConstant.appBaseURLProfileImage,data: formData);
    print(data);
    print(response.data.toString());


    if(response.data['decodedData']['status']=="success"){
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context);
    }else{
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    Navigator.pop(context);
    setState(() {

    });
  }


  String getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch(e){
      return null!;
    }
  }

  _fetchSubAttributeList(BuildContext context,String attributeID) async {
    if(subAttributeList.length!=0)
    {
      subAttributeListAsString.clear();
      subAttributeList.clear();
    }

    APIDialog.showAlertDialog(context, 'Please wait');

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data={
      "method_name":"getCategorySubAttributesList",
      "data":{
        "category_attribute_id":attributeID,
        "slug":AppModel.slug,
        "current_role":currentRole,
        "current_category_id":catId,
        "action_performed_by":id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getCategorySubAttributesList', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    subAttributeList = responseJSON['decodedData']['result']['category_sub_attribute_list'];
    if(subAttributeList.length!=0)
    {
      subAttributeList.removeAt(0);
    }
    for(int i=0;i<subAttributeList.length;i++)
    {
      subAttributeListAsString.add(subAttributeList[i]['text']);
    }
    setState(() {});
    print(responseJSON);
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategoryList(context);
    _fetchLevels(context);
  }

  pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      selectedFile= File(result.files.single.path.toString());
      fileName=selectedFile!.path.split('/').last;
      setState(() {

      });
    } else {
      // User canceled the picker
    }
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      selectedFile= File(result.files.single.path.toString());
      fileName=selectedFile!.path.split('/').last;
      setState(() {

      });
    } else {
      // User canceled the picker
    }
  }


  pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ["pdf"],type: FileType.custom);
    if (result != null) {
      selectedFile= File(result.files.single.path.toString());
      fileName=selectedFile!.path.split('/').last;
      setState(() {

      });
    } else {
      // User canceled the picker
    }
  }


}