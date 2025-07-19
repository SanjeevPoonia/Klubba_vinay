import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';

class createNewGroupScreen extends StatefulWidget {
  List<dynamic> addedMembers;

  createNewGroupScreen(this.addedMembers);

  _createGroup createState() => _createGroup();
}

class _createGroup extends State<createNewGroupScreen> {
  XFile? groupImage;
  String fileName = "";
  String imagePath = "";
  var groupName = TextEditingController();
  var groupDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      floatingActionButton: Container(
        width: 50,
        height: 50,
        child: FloatingActionButton(
            elevation: 4.0,
            child: Icon(Icons.check),
            backgroundColor: AppTheme.themeColor,
            onPressed: () {
              _submitHandler(context);
            }),
      ),
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
                text: 'New ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Group',
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    groupImage != null
                        ? InkWell(
                            onTap: () {
                              _fetchImage(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(File(groupImage!.path))),
                                  shape: BoxShape.circle),
                              height: 51,
                              width: 51,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFB6BECA)),
                            height: 51,
                            width: 51,
                            child: InkWell(
                              onTap: () {
                                _fetchImage(context);
                              },
                              child: Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 27),
                            ),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: groupName,
                        validator: checkGroupNameValidator,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8, top: 11),
                          hintText: "Type Group Name",
                          hintStyle: TextStyle(
                              color: Color(0xFF919191),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  validator: checkGroupDescValidator,
                  controller: groupDescription,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9.0),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFf7A8FA6).withOpacity(0.1),
                    contentPadding: EdgeInsets.only(left: 8, top: 11),
                    hintText: "Type Group Subject Here...",
                    hintStyle: TextStyle(
                        color: Color(0xFFD1D1D1),
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Text(
                    "Group Members: " + widget.addedMembers.length.toString(),
                    style: TextStyle(
                        color: Color(0xFF708096),
                        fontSize: 11.5,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 2,
                            crossAxisCount: 4,
                            childAspectRatio: (2 / 3)),
                    padding: EdgeInsets.all(5),
                    itemCount: widget.addedMembers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            widget.addedMembers[index]["profile_image"] != ""
                                ? CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        AppConstant.profileImageURL +
                                            widget.addedMembers[index]
                                                ["profile_image"]),
                                  )
                                : CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        AssetImage("assets/dummy_profile.png"),
                                  ),
                            SizedBox(height: 5),
                            Text(widget.addedMembers[index]["name"],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Poppins",
                                    color: AppTheme.blueColor,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _fetchImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      groupImage = image;
      setState(() {});
    }
  }

  _uploadPost(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Uploading Image...');
    String? id = await MyUtils.getSharedPreferences('_id');
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "data": {
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      },
      "method_name": "sendImageForChat"
    };

    FormData formData = FormData.fromMap({
      "req": base64.encode(utf8.encode(json.encode(data))),
      "image": groupImage != null
          ? await MultipartFile.fromFile(groupImage!.path.toString())
          : null
    });
    print(formData.fields);
    Dio dio = Dio();
    var response = await dio.post(AppConstant.appBaseURL + "sendImageForChat",
        data: formData);

    //sendPdfForChat
    print(data);
    print(response.data.toString());
    Navigator.pop(context);

    if (response.data['decodedData']['status'] == "success") {
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      imagePath = response.data['decodedData']['result']['image'][0];
      fileName = imagePath.split('/').last;
      createGroup();
    } else {
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  String? checkGroupNameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Group Name is required';
    }
    return null;
  }

  String? checkGroupDescValidator(String? value) {
    if (value!.isEmpty) {
      return 'Group Description is required';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (groupImage != null) {
      _uploadPost(context);
    } else {
      createGroup();
    }
  }

  createGroup() async {
    String? id = await MyUtils.getSharedPreferences('_id');
    List<String> userIDList = [];
    for (int i = 0; i < widget.addedMembers.length; i++) {
      userIDList.add(widget.addedMembers[i]["_id"].toString().trim());
    }
    userIDList.add(id.toString());

    APIDialog.showAlertDialog(context, "Creating Group...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');

    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    //["61b9c5c64e85c44c9df8fa93", "65a77b817bfd384f9cb87611"]
    //[61b9c5c64e85c44c9df8fa93]
    var data = {
      "method_name": "createRoomForGroup",
      "data": {
        "users": userIDList,
        "description": groupDescription.text,
        "chatName": groupName.text,
        "isGroupChat": 1,
        "newMessage": 1,
        "latestMessage": "Welcome to the group",
        "groupImage": imagePath != "" ? [imagePath] : [],
        "admin": [id],
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'createRoomForGroup', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    Navigator.pop(context);

    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
        Navigator.of(context)
        ..pop()
        ..pop("refresh");
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}
