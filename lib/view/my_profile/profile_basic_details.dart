import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../../widgets/textfield_widget.dart';
import '../app_theme.dart';
import '../../widgets/ExpansionTile.dart' as custom;

class ProfileBasicDetails extends StatefulWidget {
  _basicDetailsState createState() => _basicDetailsState();
}

class _basicDetailsState extends State<ProfileBasicDetails> {
  late ExpandedTileController _controller;
  late ExpandedTileController _controller2;
  late ExpandedTileController _controller3;
  late ExpandedTileController _controller4;
  final _formKeybasicDetails = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergancyphoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool expansion1State = true;
  bool expansion2State = false;
  bool expansion3State = false;
  bool expansion4State = false;

  TextEditingController currentAddressLine1Controller = TextEditingController();
  TextEditingController currentAddressLine2Controller = TextEditingController();
  TextEditingController currentPinCodeController = TextEditingController();
  TextEditingController currentStateController = TextEditingController();
  TextEditingController currentDistrictController = TextEditingController();
  TextEditingController currentCityController = TextEditingController();

  TextEditingController permanentAddressLine1Controller =
      TextEditingController();
  TextEditingController permanentAddressLine2Controller =
      TextEditingController();
  TextEditingController permanentPinCodeController = TextEditingController();
  TextEditingController permanentStateController = TextEditingController();
  TextEditingController permanentDistrictController = TextEditingController();
  TextEditingController permanentCityController = TextEditingController();

  String firstName = "";
  String lastName = "";
  String mobileNumber = "";
  String email = "";
  String GenderStr = "";
  String locationStr = "";
  String dobStr = "";
  String emergancyNumber = "";
  String bloodGroupStr = "";
  String currentPinCode = "";

  String _gender = "Gender*";
  String _genderStr = "Gender*";
  String _bloodGroup = "Group*";
  String _bloodStr = "Group";
  bool _fromTop = true;
  DateTime? _chosenDateTime;
  String _formatedDateTime = "";
  bool checkValue = false;

  bool isLoading = false;
  bool isAddressAvailable = false;

  List<dynamic> genderList = [];
  List<dynamic> bloodList = [];

  String currentAddressL1Str = "";
  String currentAddressL2Str = "";
  String currentAddressPinStr = "";
  String currentAddressStateStr = "";
  String currentAddressDistrictStr = "";
  String currentAddressCityStr = "";

