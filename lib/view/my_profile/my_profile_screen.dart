import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/my_profile/change_password.dart';
import 'package:klubba/view/home/landing_screen.dart';
import 'package:klubba/view/login/login_with_otp_screen.dart';
import 'package:klubba/view/my_profile/profile_basic_details.dart';
import 'package:klubba/view/category/select_category_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import 'package:image_picker/image_picker.dart';

import 'kyc_documents_screen.dart';
import '../login/login_screen.dart';
import 'package:dio/dio.dart';

class MyProfileScreen extends StatefulWidget {
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<MyProfileScreen> {
  String name = '';
  String imageURL = '';
  String location = '';
  String klubbaId = '';
  String validTill = '';
  String territory = '';
  String regonalOffice = '';
  String kiosk = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // _fetchName();
    _fetchUderDetails(context);
  }

  _fetchName() async {
    name = (await MyUtils.getSharedPreferences('name'))!;
    imageURL = (await MyUtils.getSharedPreferences('profile_image'))!;
    location = (await MyUtils.getSharedPreferences('location'))!;
    klubbaId = (await MyUtils.getSharedPreferences('klubba_id'))!;
    validTill = (await MyUtils.getSharedPreferences('valid_till'))!;
    territory = (await MyUtils.getSharedPreferences('territory_name'))!;
    regonalOffice = (await MyUtils.getSharedPreferences('ro'))!;
    kiosk = (await MyUtils.getSharedPreferences('kiosk_name'))!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LandingScreen()),
              (Route<dynamic> route) => false) /*Navigator.of(context).pop()*/,
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () => {showLogoutDialog()},
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
        backgroundColor: AppTheme.themeColor,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'My ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Profile',
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
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : Column(
              children: [
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppTheme.blueColor.withOpacity(0.8)),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 15),
                          Container(
                            transform:
                                Matrix4.translationValues(0.0, -27.0, 0.0),
                            width: 90,
                            height: 90,
                            child: Stack(
                              children: [
                                imageURL == ''
                                    ? Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    'assets/dummy_profile.png'))),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: imageURL,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 90.0,
                                          height: 90.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(7),
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: AppTheme.themeColor,
                                          shape: BoxShape.circle),
                                      child: Image.asset('assets/edit_ic.png'),
                                    ),
                                    onTap: () {
                                      _showPictureDialog();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                              SizedBox(height: 7),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Image.asset('assets/loc_ic.png',
                                        width: 12, height: 12),
                                  ),
                                  SizedBox(width: 4),
                                  Text(location,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                ],
                              ),
                            ],
                          ))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/id_ic.png',
                                      width: 12, height: 12),
                                ),
                                Flexible(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text('Klubba ID : ' + klubbaId,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                )),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/time_ic.png',
                                      width: 12, height: 12),
                                ),
                                SizedBox(width: 4),
                                Text('Valid Till : ' + validTill,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/ro_ic.png',
                                      width: 12, height: 12),
                                ),
                                Flexible(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text('RO : ' + regonalOffice,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                )),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/territory_ic.png',
                                      width: 12, height: 12),
                                ),
                                Flexible(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text('Territory : ' + territory,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                )),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset('assets/kiosk_ic.png',
                                      width: 12, height: 12),
                                ),
                                Flexible(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text('Kiosk : ' + kiosk,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                )),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            child: Card(
                              color: Color(0xFFF3F3F3),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 25),
                                    Image.asset('assets/details_ic.png',
                                        width: 45, height: 45),
                                    SizedBox(height: 10),
                                    Text('Basic Details',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () => {
                              /* Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) =>
                        ProfileBasicDetails()))*/
                              _navigateAndVerify(context)
                            },
                          ),
                          flex: 1),
                      const SizedBox(width: 16),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectCategoryScreen()))
                            },
                            child: Card(
                              color: Color(0xFFF3F3F3),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 25),
                                    Image.asset('assets/category_ic.png',
                                        width: 45, height: 45),
                                    SizedBox(height: 10),
                                    Text('Select Category',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          KycDocumentScreen()));
                            },
                            child: Card(
                              color: Color(0xFFF3F3F3),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 25),
                                    Image.asset('assets/kyc_ic.png',
                                        width: 45, height: 45),
                                    SizedBox(height: 10),
                                    Text('KYC',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(width: 16),
                      Expanded(
                          child: InkWell(
                            child: Card(
                              color: Color(0xFFF3F3F3),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 25),
                                    Image.asset('assets/password_ic.png',
                                        width: 45, height: 45),
                                    SizedBox(height: 10),
                                    Text('Change Password',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangePassword()));
                            },
                          ),
                          flex: 1),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _fetchUderDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var data = {
      "method_name": "getUserDetailBySlug",
      "data": {"slug": AppModel.slug}
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getUserDetailBySlug', requestModel, context);
    var responseJSON = json.decode(response.body);

    name = responseJSON['decodedData']['result']['full_name']!;
    if(responseJSON['decodedData']['result']['profile_image']!=null)
      {
        imageURL = responseJSON['decodedData']['image_url'] +
            responseJSON['decodedData']['result']['profile_image'];
      }
    else
      {
        imageURL = '';
      }
    location = responseJSON['decodedData']['result']['location_details']
            ['city_name'] +
        ',' +
        responseJSON['decodedData']['result']['location_details']
            ['state_name'] +
        ',' +
        responseJSON['decodedData']['result']['location_details']
            ['country_name'];
    klubbaId = responseJSON['decodedData']['result']['user_code'];
    validTill = responseJSON['decodedData']['result']['current_package_expiry'];
    territory = responseJSON['decodedData']['result']['location_details']
        ['territory_name'];
    regonalOffice = responseJSON['decodedData']['result']['location_details']
        ['regional_office_name'];
    kiosk =
        responseJSON['decodedData']['result']['location_details']['kiosk_name'];

    isLoading = false;
    setState(() {});
  }

  _fetchImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      _uploadFile(image);
    }
  }

  _fetchImageFromCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      _uploadFile(image);
    }
  }

  _uploadFile(XFile xFile) async {
    print('uploading image');
    APIDialog.showAlertDialog(context, 'Uploading Profile Image');

    var data = {
      "method_name": "editUserProfileImage",
      "data": {"slug": AppModel.slug}
    };

    String fileName = xFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(xFile.path, filename: fileName),
      "req": base64.encode(utf8.encode(json.encode(data))),
    });
    Dio dio = Dio();
    var response =
        await dio.post(AppConstant.appBaseURLProfileImage, data: formData);
    print(response.data);

    if (response.data['decodedData']['status'] == "success") {
      imageURL = response.data['decodedData']['image_url'] +
          response.data['decodedData']['result']['profile_image'];

      print(imageURL);
      MyUtils.saveSharedPreferences('profile_image', imageURL);

      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(response.data['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    Navigator.pop(context);
    setState(() {});
  }

  _uploadProfileImage(BuildContext context) async {
    var data = {
      "method_name": "editUserProfileImage",
      "data": {"slug": AppModel.slug}
    };

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getUserDetailBySlug', requestModel, context);
    var responseJSON = json.decode(response.body);
  }

  _logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginOTPScreen()),
        (Route<dynamic> route) => false);
    logOutUser();
  }


  showLogoutDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Logout",
        style: TextStyle(fontWeight: FontWeight.w600, color:AppTheme.blueColor),
      ),
      onPressed: () {
        Navigator.pop(context);
        _logOut();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Log Out?"),
      content: Text("Are you sure you want to log out ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  logOutUser() async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "saveLoginInfo",
      "data": {
        "user_id": id,
        "mode": "logout",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);

    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saveLoginInfo', requestModel, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
  }

  Future<void> _navigateAndVerify(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfileBasicDetails()));
    if (!mounted) return;
    if (result == "1") {
      _fetchUderDetails(context);
    }
  }

  _showPictureDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, dialogState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black),
                            child: Center(
                              child: Icon(Icons.close_sharp,
                                  color: Colors.white, size: 13.5),
                            ),
                          ),
                        ),
                        SizedBox(width: 15)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Select ',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text('Picture',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.none,
                                      fontSize: 16)),
                              SizedBox(height: 3),
                              Container(
                                width: 38,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: AppTheme.themeColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 15),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Camera',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.5)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);
                            _fetchImageFromCamera(context);
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 15),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Photos',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.5)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppTheme.blueColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);

                            _fetchImage(context);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, false ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
}
