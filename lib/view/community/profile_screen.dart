import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/category/select_category_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class CommunityProfileScreen extends StatefulWidget {
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<CommunityProfileScreen> {
  List<String> dateList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30"
  ];
  List<String> monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "June",
    "July",
    "Aug",
    "Sep",
    "Oct",
    "Nav",
    "Dec"
  ];
  List<String> yearList = [
    "1994",
    "1995",
    "1996",
    "1997",
    "1998",
    "1999",
    "2000",
    "2001",
    "2002",
    "2003",
    "2004",
    "2005",
    "2006",
    "2007"
  ];
  List<String> categoryList = [];
  String selectedDate = "1";
  String selectedMonth = "Mar";
  String selectedYear = "2001";
  String? selectedCategory;
  var nameController = TextEditingController();
  var aboutUsController = TextEditingController();
  var locationUsController = TextEditingController();
  bool editEnabled = false;
  Map<String, dynamic> profileDetails = {};
  XFile? selectedCoverImage;
  XFile? selectedProfileImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : ListView(
              children: [
                Container(
                  height: 350,
                  child: Stack(
                    children: [
                      selectedCoverImage != null
                          ? Container(
                              height: 240,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                          File(selectedCoverImage!.path)),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              height: 240,
                              decoration: BoxDecoration(
                                  image: profileDetails["cover_image"] == null
                                      ? DecorationImage(
                                          image: AssetImage(
                                              "assets/cover_dummy.png"),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: NetworkImage(
                                              profileDetails["cover_image"]),
                                          fit: BoxFit.cover)),
                            ),
                      Container(
                        height: 240,
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back_ios_new,
                                          color: Colors.white)),
                                  Expanded(
                                      child: Center(
                                          child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: editEnabled ? "Edit " : 'View ',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        TextSpan(
                                          text: 'Profile',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ))),
                                  editEnabled
                                      ? GestureDetector(
                                          onTap: () {
                                            updateProfile();
                                          },
                                          child: Image.asset(
                                              "assets/assign_ic.png",
                                              width: 19,
                                              height: 19,
                                              color: Colors.white),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            editEnabled = true;
                                            setState(() {});
                                          },
                                          child: Image.asset(
                                              "assets/edit_ic.png",
                                              width: 19,
                                              height: 19,
                                              color: Colors.white),
                                        ),
                                ],
                              ),
                            ),
                            editEnabled
                                ? Container(
                                    margin: EdgeInsets.only(top: 35),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          _fetchImage(context);
                                        },
                                        child: Container(
                                          child: DottedBorder(
                                            color: Colors.white,
                                            padding: EdgeInsets.zero,
                                            strokeWidth: 1.5,
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(6),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                                child: Container(
                                                  height: 46,
                                                  width: 180,
                                                  color: Color(0xFF01345B),
                                                  child: Center(
                                                    child: Text(
                                                        'Change Cover Image',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13)),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Center(
                        child: Stack(
                          children: [


                            selectedProfileImage != null
                                ? Center(
                        child: Container(
                        margin: EdgeInsets.only(top: 120),
                        width: 145,
                        height: 145,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(4),
                            border: Border.all(
                                width: 1.5, color: Colors.white),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(
                                    File(selectedProfileImage!.path)))),
                      ),
    ):




                            profileDetails["profile_image"] != "" && profileDetails["profile_image"] != null &&
                                    profileDetails["profile_image"]
                                        .toString()
                                        .isNotEmpty
                                ? Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 120),
                                      width: 145,
                                      height: 145,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              width: 1.5, color: Colors.white),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  AppConstant.profileImageURL +
                                                      profileDetails[
                                                          "profile_image"]))),
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 120),
                                      width: 145,
                                      height: 145,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              width: 1.5, color: Colors.white),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/dummy_profile.png"))),
                                    ),
                                  ),

                              editEnabled?Center(
                       child: Container(
                         margin: EdgeInsets.only(top: 120),
                         width:145,
                         height: 145,
                         child: Center(
                           child: GestureDetector(
                             onTap: (){
                               _fetchProfileImage(context);
                             },
                             child: DottedBorder(
                               color: Colors.white,
                               padding: EdgeInsets.zero,
                               strokeWidth: 1.5,
                               borderType: BorderType.RRect,
                               radius: Radius.circular(6),

                               child: ClipRRect(
                                   borderRadius: BorderRadius.all(Radius.circular(6)),
                                   child: Container(
                                     height: 33,
                                     width: 110,
                                     color: Color(0xFF01345B),
                                     child:  Center(
                                       child: Text('Change Profile',
                                           style: TextStyle(
                                               color: Colors.white,
                                               fontFamily: "Poppins",
                                               fontWeight: FontWeight.w500,
                                               fontSize: 13)),
                                     ),
                                   )),
                             ),
                           ),
                         ),
                       ),
                     ):Container()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: const Text(
                          "Name",
                          style: TextStyle(
                            color: AppTheme.blueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: nameController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 7),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          hintText: 'Rahul Singh',
                          hintStyle: const TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFF9A9CB8),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: const Text(
                          "About Us",
                          style: TextStyle(
                            color: AppTheme.blueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        maxLines: 4,
                        controller: aboutUsController,
                        enabled: editEnabled,
                        maxLength: 200,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 7, top: 5, bottom: 5),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          hintText:
                              'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
                          hintStyle: const TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFF9A9CB8),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: const Text(
                          "Location",
                          style: TextStyle(
                            color: AppTheme.blueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: locationUsController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 7),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          hintText: 'Jaipur, Rajasthan',
                          hintStyle: const TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFF9A9CB8),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: const Text(
                          "Date Of Birth",
                          style: TextStyle(
                            color: AppTheme.blueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        profileDetails["dob"] == null
                            ? "NA"
                            : parseServerFormatDate(profileDetails["dob"]),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: const Text(
                          "Date Of Join",
                          style: TextStyle(
                            color: AppTheme.blueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        parseServerFormatDate(profileDetails["joined_date"]),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: const Text(
                          "Category",
                          style: TextStyle(
                            color: AppTheme.blueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              profileDetails["interested_category"]
                                  .toString()
                                  .substring(
                                      1,
                                      profileDetails["interested_category"]
                                              .toString()
                                              .length -
                                          1),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectCategoryScreen()));
                              },
                              child:
                                  Icon(Icons.edit, color: AppTheme.blueColor))
                        ],
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfileDetails();
  }

  fetchProfileDetails() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "userProfileDetails",
      "data": {
        "user_id": id,
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
        'userProfileDetails', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    setState(() {});
    profileDetails = responseJSON['decodedData']['result'];
    nameController.text = profileDetails["full_name"];
    if (profileDetails["about"] != null) {
      aboutUsController.text = profileDetails["about"];
    } else {
      aboutUsController.text = "NA";
    }
    locationUsController.text = profileDetails["location"];

    setState(() {});
    print(responseJSON);
  }

  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.yMMMEd();
    final clockString = dateformat.format(date);
    return clockString.toString();
  }

  _fetchImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      selectedCoverImage = image;
      setState(() {});
      changeCoverImage(context);
    }
  }

  _fetchProfileImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      selectedProfileImage = image;
      setState(() {});
      changeProfileImage(context);
    }
  }



  updateProfile() async {
    APIDialog.showAlertDialog(context, "Updating Profile...");
    String? id = await MyUtils.getSharedPreferences('_id');
    var data = {
      "data": {
        "user_id": id,
        "about": aboutUsController.text,
        "slug": AppModel.slug
      },
      "method_name": "editUserProfile"
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'editUserProfile', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    Navigator.pop(context);

    if (responseJSON["decodedData"]["status"] == "success") {
      Toast.show("Profile Updated successfully !",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      editEnabled = false;
      setState(() {});
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  changeCoverImage(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Changing Cover...');
    String? id = await MyUtils.getSharedPreferences('_id');
    var data = {
      "data": {
        "user_id": id,
        "slug":
           AppModel.slug
      },
      "method_name": "editUserProfile"
    };
    FormData formData = FormData.fromMap({
      "req": base64.encode(utf8.encode(json.encode(data))),
      "cover_image": selectedCoverImage != null
          ? await MultipartFile.fromFile(selectedCoverImage!.path.toString())
          : null
    });
    print(formData.fields);
    Dio dio = Dio();
    var response = await dio.post(AppConstant.appBaseURL + "editUserProfile",
        data: formData);

    //sendPdfForChat
    print(data);
    print(response.data.toString());
    Navigator.pop(context);

    if (response.data['decodedData']['status'] == "success") {
      editEnabled = false;
      setState(() {});
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      // imagePath = response.data['decodedData']['result']['image'][0];
    } else {
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  changeProfileImage(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please wait...');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "data": {
        "user_id": id,
        "slug":
        AppModel.slug
      },
      "method_name": "editUserProfileImage"
    };
    FormData formData = FormData.fromMap({
      "req": base64.encode(utf8.encode(json.encode(data))),
      "image": selectedProfileImage != null
          ? await MultipartFile.fromFile(selectedProfileImage!.path.toString())
          : null
    });
    print(formData.fields);
    Dio dio = Dio();
    var response = await dio.post(AppConstant.appBaseURL,
        data: formData);

    //sendPdfForChat
    print(data);
    print(response.data.toString());
    Navigator.pop(context);

    if (response.data['decodedData']['status'] == "success") {
      editEnabled = false;
      setState(() {});
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      // imagePath = response.data['decodedData']['result']['image'][0];
    } else {
      Toast.show(response.data['decodedData']['errors'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }


}
