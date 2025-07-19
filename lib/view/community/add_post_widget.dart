import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:toast/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddPostWidget extends StatefulWidget {
  final String userName;
  final String profileImage;
  final String postType;
  final int? groupId;

  AddPostWidget(this.userName,this.profileImage,this.postType, this.groupId);

  @override
  PostState createState() => PostState();
}

class PostState extends State<AddPostWidget> {
  List<XFile> imageList = [];
  List<File> videoList = [];
  String selectedAudience="Public";
  List<String> audienceTypeList=[
    "Public",
    "My connections"
  ];
  final _formKey = GlobalKey<FormState>();

  List<Uint8List> thumbnailList = [];

  var addPostController = TextEditingController();
  List<CategoryItems?> catList = [];
  List<CategoryItems?> selectedtedCatIDs=[];
  List<dynamic> categoryList = [];
  var _items;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: Loader(),
              )
            : Form(
          key: _formKey,
              child: Column(
                  children: [
                    Container(
                      height: 85,
                      padding: EdgeInsets.only(left: 12, right: 10, top: 20),
                      width: double.infinity,
                      color: AppTheme.themeColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2, top: 7),
                              child: Icon(
                                Icons.close_outlined,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 7),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Poppins",
                                  color: Color(0xFF1A1A1A),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.postType == "Post"
                                        ? 'Create '
                                        : "Post ",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: widget.postType == "Post"
                                        ? 'Post'
                                        : "Talent",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 80,
                            child: ElevatedButton(
                                child: Text('Post',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
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
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Container(
                          width: 55,
                          height: 60,
                          margin: EdgeInsets.only(top: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 1.2, color: Colors.white),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.profileImage))),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.userName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                            SizedBox(height: 5),
                           /* Container(
                              width: 66,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: AppTheme.themeColor),
                              child: Row(
                                children: [
                                  SizedBox(width: 7),
                                  Text("Public",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.5)),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  )
                                ],
                              ),
                            )*/


                            Container(
                             // width: 80,
                              height: 25,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: AppTheme.themeColor),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                                      color: Colors.black),
                                  isExpanded: true,
                                  hint: Text(
                                    'Select year',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: audienceTypeList
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
                                  value: selectedAudience,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAudience = value as String;
                                    });

                                  },
                                  buttonHeight: 40,
                                  buttonWidth: 140,
                                  itemHeight: 40,
                                ),
                              ),
                            ),

                          ],
                        ))
                      ],
                    ),
                    SizedBox(height: 10),
                    MultiSelectChipField<CategoryItems?>(
                      initialValue: [catList[0]],
                        validator: (values) {
                          if (values == null || values.isEmpty) {
                            return "Required";
                          }},
                      icon: Icon(Icons.close, color: Colors.black),
                      items: _items,
                      title: Text(
                        "Select Category",
                        style: TextStyle(color: AppTheme.blueColor, fontSize: 14),
                      ),
                      headerColor: AppTheme.themeColor.withOpacity(0.5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppTheme.themeColor, width: 1.8),
                      ),
                      selectedChipColor: Colors.blue.withOpacity(0.5),
                      selectedTextStyle: TextStyle(color: AppTheme.blueColor),
                      onTap: (List<CategoryItems?> values) {

                        selectedtedCatIDs=values;
                        print(selectedtedCatIDs.toString());




                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: addPostController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.fromLTRB(4.0, 5.0, 0.0, 10.0),
                            hintText: 'What\'s on your mind?',
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFB8B6B6)),
                          )),
                    ),

                    /* Row(
                children: [
                  SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(Icons.location_pin,color: Color(0xFF484D54),size: 12),
                  ),
                  SizedBox(width: 2),

                  Text('Jaipur, Rajasthan',
                      style: TextStyle(
                          color: Color(0xFF484D54),
                          fontWeight: FontWeight.w500,
                          fontSize: 11)),
                ],
              ),*/

                    Spacer(),
                    imageList.length != 0
                        ? Container(
                            height: 65,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Flexible(
                                  child: ListView.builder(
                                      itemCount: imageList.length,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  margin: EdgeInsets.only(top: 3),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(4),
                                                      border: Border.all(
                                                          width: 1.2,
                                                          color: Colors.white),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: FileImage(File(
                                                              imageList[pos].path)))),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: GestureDetector(
                                                          onTap: (){
                                                            imageList.removeAt(pos);
                                                            setState(() {

                                                            });
                                                            //thumbnailList.removeAt(pos);

                                                          },

                                                          child: Image.asset("assets/cross_ic.png",width: 21,height: 21))
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 5)
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    _fetchImage(context);
                                  },
                                  child: Container(
                                    child: DottedBorder(
                                      color: Colors.black,
                                      padding: EdgeInsets.zero,
                                      strokeWidth: 1.5,
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(4),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          child: Container(
                                              width: 55,
                                              height: 55,
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/add_image.png",
                                                      width: 20,
                                                      height: 20,
                                                      color: AppTheme.blueColor),
                                                  Text('Add',
                                                      style: TextStyle(
                                                          color:
                                                              AppTheme.blueColor,
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12)),
                                                ],
                                              ))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    videoList.length != 0
                        ? Container(
                            height: 65,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Flexible(
                                  child: ListView.builder(
                                      itemCount: videoList.length,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    margin:
                                                        EdgeInsets.only(top: 3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                4),
                                                        border: Border.all(
                                                            width: 1.2,
                                                            color: Colors.white),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: MemoryImage(
                                                                thumbnailList[
                                                                    pos]))),

                                                    /* child: Image.memory(thumbnailList[pos]),*/
                                                  ),
                                                  Center(
                                                    child: Icon(
                                                        Icons.play_arrow_rounded,
                                                        color: Colors.white),
                                                  ),

                                                  SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: GestureDetector(
                                                          onTap: (){
                                                            videoList.removeAt(pos);
                                                            thumbnailList.removeAt(pos);
                                                            setState(() {

                                                            });

                                                          },

                                                          child: Image.asset("assets/cross_ic.png",width: 21,height: 21))
                                                    ),
                                                  )

                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5)
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  child: DottedBorder(
                                    color: Colors.black,
                                    padding: EdgeInsets.zero,
                                    strokeWidth: 1.5,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(4),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(4)),
                                        child: Container(
                                            width: 55,
                                            height: 55,
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/add_image.png",
                                                    width: 20,
                                                    height: 20,
                                                    color: AppTheme.blueColor),
                                                Text('Add',
                                                    style: TextStyle(
                                                        color: AppTheme.blueColor,
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12)),
                                              ],
                                            ))),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 6,
                            offset:
                                const Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18, right: 25),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.postType=="Talent"?Container():
                            GestureDetector(
                                onTap: () {
                                  _fetchImage(context);
                                },
                                child: Image.asset("assets/post_image.png",
                                    width: 31, height: 31)),
                            widget.postType=="Talent"?Container():
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                _fetchVideo(context);
                              },
                              child: Image.asset("assets/post_video.png",
                                  width: 31, height: 31),
                            )
                            /* Image.asset("assets/post_link.png",width: 27,height: 27),
                      Image.asset("assets/post_doc.png",width: 27,height: 27),
                      Image.asset("assets/post_emojis.png",width: 27,height: 27),
*/
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            ));
  }

  _uploadPost(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Uploading Post...');
    List<String> ids=[];
    for(int i=0;i<selectedtedCatIDs.length;i++)
      {
        ids.add(selectedtedCatIDs[i]!.id);
      }
    String? id = await MyUtils.getSharedPreferences('_id');
    var data = {
      "data": {
        "user_id": id,
        "description":addPostController.text,
        "post_type":  widget.postType=="Talent"?"talent_post":"simple_post",
        "is_public": selectedAudience=="Public"?1:0,
        "category": ids,
        "slug": AppModel.slug
      },
      "method_name": "createNewPostForCommunity"
    };

    FormData formData = FormData.fromMap({
      "req": base64.encode(utf8.encode(json.encode(data))),
    });
    print(formData.fields);
    for (int i = 0; i < videoList.length; i++) {
      var path = videoList[i].path.toString();
      formData.files.addAll([
        MapEntry("video", await MultipartFile.fromFile(path, filename: path))
      ]);
    }
      for (int i = 0; i < imageList.length; i++) {
        var path = imageList[i].path.toString();
        formData.files.addAll([
          MapEntry(
              "post_image", await MultipartFile.fromFile(path, filename: path))
        ]);
      }
    Dio dio = Dio();
    var response =
        await dio.post(AppConstant.appBaseURL+"createNewPostForCommunity", data: formData);
    print(data);
    print(response.data.toString());
        Navigator.pop(context);

    if (response.data['decodedData']['status'] == "success") {
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,"refresh Data");
    } else {
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }


  _fetchCategoryList(BuildContext context) async {
    setState(() {
      isLoading = true;
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
      isLoading = false;
    });
    categoryList = responseJSON['decodedData']['category_dropdown'];
    for (int i = 0; i < categoryList.length; i++) {

      if(i==0)
        {
          selectedtedCatIDs.add(CategoryItems(
              id: categoryList[i]["id"], name: categoryList[i]["text"]));
        }


      catList.add(CategoryItems(
          id: categoryList[i]["id"], name: categoryList[i]["text"]));
    }
    _items = catList
        .map((cat) => MultiSelectItem<CategoryItems>(cat!,cat.name))
        .toList();
    setState(() {});
    print("Cat List");
    print(catList.toString());
    print(responseJSON);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategoryList(context);
  }

  _fetchImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      imageList.add(image);
      setState(() {});
    }
  }

  _fetchVideo(BuildContext context) async {
   /* final ImagePicker _picker = ImagePicker();

    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);*/

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video,allowCompression: true);
    if (result != null) {
     File video= File(result.files.single.path.toString());
     print("File size");
     print(video.lengthSync());
     videoList.add(video);
     Uint8List? uint8list = await VideoThumbnail.thumbnailData(
       video: video.path,
       imageFormat: ImageFormat.JPEG,
       maxWidth: 128,
       // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
       quality: 25,
     );
     thumbnailList.add(uint8list!);
     setState(() {});
    }
  }
  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _uploadPost(context);
  }

  validateValues(){
    if(addPostController.text=="" && imageList.length==0 && videoList.length==0)
      {
        Toast.show("Post cannot be blank !",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    else
      {

      }
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }
}

class CategoryItems {
  final String id;
  final String name;

  CategoryItems({
    required this.id,
    required this.name,
  });
}