  String currentStateId = "";
  String currentDistrictId = "";
  String currentCityId = "";
  String permanentStateId = "";
  String permanentDistrictId = "";
  String permanentCityid = "";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
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
              const TextSpan(
                text: 'Basic ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Details',
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
          : Form(
              key: _formKeybasicDetails,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 7),
                        child: ExpandedTile(
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.white),
                          theme: ExpandedTileThemeData(
                            headerColor: _controller.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            headerRadius: 0,
                            headerPadding: EdgeInsets.only(top: 15, bottom: 15),
                            headerSplashColor: Colors.red,
                            contentBackgroundColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _controller,
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            color: _controller.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            child: Text(
                              "Basic Details",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                          content: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3, top: 5, right: 3, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Container(
                                    child: const Text(
                                      "First Name*",
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
                                    controller: firstNameController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      filled: true,
                                      fillColor: AppTheme.greyColor,
                                      border: InputBorder.none,
                                      hintText: 'First Name',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Last Name*",
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
                                    controller: lastNameController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 5),
                                      hintText: 'Last Name',
                                      filled: true,
                                      fillColor: AppTheme.greyColor,
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Mobile Number*",
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
                                  DisabledPhoneNumber(
                                    maxLength: 10,
                                    validator: phoneValidator,
                                    controller: phoneController,
                                    fieldIC: const Icon(Icons.mail,
                                        size: 20, color: AppTheme.themeColor),
                                    suffixIc: const Icon(
                                      Icons.mail,
                                      size: 20,
                                    ),
                                    labeltext: '',
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "E-mail",
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
                                    validator: null,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 5),
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: AppTheme.greyColor,
                                      hintText: 'E-mail',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            print("Expanded Data");
                            print(_controller.isExpanded.toString());

                            if (_controller2.isExpanded) {
                              _controller2.toggle();
                            }

                            if (_controller3.isExpanded) {
                              _controller3.toggle();
                            }

                            if (_controller4.isExpanded) {
                              _controller4.toggle();
                            }
                            setState(() {});
                          },
                          onLongTap: () {
                            debugPrint("long tapped!!");
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        child: ExpandedTile(
                          // enabled: expansion2State,
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.white),
                          theme: ExpandedTileThemeData(
                            headerColor: _controller2.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            headerRadius: 0,
                            headerPadding: EdgeInsets.only(top: 15, bottom: 15),
                            headerSplashColor: Colors.red,
                            contentBackgroundColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _controller2,
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            color: _controller2.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            child: Text(
                              "Other Details",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                          content: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 3, right: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    "Gender*",
                                    style: TextStyle(
                                      color: AppTheme.blueColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showGenderDialog();
                                    },
                                    child: Container(
                                      height: 48,
                                      color: AppTheme.greyColor,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 7),
                                          Text(_genderStr,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: _gender == ""
                                                    ? Colors.grey
                                                    : Colors.black,
                                              )),
                                          Spacer(),
                                          Icon(Icons.keyboard_arrow_down),
                                          SizedBox(width: 5)
                                        ],
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showCategoryDialog();
                                    },
                                    child: Container(
                                      height: 48,
                                      color: AppTheme.greyColor,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 7),
                                          Text(
                                              _chosenDateTime == null
                                                  ? 'DOB'
                                                  : _formatedDateTime,
                                              /*"${_chosenDateTime?.year}-${_chosenDateTime?.month}-${_chosenDateTime?.day}",*/
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              )),
                                          Spacer(),
                                          Icon(Icons.calendar_month_outlined),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Emergency Contact Number",
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
                                  EmergencyNumber(
                                    validator: null,
                                    maxLength: 10,
                                    controller: emergancyphoneController,
                                    fieldIC: const Icon(Icons.mail,
                                        size: 20, color: AppTheme.themeColor),
                                    suffixIc: const Icon(
                                      Icons.mail,
                                      size: 20,
                                    ),
                                    labeltext: '',
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Blood Group",
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
                                  GestureDetector(
                                    onTap: () {
                                      _showBloodGroupDialog();
                                    },
                                    child: Container(
                                      height: 48,
                                      color: AppTheme.greyColor,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 7),
                                          Text(_bloodStr,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: _bloodGroup == ""
                                                    ? Colors.grey
                                                    : Colors.black,
                                              )),
                                          Spacer(),
                                          Icon(Icons.keyboard_arrow_down),
                                          SizedBox(width: 5)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            if (_controller.isExpanded) {
                              _controller.toggle();
                            }

                            if (_controller3.isExpanded) {
                              _controller3.toggle();
                            }

                            if (_controller4.isExpanded) {
                              _controller4.toggle();
                            }
                            setState(() {});
                          },
                          onLongTap: () {
                            debugPrint("long tapped!!");
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        child: ExpandedTile(
                          // enabled: expansion2State,
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.white),
                          theme: ExpandedTileThemeData(
                            headerColor: _controller3.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            headerRadius: 0,
                            headerPadding: EdgeInsets.only(top: 15, bottom: 15),
                            headerSplashColor: Colors.red,
                            contentBackgroundColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _controller3,
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            color: _controller3.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            child: Text(
                              "Current Address",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                          content: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3, top: 5, right: 3, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Address Line1*",
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
                                    controller: currentAddressLine1Controller,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'Address line 1',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Address Line2",
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
                                    controller: currentAddressLine2Controller,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'Address line 2',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Pin Code*",
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
                                    controller: currentPinCodeController,
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                        hintText: "Pin Code",
                                        contentPadding:
                                            EdgeInsets.only(left: 7),
                                        border: InputBorder.none,
                                        fillColor: AppTheme.greyColor,
                                        filled: true,
                                        hintStyle: TextStyle(
                                            color: AppTheme.greyColor,
                                            fontSize: 15)),
                                    validator: checkPincode,
                                    onChanged: (s) {
                                      if (s.length == 6) {
                                        _fetchPinCodeDetailsCurrent(context, s);
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "State*",
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
                                    enabled: false,
                                    controller: currentStateController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'State',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "District*",
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
                                    enabled: false,
                                    controller: currentDistrictController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'District',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "City*",
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
                                    enabled: false,
                                    controller: currentCityController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'City',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            if (_controller.isExpanded) {
                              _controller.toggle();
                            }

                            if (_controller2.isExpanded) {
                              _controller2.toggle();
                            }

                            if (_controller4.isExpanded) {
                              _controller4.toggle();
                            }
                            setState(() {});
                          },
                          onLongTap: () {
                            debugPrint("long tapped!!");
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        child: ExpandedTile(
                          // enabled: expansion2State,
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.white),
                          theme: ExpandedTileThemeData(
                            headerColor: _controller4.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            headerRadius: 0,
                            headerPadding: EdgeInsets.only(top: 15, bottom: 15),
                            headerSplashColor: Colors.red,
                            contentBackgroundColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                          ),
                          controller: _controller4,
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            color: _controller4.isExpanded
                                ? AppTheme.blueColor
                                : Color(0xFFB9B9B9),
                            child: Text(
                              "Permanent Address",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                          content: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3, top: 5, right: 3, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Checkbox(
                                              activeColor: AppTheme.themeColor,
                                              value: checkValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  checkValue = value!;
                                                  if (checkValue) {
                                                    permanentAddressLine1Controller
                                                            .text =
                                                        currentAddressLine1Controller
                                                            .text;
                                                    permanentAddressLine2Controller
                                                            .text =
                                                        currentAddressLine2Controller
                                                            .text;
                                                    permanentPinCodeController
                                                            .text =
                                                        currentPinCodeController
                                                            .text;
                                                    permanentStateController
                                                            .text =
                                                        currentStateController
                                                            .text;
                                                    permanentDistrictController
                                                            .text =
                                                        currentDistrictController
                                                            .text;
                                                    permanentCityController
                                                            .text =
                                                        currentCityController
                                                            .text;
                                                  } else {
                                                    permanentAddressLine1Controller
                                                        .text = "";
                                                    permanentAddressLine2Controller
                                                        .text = "";
                                                    permanentPinCodeController
                                                        .text = "";
                                                    permanentStateController
                                                        .text = "";
                                                    permanentDistrictController
                                                        .text = "";
                                                    permanentCityController
                                                        .text = "";
                                                  }
                                                });
                                              }),
                                        ),
                                        Text(
                                          'Same As Current Address',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Address Line1*",
                                      style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    enabled: !checkValue,
                                    controller: permanentAddressLine1Controller,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'Address line 1',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Address Line2",
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
                                    enabled: !checkValue,
                                    controller: permanentAddressLine2Controller,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'Address line 2',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "Pin Code*",
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
                                    enabled: !checkValue,
                                    controller: permanentPinCodeController,
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 7),
                                        border: InputBorder.none,
                                        fillColor: AppTheme.greyColor,
                                        filled: true,
                                        hintText: "Pin Code",
                                        hintStyle: TextStyle(
                                            color: AppTheme.greyColor,
                                            fontSize: 15)),
                                    validator: checkPincode,
                                    onChanged: (s) {
                                      if (s.length == 6) {
                                        _fetchPinCodeDetailsParmanent(
                                            context, s);
                                      }
                                    },
                                  ),
                                  Container(
                                    child: const Text(
                                      "State*",
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
                                    enabled: false,
                                    controller: permanentStateController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'State',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "District*",
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
                                    enabled: false,
                                    controller: permanentDistrictController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'District',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: const Text(
                                      "City*",
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
                                    enabled: false,
                                    controller: permanentCityController,
                                    validator: checkEmptyString,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 7),
                                      border: InputBorder.none,
                                      fillColor: AppTheme.greyColor,
                                      filled: true,
                                      hintText: 'City',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            if (_controller.isExpanded) {
                              _controller.toggle();
                            }

                            if (_controller2.isExpanded) {
                              _controller2.toggle();
                            }

                            if (_controller3.isExpanded) {
                              _controller3.toggle();
                            }
                            setState(() {});
                          },
                          onLongTap: () {
                            debugPrint("long tapped!!");
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _submitHandler(context);
                                /*Route route = MaterialPageRoute(builder: (context) => DialogScreen());
                                        Navigator.pushAndRemoveUntil(
                                            context, route, (Route<dynamic> route) => false);*/
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                      color: AppTheme.blueColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 50,
                                  child: const Center(
                                    child: Text('Submit',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  )),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop("0");
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 50,
                                  child: const Center(
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = ExpandedTileController(isExpanded: true);
    _controller2 = ExpandedTileController();
    _controller3 = ExpandedTileController();
    _controller4 = ExpandedTileController();

    // _fetchName();
    _fetchUderDetails(context);
  }

  String? checkPincode(String? value) {
    if (value!.isEmpty) {
      return 'Pincode is Required';
    } else if (value.length < 6) {
      return 'Invalid Pincode';
    }
    return null;
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!)) {
      return 'Enter a valid Mobile Number';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email is required and should be valid Email address.';
    }
    return null;
  }

  _showCategoryDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
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
                            Text('DOB',
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
                  SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        minimumYear: 1970,
                        maximumYear: DateTime.now().year-4,
                        initialDateTime: DateTime(DateTime.now().year-4, DateTime.now().month,DateTime.now().day),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                            _formatedDateTime = DateFormat('yyyy-MM-dd')
                                .format(_chosenDateTime!);
                          });
                        }),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Save',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.5)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ))),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
              margin: EdgeInsets.only(top: 22),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                  .animate(anim1),
          child: child,
        );
      },
    );
  }

  _showGenderDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                            Text('Your Gender',
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
                  SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView(
                      children: [
                        ListView.builder(
                            itemCount: genderList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int pos) {
                              return genderList[pos]['id'] == ''
                                  ? Container()
                                  : RadioListTile(
                                      title: Text(genderList[pos]['text']),
                                      value: genderList[pos]['id'],
                                      groupValue: _gender,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value.toString();
                                          _genderStr = genderList[pos]['text'];
                                        });
                                        Navigator.pop(context);
                                      });
                            })
                      ],
                    ),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Save',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.5)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ))),
                        onPressed: () => null),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                  .animate(anim1),
          child: child,
        );
      },
    );
  }

  _showBloodGroupDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                            Text('Your Blood Group',
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
                  SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView(
                      children: [
                        ListView.builder(
                            itemCount: bloodList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int pos) {
                              return bloodList[pos]['id'] == ''
                                  ? Container()
                                  : RadioListTile(
                                      title: Text(bloodList[pos]['text']),
                                      value: bloodList[pos]['id'],
                                      groupValue: _bloodGroup,
                                      onChanged: (value) {
                                        setState(() {
                                          _bloodGroup = value.toString();
                                          _bloodStr = bloodList[pos]['text'];
                                        });
                                        Navigator.pop(context);
                                      });
                            })
                      ],
                    ),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Save',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.5)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ))),
                        onPressed: () => null),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                  .animate(anim1),
          child: child,
        );
      },
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

    if (responseJSON['decodedData']['status'].toString() == 'success') {
      firstName = responseJSON['decodedData']['result']['first_name']!;
      lastName = responseJSON['decodedData']['result']['last_name']!;
      mobileNumber = responseJSON['decodedData']['result']['mobile_number']!;
      email = responseJSON['decodedData']['result']['email']!;

      if (responseJSON['decodedData']['result']['gender'] != null) {
        GenderStr = responseJSON['decodedData']['result']['gender'];
        _gender = responseJSON['decodedData']['result']['gender'];
       // _genderStr=GenderStr;
      }

      if (responseJSON['decodedData']['result']['location'] != null) {
        locationStr =
            responseJSON['decodedData']['result']['location'].toString();
      }

      firstNameController.text = firstName;
      lastNameController.text = lastName;
      phoneController.text = mobileNumber;
      emailController.text = email;
      emergancyphoneController.text=responseJSON['decodedData']['result']['emergency_contact_number']??"";
      String responseStr = responseJSON.toString();
      if (responseStr.contains("current_address_line_1")) {
        isAddressAvailable = true;
        currentAddressLine1Controller.text =
            responseJSON['decodedData']['result']['current_address_line_1']!;
        currentAddressLine2Controller.text =
            responseJSON['decodedData']['result']['current_address_line_2']!;
        currentPinCodeController.text =
            responseJSON['decodedData']['result']['current_address_post_code']!;
        currentStateController.text = responseJSON['decodedData']['result']
            ['current_address_post_code_details']['state_name']!;
        currentStateId = responseJSON['decodedData']['result']
            ['current_address_post_code_details']['state_id']!;
        currentCityController.text = responseJSON['decodedData']['result']
            ['current_address_post_code_details']['city_name']!;
        currentCityId = responseJSON['decodedData']['result']
            ['current_address_post_code_details']['city_id']!;
        currentDistrictController.text = responseJSON['decodedData']['result']
            ['current_address_post_code_details']['district_name']!;
        currentDistrictId = responseJSON['decodedData']['result']
            ['current_address_post_code_details']['district_id']!;

        permanentAddressLine1Controller.text =
            responseJSON['decodedData']['result']['permanent_address_line_1']!;
        permanentAddressLine2Controller.text =
            responseJSON['decodedData']['result']['permanent_address_line_2']!;
        permanentPinCodeController.text = responseJSON['decodedData']['result']
            ['permanent_address_post_code']!;
        permanentStateController.text = responseJSON['decodedData']['result']
            ['permanent_address_post_code_details']['state_name']!;
        permanentStateId = responseJSON['decodedData']['result']
            ['permanent_address_post_code_details']['state_id']!;
        permanentCityController.text = responseJSON['decodedData']['result']
            ['permanent_address_post_code_details']['city_name']!;
        permanentCityid = responseJSON['decodedData']['result']
            ['permanent_address_post_code_details']['city_id']!;
        permanentDistrictController.text = responseJSON['decodedData']['result']
            ['permanent_address_post_code_details']['district_name']!;
        permanentDistrictId = responseJSON['decodedData']['result']
            ['permanent_address_post_code_details']['district_id']!;

        if (responseStr.contains("same_as_current")) {
          if (responseJSON['decodedData']['result']['same_as_current'] == 1) {
            checkValue = true;
          } else {
            checkValue = false;
          }
          checkValue = true;
        } else {
          checkValue = false;
        }
      } else {
        isAddressAvailable = false;
      }
      _fetchGenderConstants(context);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }
  }

  _fetchGenderConstants(BuildContext context) async {
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    var data = {
      "method_name": "getGlobalConstantList",
      "data": {
        "dropdown_type": "gender",
        "slug": AppModel.slug,
        "current_role": role,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getGlobalConstantList', requestModel, context);
    var responseJSON = json.decode(response.body);

    if (responseJSON['decodedData']['status'].toString() == 'success') {
      genderList.clear();
      genderList = responseJSON['decodedData']['result'];

      for (int i = 0; i < genderList.length; i++) {
        if (genderList[i]['id'] == GenderStr) {
          _genderStr = genderList[i]['text'];
        }
      }
      _fetchBloodConstants(context);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }
  }

  _fetchBloodConstants(BuildContext context) async {
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getMasterDropDown",
      "data": {
        "dropdown_type": "blood_groups",
        "slug": AppModel.slug,
        "current_role": role,
        "action_performed_by": id,
        "current_category_id": catId,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getMasterDropDown', requestModel, context);
    var responseJSON = json.decode(response.body);

    if (responseJSON['decodedData']['status'].toString() == 'success') {
      bloodList.clear();
      bloodList = responseJSON['decodedData']['result'];

      if (isAddressAvailable) {
        isLoading = false;
        setState(() {});
      } else {
        _fetchAddress(context);
      }
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }
  }

  _fetchAddress(BuildContext context) async {
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getTransactions",
      "data": {
        "orderColumn": "created",
        "slug": AppModel.slug,
        "current_role": role,
        "action_performed_by": id,
        "current_category_id": catId,
        "orderDir": "desc",
        "pageNumber": "0",
        "pageSize": "10"
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getTransactions', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      List<dynamic> transactions = [];
      transactions = responseJSON['decodedData']['result'];

      if (transactions.isNotEmpty) {
        currentAddressL1Str = transactions[0]['billing_info']['address_line_1'];
        currentAddressL2Str = transactions[0]['billing_info']['address_line_2'];
        currentAddressPinStr = transactions[0]['billing_info']['post_code'];
        currentAddressCityStr = transactions[0]['billing_info']['city_name'];
        currentAddressDistrictStr =
            transactions[0]['billing_info']['district_name'];
        currentAddressStateStr = transactions[0]['billing_info']['state_name'];

        currentAddressLine1Controller.text = currentAddressL1Str;
        currentAddressLine2Controller.text = currentAddressL2Str;
        currentPinCodeController.text = currentAddressPinStr;
        currentCityController.text = currentAddressCityStr;
        currentDistrictController.text = currentAddressDistrictStr;
        currentStateController.text = currentAddressStateStr;
      }
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }
    isLoading = false;
    setState(() {});
  }

  _fetchPinCodeDetailsCurrent(BuildContext context, String pincode) async {
    APIDialog.showAlertDialog(context, 'Checking Pincode...');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "checkPinCode",
      "data": {
        "pin_code": pincode,
        "slug": AppModel.slug,
        "current_role": role,
        "current_role": role,
        "action_performed_by": id,
        "current_category_id": catId,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('checkPinCode', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      currentAddressStateStr =
          responseJSON['decodedData']['result']['state_name'];
      currentAddressDistrictStr =
          responseJSON['decodedData']['result']['district_name'];
      currentAddressCityStr =
          responseJSON['decodedData']['result']['city_name'];
      currentStateId = responseJSON['decodedData']['result']['state_id'];
      currentDistrictId = responseJSON['decodedData']['result']['district_id'];
      currentCityId = responseJSON['decodedData']['result']['city_id'];

      currentStateController.text = currentAddressStateStr;
      currentCityController.text = currentAddressCityStr;
      currentDistrictController.text = currentAddressDistrictStr;

      if (checkValue) {
        permanentPinCodeController.text = pincode;
        permanentCityController.text = currentAddressCityStr;
        permanentDistrictController.text = currentAddressDistrictStr;
        permanentStateController.text = currentAddressStateStr;

        permanentStateId = currentStateId;
        permanentDistrictId = currentDistrictId;
        permanentCityid = currentCityId;
      }
    } else {
      Toast.show("Invalid pin code",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    Navigator.pop(context);
    setState(() {});
  }

  _fetchPinCodeDetailsParmanent(BuildContext context, String pincode) async {
    APIDialog.showAlertDialog(context, 'Checking Pincode...');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "checkPinCode",
      "data": {
        "pin_code": pincode,
        "slug": AppModel.slug,
        "current_role": role,
        "action_performed_by": id,
        "current_category_id": catId,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('checkPinCode', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      permanentCityController.text =
          responseJSON['decodedData']['result']['city_name'];
      permanentDistrictController.text =
          responseJSON['decodedData']['result']['district_name'];
      permanentStateController.text =
          responseJSON['decodedData']['result']['state_name'];

      permanentStateId = responseJSON['decodedData']['result']['state_id'];
      permanentDistrictId =
          responseJSON['decodedData']['result']['district_id'];
      permanentCityid = responseJSON['decodedData']['result']['city_id'];
    } else {
      Toast.show("Invalid pin code",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    Navigator.pop(context);
    setState(() {});
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKeybasicDetails.currentState!.validate()) {
      return;
    }
    _formKeybasicDetails.currentState!.save();
    _editBasicDetails(context);
  }

  _editBasicDetails(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Updating Basic Details...');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    /* var data = {
      "method_name": "editProfile",
      "data": {
        "action_performed_by":id,
        "blood_groups":_bloodGroup,
        "current_address_line_1":currentAddressLine1Controller.text,
        "current_address_line_2":currentAddressLine2Controller.text,
        "current_address_post_code":currentPinCodeController.text,
        "current_category_id":catId,
        "current_city":currentCityId,
        "current_district":currentDistrictId,
        "current_role":role,
        "current_state":currentStateId,
        "date_of_birth":_formatedDateTime,
        "email":emailController.text,
        "emergency_contact_number":emergancyphoneController.text,
        "first_name":firstNameController.text,
        "last_name":lastNameController.text,
        "gender":_gender,
        "location":locationStr,
        "mobile_number":phoneController.text,
        "permanent_address_line_1":permanentAddressLine1Controller.text,
        "permanent_address_line_2":permanentAddressLine2Controller.text,
        "permanent_address_post_code":permanentPinCodeController.text,
        "permanent_city":permanentCityid,
        "permanent_district":permanentDistrictId,
        "permanent_state":permanentStateId,
        "same_as_current":checkValue?'1':'0',
        "slug": AppModel.slug,
      }
    };*/

    var data = {
      "method_name": "editProfile",
      "data": {
        "first_name":firstNameController.text,
        "last_name":lastNameController.text,
        "location":locationStr,
        "gender":_gender,
        "blood_groups": null,
        "date_of_birth":_formatedDateTime,
        "email":emailController.text,
        "mobile_number":phoneController.text,
        "emergency_contact_number":emergancyphoneController.text,
        "current_address_line_1":currentAddressLine1Controller.text,
        "current_address_line_2":currentAddressLine2Controller.text,
        "current_address_post_code":currentPinCodeController.text,
        "current_state":currentStateId,
        "current_district":currentDistrictId,
        "current_city":currentCityId,
        "permanent_address_line_1":permanentAddressLine1Controller.text,
        "permanent_address_line_2":permanentAddressLine2Controller.text,
        "permanent_address_post_code":permanentPinCodeController.text,
        "permanent_state":permanentStateId,
        "permanent_district":permanentDistrictId,
        "permanent_city":permanentCityid,
        "same_as_current":checkValue?'1':'0',
        "slug": AppModel.slug,
        "current_role": role,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    print(base64.encode(utf8.encode(json.encode(data))));
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('editProfile', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      _editDetailsSuccess(responseJSON);
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  _editDetailsSuccess(var responseJSON) async {
    MyUtils.saveSharedPreferences(
        'name', '${firstNameController.text} ${lastNameController.text}');
    Toast.show(responseJSON['decodedData']['message'].toString(),
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: Colors.green);

    Navigator.of(context).pop("1");
  }
}
