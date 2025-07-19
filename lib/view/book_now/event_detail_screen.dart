import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/book_now/select_offer_screen.dart';
import 'dart:convert';

import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class EventsDetailsScreen extends StatefulWidget {
  final String academySlug;

  EventsDetailsScreen(this.academySlug);

  ActivityDetailsState createState() => ActivityDetailsState();
}

class ActivityDetailsState extends State<EventsDetailsScreen> {
  bool isLoading = false;
  var usernameController = TextEditingController();
  var mobileController = TextEditingController();
  var ratingController = TextEditingController();
  Map<String, dynamic> eventsResults = {};
  String galleryUrl='';

  String target = '';
  String mapLocation = '';
  String targetName = '';
  var userExperiencController = TextEditingController();
  var userExperiencController2 = TextEditingController();
  var userExperiencController3 = TextEditingController();
  var userExperiencController4 = TextEditingController();
  String coachCricketClubName = '';
  double ratingValue = 0.0;
  bool ratingIcon1 = false;
  bool ratingIcon2 = false;
  bool ratingIcon3 = false;
  bool ratingIcon4 = false;
  bool ratingIcon5 = false;
  bool ratingIcon6 = false;
  List<dynamic> coachGalleryData = [];
  int activePage = 1;
  int isKlubbaVerified = 1;
  late PageController _pageController;
  String aboutCoach = '';
  String userProfileImage = '';
  String contactInformation = '';
  String phone = '';
  Map<String,dynamic> packages = {};
  List<dynamic> ratings = [];
  String academyName = '';
  String packageImageUrl = '';

  List<String> images = [];

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
                text: 'Select ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Event',
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
          : ListView(
              children: [
                SizedBox(height: 5),
                  Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(galleryUrl+eventsResults['image']))),
          ),


                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(31)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Event ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.5)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Details',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                                Container(
                                  width: 35,
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
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(eventsResults['title'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5)),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 5, left: 10, right: 35),
                        margin: EdgeInsets.only(left: 10, right: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppTheme.themeColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 0.3, color: Color(0xFF707070))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _verifiedDialog();
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset('assets/verified_ic.png',
                                          width: 22, height: 20),
                                      SizedBox(height: 5),
                                      Text(
                                          isKlubbaVerified == 1
                                              ? 'Not Verified'
                                              : 'Verified',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _smsBottomSheetBottomSheet();
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset('assets/message_ic.png',
                                          width: 20, height: 20),
                                      SizedBox(height: 5),
                                      Text('SMS',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _ratingBottomSheet();
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset('assets/rating_ic.png',
                                          width: 20, height: 20),
                                      SizedBox(height: 5),
                                      Text('Rating',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _editBottomSheet();
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset('assets/edit_blue.png',
                                          width: 20, height: 20),
                                      SizedBox(height: 5),
                                      Text('Edit',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('About',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.blueColor)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          eventsResults['description'],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Contact Details',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.blueColor)),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_pin, color: AppTheme.blueColor),
                            SizedBox(width: 7),
                            Expanded(
                              child: Text(eventsResults['venue'],
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      /*  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.call, color: AppTheme.blueColor, size: 17),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text('9302017754',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black)),
                      ),
                    ],
                  ),
                ),*/
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(31),
                          topRight: Radius.circular(31)),
                      color: Colors.white),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                     /* SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Available ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.5)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Packages',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                                Container(
                                  width: 35,
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
                      SizedBox(height: 25),
                      Container(
                        margin:
                        EdgeInsets.only(left: 12, right: 12),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(4),
                            color: Color(0xFFF3F3F3)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 8),
                             *//* Container(
                                height: 110,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(2),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            packageImageUrl +
                                                packages[
                                                'cover_image']))),
                              ),*//*
                              SizedBox(width: 8),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(packages['title'],
                                          style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: AppTheme
                                                  .blueColor)),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                              '₹ ' +
                                                  packages
                                                  ['price']
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  decoration:
                                                  TextDecoration
                                                      .lineThrough,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  color:
                                                  Colors.grey)),
                                          SizedBox(width: 10),
                                          Text(
                                              '₹ ' +
                                                  packages[
                                                  'discount_price']
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color:
                                                  Colors.black)),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Text('Inclusion of taxes',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black)),
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectOfferScreen(
                                                            packages
                                                            [
                                                            'slug'])));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20),
                                            height: 27,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                color: AppTheme
                                                    .themeColor,
                                                borderRadius:
                                                BorderRadius.only(
                                                    topLeft: Radius
                                                        .circular(
                                                        10),
                                                    topRight: Radius
                                                        .circular(
                                                        10))),
                                            child: Center(
                                              child: Text(
                                                      ' Available',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: AppTheme
                                                          .blueColor)),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),*/
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Reviews &  ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.5)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Ratings',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16)),
                                Container(
                                  width: 35,
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
                      SizedBox(height: 18),
                      ListView.builder(
                          itemCount: ratings.length,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF3F3F3),
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: EdgeInsets.only(
                                      left: 6, right: 6, top: 8, bottom: 5),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ratings[pos]['user_profile_image'] != ''
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  userProfileImage +
                                                      ratings[pos][
                                                              'user_profile_image']
                                                          .toString()),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/dummy_profile.png'),
                                              radius: 27,
                                            ),
                                      SizedBox(width: 8),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(ratings[pos]['user_name']!=null?ratings[pos]['user_name']:"NA",
                                                  style: TextStyle(
                                                      color: AppTheme.blueColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15.5)),
                                              Spacer(),
                                              RatingBar.builder(
                                                initialRating: ratings[pos]
                                                        ['rating']
                                                    .toDouble(),
                                                minRating: 1,
                                                itemSize: 16,
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 1.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                              ratings[pos]['comment'] != null
                                                  ? ratings[pos]['comment']
                                                  : 'No comments',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.5),
                                              maxLines: 3),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10)
                              ],
                            );
                          })
                    ],
                  ),
                )
              ],
            ),
    );
  }

  coachDetails(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');

    var data = {
      "method_name": "eventDetailForHomePage",
      "data": {
        "event_slug": widget.academySlug,
        "type": "event",
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": null,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'eventDetailForHomePage', requestModel, context);
    var responseJSON = json.decode(response.body);
   // coachGalleryData = responseJSON['decodedData']['result']['gallery'];
    galleryUrl = responseJSON['decodedData']['gallery_url'];
    packageImageUrl = responseJSON['decodedData']['package_image_url'];
    packages = responseJSON['decodedData']['package'];
    academyName = responseJSON['decodedData']['user_details']['first_name'] +
        ' ' +
        responseJSON['decodedData']['user_details']['last_name'];
    ratings = responseJSON['decodedData']['reviews'];
    userProfileImage = responseJSON['decodedData']['image_url'];
    eventsResults = responseJSON['decodedData']['result'];
    isKlubbaVerified =
        responseJSON['decodedData']['user_details']['is_klubba_verified'];
/*
    for (int i = 0; i < coachGalleryData.length; i++) {
      images.add(baseUrl + coachGalleryData[i]['image']);
    }*/
    isLoading = false;
    setState(() {});
    print(responseJSON);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 1.0, initialPage: 1);
    coachDetails(context);
    _fetchUserDetails();
  }

  _fetchUserDetails() async {
    var fullName = await MyUtils.getSharedPreferences('full_name');
    var mobileNumber = await MyUtils.getSharedPreferences('mobile_number');
    usernameController.text = fullName.toString();
    mobileController.text = mobileNumber.toString();
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 8 : 8;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage(images[pagePosition]))),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(5),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.45),
            shape: BoxShape.circle),
      );
    });
  }

  _smsBottomSheetBottomSheet() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                          width: 80, height: 3, color: Color(0xFFAAAAAA)),
                    ),
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
                            child: Text('Get ',
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
                              Text('Information by Sms',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
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
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('User Name',
                          style: TextStyle(
                              color: AppTheme.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xFFF6F6F6),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                          controller: usernameController,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 7),
                              hintText: 'Smith',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('Mobile',
                          style: TextStyle(
                              color: AppTheme.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xFFF6F6F6),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 7),
                              hintText: '9988776655',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 15),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1A1A1A),
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                text:
                                    'By clicking on submit button. You agree to our ',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                              TextSpan(
                                text: 'T&C',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 27),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 37, right: 37, top: 5, bottom: 25),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Submit',
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
                            if (usernameController.text.isNotEmpty &&
                                mobileController.text.isNotEmpty) {
                              Navigator.pop(context);
                              sendInformationAPI(context);
                            }
                          }),
                    )
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

  _editBottomSheet() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                          width: 80, height: 3, color: Color(0xFFAAAAAA)),
                    ),
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
                            child: Text('Help Us ',
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
                              Text('Improve Listing',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
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
                    SizedBox(height: 10),
                    Center(
                      child: Text('Select from the options below',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                    SizedBox(height: 7),
                    Divider(),
                    SizedBox(height: 5),
                    ExpansionTile(
                      initiallyExpanded: false,
                      collapsedBackgroundColor: Color(0xFFF6F6F6),
                      backgroundColor: Color(0xFFF6F6F6),
                      title: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 47,
                        alignment: Alignment.centerLeft,
                        color: Color(0xFFF6F6F6),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: const Text(
                            "Report As Inaccurate",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          color: Color(0xFfF6F6F6),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextFormField(
                                      controller: userExperiencController,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(left: 5, top: 5),
                                          hintText: 'Enter your Report',
                                          hintStyle: TextStyle(
                                            fontSize: 13.0,
                                            color: Color(0xFF9A9CB8),
                                          ))),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, top: 5, bottom: 5),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      child: Text('Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5)),
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ))),
                                      onPressed: () {
                                        if (userExperiencController == '') {
                                          Toast.show('Report cannot be empty',
                                              duration: Toast.lengthLong,
                                              gravity: Toast.bottom,
                                              backgroundColor: Colors.red);
                                        } else {
                                          reportUser(
                                              context,
                                              'Report as inaccurate',
                                              userExperiencController.text);
                                        }
                                      }),
                                ),
                                SizedBox(height: 12)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    ExpansionTile(
                      initiallyExpanded: false,
                      collapsedBackgroundColor: Color(0xFFF6F6F6),
                      backgroundColor: Color(0xFFF6F6F6),
                      title: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 47,
                        alignment: Alignment.centerLeft,
                        color: Color(0xFFF6F6F6),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: const Text(
                            "Report Abuse",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          color: Color(0xFfF6F6F6),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextFormField(
                                      controller: userExperiencController2,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(left: 5, top: 5),
                                          hintText: 'Enter your Report',
                                          hintStyle: TextStyle(
                                            fontSize: 13.0,
                                            color: Color(0xFF9A9CB8),
                                          ))),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, top: 5, bottom: 5),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      child: Text('Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5)),
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ))),
                                      onPressed: () {
                                        if (userExperiencController2 == '') {
                                          Toast.show('Report cannot be empty',
                                              duration: Toast.lengthLong,
                                              gravity: Toast.bottom,
                                              backgroundColor: Colors.red);
                                        } else {
                                          reportUser(context, 'Report abuse',
                                              userExperiencController2.text);
                                        }
                                      }),
                                ),
                                SizedBox(height: 12)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    ExpansionTile(
                      initiallyExpanded: false,
                      collapsedBackgroundColor: Color(0xFFF6F6F6),
                      backgroundColor: Color(0xFFF6F6F6),
                      title: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 47,
                        alignment: Alignment.centerLeft,
                        color: Color(0xFFF6F6F6),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: const Text(
                            "Report That Business Has Shutdown",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          color: Color(0xFfF6F6F6),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextFormField(
                                      controller: userExperiencController3,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(left: 5, top: 5),
                                          hintText: 'Enter your Report',
                                          hintStyle: TextStyle(
                                            fontSize: 13.0,
                                            color: Color(0xFF9A9CB8),
                                          ))),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, top: 5, bottom: 5),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      child: Text('Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5)),
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ))),
                                      onPressed: () {
                                        if (userExperiencController3 == '') {
                                          Toast.show('Report cannot be empty',
                                              duration: Toast.lengthLong,
                                              gravity: Toast.bottom,
                                              backgroundColor: Colors.red);
                                        } else {
                                          reportUser(
                                              context,
                                              'Report that business has shutdown',
                                              userExperiencController3.text);
                                        }
                                      }),
                                ),
                                SizedBox(height: 12)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    ExpansionTile(
                      initiallyExpanded: false,
                      collapsedBackgroundColor: Color(0xFFF6F6F6),
                      backgroundColor: Color(0xFFF6F6F6),
                      title: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 47,
                        alignment: Alignment.centerLeft,
                        color: Color(0xFFF6F6F6),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: const Text(
                            "Own Listing",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          color: Color(0xFfF6F6F6),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextFormField(
                                      controller: userExperiencController4,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(left: 5, top: 5),
                                          hintText: 'Enter your Report',
                                          hintStyle: TextStyle(
                                            fontSize: 13.0,
                                            color: Color(0xFF9A9CB8),
                                          ))),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, top: 5, bottom: 5),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      child: Text('Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.5)),
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ))),
                                      onPressed: () {
                                        if (userExperiencController4 == '') {
                                          Toast.show('Report cannot be empty',
                                              duration: Toast.lengthLong,
                                              gravity: Toast.bottom,
                                              backgroundColor: Colors.red);
                                        } else {
                                          reportUser(context, 'Own listing',
                                              userExperiencController4.text);
                                        }
                                      }),
                                ),
                                SizedBox(height: 12)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 27),
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

  _verifiedDialog() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                          width: 80, height: 3, color: Color(0xFFAAAAAA)),
                    ),
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
                            child: Text('Klubba ',
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
                              Text('Verified',
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
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('What is klubba Verified?',
                          style: TextStyle(
                              color: AppTheme.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          '"Klubba verified" means, the information related to name, address, contact details of the business establishments have been verified as existing at the time of registering any advertiser with Klubba.This verification is solely based on the documents as supplied by an advertiser/ s or as per the details contained in Customer Registration Form.We strongly recommend our Users/ callers to exercise their discretion & amp; due diligence about all relevant aspects prior to availing any products/ services.Please note that Just Dial does not implicitly or explicitly endorse any product\'s or services provided by advertisers/service providers.',
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.8,
                              fontWeight: FontWeight.w500,
                              fontSize: 12)),
                    ),
                    SizedBox(height: 27),
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, true ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  _ratingBottomSheet() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                          width: 80, height: 3, color: Color(0xFFAAAAAA)),
                    ),
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
                            child: Text('Share ',
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
                              Text('Your Experience',
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
                    SizedBox(height: 5),
                    Center(
                      child: Text('Please spare a minute to rate',
                          style: TextStyle(
                              color: AppTheme.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5)),
                    ),
                    SizedBox(height: 4),
                    Center(
                      child: Text('What went wrong ?',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: AppTheme.themeColor,
                        ),
                        onRatingUpdate: (rating) {
                          ratingValue = rating;
                          print(rating);
                        },
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                      child: ratingIcon1
                                          ? Icon(
                                              Icons.check_box,
                                              color: AppTheme.themeColor,
                                            )
                                          : Icon(Icons
                                              .check_box_outline_blank_outlined),
                                      onTap: () {
                                        dialogState(() {
                                          ratingIcon1 = !ratingIcon1;
                                        });
                                      }),
                                  SizedBox(width: 7),
                                  Text('Coaching',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ],
                              ),
                              flex: 1),
                          Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                      child: ratingIcon2
                                          ? Icon(
                                              Icons.check_box,
                                              color: AppTheme.themeColor,
                                            )
                                          : Icon(Icons
                                              .check_box_outline_blank_outlined),
                                      onTap: () {
                                        dialogState(() {
                                          ratingIcon2 = !ratingIcon2;
                                        });
                                      }),
                                  SizedBox(width: 7),
                                  Text('Punctuality',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ],
                              ),
                              flex: 1)
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                GestureDetector(
                                    child: ratingIcon3
                                        ? Icon(
                                            Icons.check_box,
                                            color: AppTheme.themeColor,
                                          )
                                        : Icon(Icons
                                            .check_box_outline_blank_outlined),
                                    onTap: () {
                                      dialogState(() {
                                        ratingIcon3 = !ratingIcon3;
                                      });
                                    }),
                                SizedBox(width: 7),
                                Text('Communication',
                                    style: TextStyle(
                                        color: AppTheme.blueColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                      child: ratingIcon4
                                          ? Icon(
                                              Icons.check_box,
                                              color: AppTheme.themeColor,
                                            )
                                          : Icon(Icons
                                              .check_box_outline_blank_outlined),
                                      onTap: () {
                                        dialogState(() {
                                          ratingIcon4 = !ratingIcon4;
                                        });
                                      }),
                                  SizedBox(width: 7),
                                  Text('Attitude',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ],
                              ),
                              flex: 1)
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                      child: ratingIcon5
                                          ? Icon(
                                              Icons.check_box,
                                              color: AppTheme.themeColor,
                                            )
                                          : Icon(Icons
                                              .check_box_outline_blank_outlined),
                                      onTap: () {
                                        dialogState(() {
                                          ratingIcon5 = !ratingIcon5;
                                        });
                                      }),
                                  SizedBox(width: 7),
                                  Text('Course Material',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ],
                              ),
                              flex: 1),
                          Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                      child: ratingIcon6
                                          ? Icon(
                                              Icons.check_box,
                                              color: AppTheme.themeColor,
                                            )
                                          : Icon(Icons
                                              .check_box_outline_blank_outlined),
                                      onTap: () {
                                        dialogState(() {
                                          ratingIcon6 = !ratingIcon6;
                                        });
                                      }),
                                  SizedBox(width: 7),
                                  Text('Others',
                                      style: TextStyle(
                                          color: AppTheme.blueColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ],
                              ),
                              flex: 1)
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('User Name',
                          style: TextStyle(
                              color: AppTheme.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                    SizedBox(height: 7),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xFFF6F6F6),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                          controller: userExperiencController,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          maxLines: 4,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5, top: 5),
                              hintText: 'Enter your experience',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9A9CB8),
                              ))),
                    ),
                    SizedBox(height: 27),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 25),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Submit',
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
                            _validateRating();
                          }),
                    )
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

  sendInformationAPI(BuildContext context) async {
    APIDialog.showAlertDialog(context, "Sending message");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "sendInformationBySMS",
      "data": {
        "name": usernameController.text,
        "mobile_number": mobileController.text,
        "target_name": targetName,
        "type": "event",
        "target": target,
        "owner": "639d9c65d95d1e1a88657aa8",
        "address": mapLocation,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('sendInformationBySMS', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show('Message sent successfully',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }

  saveRating(BuildContext context) async {
    APIDialog.showAlertDialog(context, "Adding Review...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "saveRating",
      "data": {
        "rate_user_slug": widget.academySlug,
        "rating": 5,
        "comment": usernameController.text,
        "rating_options": [
          "5e85dc45fccaa21f8068702f",
          "5e85dc4cfccaa21f80687034"
        ],
        "type": "event",
        "target": eventsResults['_id'],
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saveRating', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }

  reportUser(BuildContext context, String subject, String message) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    String? name = await MyUtils.getSharedPreferences('full_name');
    String? email = await MyUtils.getSharedPreferences('email');
    String? mobileNumber = await MyUtils.getSharedPreferences('mobile_number');

    var data = {
      "method_name": "saveContact",
      "data": {
        "slug": AppModel.slug,
        "message": message,
        "target": eventsResults['_id'],
        "target_type": "event",
        "target_name": eventsResults['title'],
        "target_link": "",
        "subject": subject,
        "enquiry_type": "report",
        "first_name": name,
        "last_name": "",
        "email": email,
        "phone_no": mobileNumber,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saveContact', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }

  _validateRating() {
    if (ratingValue == 0.0) {
      Toast.show('Rating cannot be empty',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (!ratingIcon1 &&
        !ratingIcon2 &&
        !ratingIcon3 &&
        !ratingIcon4 &&
        !ratingIcon5 &&
        !ratingIcon6) {
      Toast.show('Please select a category',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      Navigator.pop(context);
      saveRating(context);
    }
  }
}
