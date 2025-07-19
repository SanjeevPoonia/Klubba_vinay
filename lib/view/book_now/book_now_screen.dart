import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/book_now/academy_detail_screen.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/menu/cart_screen.dart';
import 'package:klubba/view/book_now/event_detail_screen.dart';
import 'package:klubba/view/notification/notification_screen.dart';
import 'package:klubba/view/book_now/select_coach_screen.dart';
import 'dart:convert';
import 'package:klubba/widgets/loader.dart';
import 'package:toast/toast.dart';

class BookNowScreen extends StatefulWidget {
  BookState createState() => BookState();
}

class BookState extends State<BookNowScreen> {
  bool isLoading = false;
  String? currentCategoryId = '';
  bool isPagLoading = false;
  int _page = 1;
  bool loadMoreData = true;

  bool isPagLoading2 = false;
  int _page2 = 1;
  bool loadMoreData2 = true;
  String locationName = 'Malviya Nagar, Jaipur';
  String locationPin = '302017';
  double currentLat=26.9124;
  double currentLong=75.7873;
  String searchType = 'coach';
  Map<String, dynamic> pinResults = {};
  bool locationFilter = false;
  List<dynamic> coachList = [];
  String currentCategoryName = '';
  List<dynamic> eventsList = [];
  List<dynamic> programsList = [];
  List<dynamic> workshopList = [];
  var pinController = TextEditingController();
  List<dynamic> academyList = [];
  List<dynamic> hotPackagelist = [];
  List<dynamic> exclusivePackagelist = [];
  List<dynamic> popularPackagelist = [];
  List<dynamic> categoryList = [];
  int selectedIndex = 0;
  int selectedCateIndex = 0;
  String imageUrl = '';
  String currentCategoryImageUrl = '';
  String categoryBaseUrl = '';
  String eventImageUrl = '';

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.themeColor,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
            },
            child: Padding(
                padding: EdgeInsets.only(right: 13),
                child:
                    Icon(Icons.notifications, color: Colors.black, size: 27)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen(false)));
            },
            child: Padding(
                padding: EdgeInsets.only(right: 13),
                child:
                    Icon(Icons.shopping_cart, color: Colors.black, size: 27)),
          ),
        ],
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Book ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Now',
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
          ? Loader()
          : ListView(
              children: [
                InkWell(
                  onTap: () {
                    _changeAddressBottomSheet();
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Icon(Icons.location_on,
                              color: AppTheme.blueColor, size: 26),
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              SizedBox(height: 12),
                              Text(locationName,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.blueColor)),
                              Text(locationPin,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.blueColor)),
                            ]))
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: AppTheme.themeColor,
                ),
                const SizedBox(height: 7),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 76,
                  child: ListView.builder(
                      itemCount: categoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int pos) {
                        return Row(
                          children: [
                            InkWell(
                              child: Container(
                                width:100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: selectedCateIndex ==
                                            pos /*|| categoryList[pos]['category_id']==currentCategoryId*/
                                        ? AppTheme.themeColor
                                        : const Color(0xFFF3F3F3)),
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Image.network(
                                        categoryBaseUrl +
                                            categoryList[pos]['category_image'],
                                        width: 35,
                                        height: 35),

                                    SizedBox(height: 5),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(categoryList[pos]['category'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),textAlign: TextAlign.center,maxLines: 2,),
                                    ),



                                  ],
                                )
                              ),
                              onTap: () {
                                MyUtils.saveSharedPreferences('current_category_id',categoryList[pos]
                                ['category_id']);


                                setState(() {
                                  selectedCateIndex = pos;
                                });
                                refreshHomeScreenData(categoryList[pos]);
                              },
                            ),
                            const SizedBox(width: 7)
                          ],
                        );
                      }),
                ),
                SizedBox(height: 20),
              /*  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('Select ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.5)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text('Offer',
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
                hotPackagelist.length == 0 ? Container() : SizedBox(height: 10),
                hotPackagelist.length == 0
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                      color: AppTheme.themeColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text('Hot Package',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black)),
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 5),
                            Expanded(
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF3F3F3),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text('Exclusive',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF9A9CB8))),
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 5),
                            Expanded(
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF3F3F3),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text('Most Popular',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF9A9CB8))),
                                  ),
                                ),
                                flex: 1)
                          ],
                        )),
                hotPackagelist.length == 0 ? Container() : SizedBox(height: 15),
                hotPackagelist.length == 0
                    ? Container(
                        height: 100,
                        child: Center(child: Text('No Offers found')),
                      )
                    : Container(
                        height: 235,
                        child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int pos) {
                              return Row(
                                children: [
                                  Container(
                                    width: 160,
                                    margin: EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color(0xFFF3F3F3)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight:
                                                      Radius.circular(12)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      'assets/dummy_thumb.png'))),
                                        ),
                                        SizedBox(height: 7),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Row(
                                            children: [
                                              Text('Membership',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppTheme.blueColor)),
                                              Spacer(),
                                              Icon(Icons.star,
                                                  size: 11.5,
                                                  color: AppTheme.themeColor),
                                              Icon(Icons.star,
                                                  size: 11.5,
                                                  color: AppTheme.themeColor),
                                              Icon(Icons.star,
                                                  size: 11.5,
                                                  color: AppTheme.themeColor),
                                              Icon(Icons.star,
                                                  size: 11.5,
                                                  color: AppTheme.themeColor),
                                              Icon(Icons.star_border,
                                                  size: 11.5,
                                                  color: AppTheme.themeColor),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text(
                                              'Cricket Competition (11Th To 12Th Senior- 2)',
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black)),
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text('₹ 2400.00',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                        ),
                                        SizedBox(height: 14),
                                        Center(
                                          child: Container(
                                            width: 103,
                                            height: 39,
                                            child: ElevatedButton(
                                                child: Text('Explore',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13)),
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.black),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ))),
                                                onPressed: () {
                                                  *//* Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SelectOfferScreen()));*//*
                                                }),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5)
                                ],
                              );
                            }),
                      ),
                SizedBox(height: 15),*/
                Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 41,
                            decoration: BoxDecoration(
                                color: selectedIndex == 0
                                    ? AppTheme.themeColor
                                    : Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text('Coach',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == 0
                                          ? Colors.black
                                          : Color(0xFF9A9CB8))),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 41,
                            decoration: BoxDecoration(
                                color: selectedIndex == 1
                                    ? AppTheme.themeColor
                                    : Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text('Academy',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == 1
                                          ? Colors.black
                                          : Color(0xFF9A9CB8))),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 2;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 41,
                            decoration: BoxDecoration(
                                color: selectedIndex == 2
                                    ? AppTheme.themeColor
                                    : Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text('Events',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == 2
                                          ? Colors.black
                                          : Color(0xFF9A9CB8))),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 3;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 41,
                            decoration: BoxDecoration(
                                color: selectedIndex == 3
                                    ? AppTheme.themeColor
                                    : Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text('Workshop',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == 3
                                          ? Colors.black
                                          : Color(0xFF9A9CB8))),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                     /*   InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 4;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 41,
                            decoration: BoxDecoration(
                                color: selectedIndex == 4
                                    ? AppTheme.themeColor
                                    : Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text('Programs',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == 4
                                          ? Colors.black
                                          : Color(0xFF9A9CB8))),
                            ),
                          ),
                        ),*/
                      //  SizedBox(width: 10),
                      ],
                    )),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('Select ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.5)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                              selectedIndex == 0
                                  ? 'Coach'
                                  : selectedIndex == 1
                                      ? 'Academy'
                                      : selectedIndex == 2
                                          ? 'Events'
                                          : selectedIndex == 3
                                              ? 'Workshop'
                                              : selectedIndex == 4
                                                  ? 'Programs'
                                                  : '',
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
                SizedBox(height: 10),
                selectedIndex == 0
                    ? coachList.length == 0
                        ? Center(
                            child: Text('No Data found'),
                          )
                        : Column(
                    children: [
                      ListView.builder(
                          itemCount: coachList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(4),
                                        color: const Color(0xFFF3F3F3)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 8),

                                          coachList[pos][
                                          'coach_image']!=null?
                                          Container(
                                            height: 110,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(2),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(imageUrl +
                                                        coachList[pos][
                                                        'coach_image']))),
                                          ): Container(
                                            height: 110,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(2),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        "assets/ic_no_photo.png"))),
                                          ),



                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      coachList[pos]
                                                      ['coach_name'],
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: Colors.black)),
                                                  Text(currentCategoryName,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: AppTheme
                                                              .blueColor)),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star,
                                                          size: 11.5,
                                                          color: AppTheme
                                                              .themeColor),
                                                      Icon(Icons.star,
                                                          size: 11.5,
                                                          color: AppTheme
                                                              .themeColor),
                                                      Icon(Icons.star,
                                                          size: 11.5,
                                                          color: AppTheme
                                                              .themeColor),
                                                      Icon(Icons.star,
                                                          size: 11.5,
                                                          color: AppTheme
                                                              .themeColor),
                                                      Icon(Icons.star_border,
                                                          size: 11.5,
                                                          color: AppTheme
                                                              .themeColor),
                                                    ],
                                                  ),
                                                  SizedBox(height: 7),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                          Icons.location_on_sharp,
                                                          color:
                                                          AppTheme.blueColor,
                                                          size: 13),
                                                      Expanded(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 5),
                                                            child: Text(
                                                              coachList[pos]
                                                              ['map_location'],
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                  FontWeight.w600,
                                                                  color:
                                                                  Colors.black),
                                                              maxLines: 2,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  /*  Container(
                                                  width: 103,
                                                  height: 39,
                                                  child: ElevatedButton(
                                                      child: Text('Explore',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              fontSize: 13)),
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStateProperty.all<
                                                                      Color>(
                                                                  Colors.white),
                                                          backgroundColor:
                                                              MaterialStateProperty.all<
                                                                      Color>(
                                                                  Colors.black),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(4),
                                                          ))),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SelectCoachScreen(
                                                                        coachList[
                                                                                pos]
                                                                            [
                                                                            'coach_slug'])));
                                                      }),
                                                ),*/

                                                  Text('Explore',
                                                      style: TextStyle(
                                                          color:
                                                          Colors.blueAccent,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          decoration:
                                                          TextDecoration
                                                              .underline,
                                                          fontSize: 13)),
                                                  SizedBox(height: 8),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectCoachScreen(
                                                    coachList[pos]
                                                    ['coach_slug'])));
                                  },
                                ),
                                SizedBox(height: 10)
                              ],
                            );
                          }),


                      isPagLoading
                          ? Container(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Center(
                          child: Loader(),
                        ),
                      ):


                      loadMoreData && coachList.length>3?
                      Center(
                          child: GestureDetector(
                              onTap: () {
                                _page++;
                                if (loadMoreData) {
                                  setState(() {
                                    isPagLoading = true;
                                  });
                                  coachPaginateAPI(context,true, _page);
                                }
                              },
                              child: Icon(
                                Icons.refresh,
                                size: 32,
                                color: AppTheme.blueColor,
                              ))):Container(),
                      
                      SizedBox(height: 10),

                    ],
                )
                    : selectedIndex == 1
                        ? academyList.length == 0
                            ? Center(
                                child: Text('No Data found'),
                              )
                            : Column(
                              children: [
                                ListView.builder(
                                    itemCount: academyList.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int pos) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 12, right: 12),
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
                                                    Container(
                                                      height: 110,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  imageUrl +
                                                                      academyList[
                                                                              pos][
                                                                          'user_image']))),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            academyList[pos][
                                                                'organization_name'],
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                color:
                                                                    Colors.black)),
                                                        Text(currentCategoryName,
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: AppTheme
                                                                    .blueColor)),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(Icons.star_border,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                          ],
                                                        ),
                                                        SizedBox(height: 7),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .location_on_sharp,
                                                                color: AppTheme
                                                                    .blueColor,
                                                                size: 13),
                                                            Expanded(
                                                                child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              child: Text(
                                                                academyList[pos][
                                                                    'map_location'],
                                                                style: const TextStyle(
                                                                    fontSize: 10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        /*  Container(
                                                          width: 103,
                                                          height: 39,
                                                          child: ElevatedButton(
                                                              child: Text('Explore',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: 13)),
                                                              style: ButtonStyle(
                                                                  foregroundColor:
                                                                      MaterialStateProperty.all<Color>(
                                                                          Colors
                                                                              .white),
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<Color>(
                                                                          Colors
                                                                              .black),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                  ))),
                                                              onPressed: () {
                                                                print('Click triggered');
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AcademyDetailsScreen(academyList[pos]['user_slug'])));
                                                              }),
                                                        ),*/

                                                        Text('Explore',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 13)),
                                                        SizedBox(height: 8),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AcademyDetailsScreen(
                                                              academyList[pos]
                                                                  ['user_slug'])));
                                            },
                                          ),
                                          SizedBox(height: 10)
                                        ],
                                      );
                                    }),

                                isPagLoading2
                                    ? Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  child: Center(
                                    child: Loader(),
                                  ),
                                ):


                                loadMoreData2 && academyList.length>3?
                                Center(
                                    child: GestureDetector(
                                        onTap: () {
                                          _page2++;
                                          if (loadMoreData2) {
                                            setState(() {
                                              isPagLoading2 = true;
                                            });
                                            academyPaginateAPI(context,true, _page2);
                                          }
                                        },
                                        child: Icon(
                                          Icons.refresh,
                                          size: 32,
                                          color: AppTheme.blueColor,
                                        ))):Container(),

                                SizedBox(height: 10),
                              ],
                            )
                        : selectedIndex == 2
                            ? eventsList.length == 0
                                ? Center(
                                    child: Text('No Data found'),
                                  )
                                : ListView.builder(
                                    itemCount: eventsList.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int pos) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 12, right: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xFFF3F3F3)),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Container(
                                                      height: 110,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  eventImageUrl +
                                                                      eventsList[
                                                                              pos]
                                                                          [
                                                                          'image']))),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            eventsList[pos]
                                                                ['title'],
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black)),
                                                        Text(
                                                            currentCategoryName,
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppTheme
                                                                    .blueColor)),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(Icons.star,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                            Icon(
                                                                Icons
                                                                    .star_border,
                                                                size: 11.5,
                                                                color: AppTheme
                                                                    .themeColor),
                                                          ],
                                                        ),
                                                        SizedBox(height: 7),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .location_on_sharp,
                                                                color: AppTheme
                                                                    .blueColor,
                                                                size: 13),
                                                            Expanded(
                                                                child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              child: Text(
                                                                eventsList[pos]
                                                                    ['venue'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        /*   InkWell(
                                                          onTap:(){
                                                           */ /* Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        AcademyDetailsScreen(academyList[pos]['user_slug'])));*/ /*
                                            },
                                                          child: Container(
                                                            width: 103,
                                                            height: 39,
                                                            child: ElevatedButton(
                                                                child: Text('Explore',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            13)),
                                                                style: ButtonStyle(
                                                                    foregroundColor:
                                                                        MaterialStateProperty.all<Color>(Colors
                                                                            .white),
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all<Color>(Colors
                                                                            .black),
                                                                    shape: MaterialStateProperty.all<
                                                                            RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  4),
                                                                    ))),
                                                                onPressed: () {


                                                                }),
                                                          ),
                                                        ),*/

                                                        Text('Explore',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 13)),
                                                        SizedBox(height: 8),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EventsDetailsScreen(
                                                              eventsList[pos]
                                                                  ['slug'])));
                                            },
                                          ),
                                          SizedBox(height: 10)
                                        ],
                                      );
                                    })
                            : selectedIndex == 4
                                ? programsList.length == 0
                                    ? Center(
                                        child: Text('No Data found'),
                                      )
                                    : ListView.builder(
                                        itemCount: programsList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int pos) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 12, right: 12),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Color(0xFFF3F3F3)),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 8),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 8),
                                                        Container(
                                                          height: 110,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image:
                                                                      NetworkImage(
                                                                          ""))),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black)),
                                                            Text(
                                                                currentCategoryName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppTheme
                                                                        .blueColor)),
                                                            Row(
                                                              children: [
                                                                Icon(Icons.star,
                                                                    size: 11.5,
                                                                    color: AppTheme
                                                                        .themeColor),
                                                                Icon(Icons.star,
                                                                    size: 11.5,
                                                                    color: AppTheme
                                                                        .themeColor),
                                                                Icon(Icons.star,
                                                                    size: 11.5,
                                                                    color: AppTheme
                                                                        .themeColor),
                                                                Icon(Icons.star,
                                                                    size: 11.5,
                                                                    color: AppTheme
                                                                        .themeColor),
                                                                Icon(
                                                                    Icons
                                                                        .star_border,
                                                                    size: 11.5,
                                                                    color: AppTheme
                                                                        .themeColor),
                                                              ],
                                                            ),
                                                            SizedBox(height: 7),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .location_on_sharp,
                                                                    color: AppTheme
                                                                        .blueColor,
                                                                    size: 13),
                                                                Expanded(
                                                                    child:
                                                                        Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                  child: Text(
                                                                    "",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black),
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ))
                                                              ],
                                                            ),
                                                            SizedBox(height: 5),
                                                            /*   InkWell(
                                                          onTap:(){
                                                           */ /* Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        AcademyDetailsScreen(academyList[pos]['user_slug'])));*/ /*
                                            },
                                                          child: Container(
                                                            width: 103,
                                                            height: 39,
                                                            child: ElevatedButton(
                                                                child: Text('Explore',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            13)),
                                                                style: ButtonStyle(
                                                                    foregroundColor:
                                                                        MaterialStateProperty.all<Color>(Colors
                                                                            .white),
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all<Color>(Colors
                                                                            .black),
                                                                    shape: MaterialStateProperty.all<
                                                                            RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  4),
                                                                    ))),
                                                                onPressed: () {


                                                                }),
                                                          ),
                                                        ),*/

                                                            Text('Explore',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    fontSize:
                                                                        13)),
                                                            SizedBox(height: 8),
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EventsDetailsScreen(
                                                                  eventsList[
                                                                          pos][
                                                                      'slug'])));
                                                },
                                              ),
                                              SizedBox(height: 10)
                                            ],
                                          );
                                        })
                                : selectedIndex == 3
                                    ? workshopList.length == 0
                                        ? Center(
                                            child: Text('No Data found'),
                                          )
                                        : ListView.builder(
                                            itemCount: workshopList.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int pos) {
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 12, right: 12),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: Color(
                                                              0xFFF3F3F3)),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(width: 8),
                                                            Container(
                                                              height: 110,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: NetworkImage(
                                                                          ""))),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Expanded(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text("",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black)),
                                                                Text(
                                                                    currentCategoryName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: AppTheme
                                                                            .blueColor)),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            11.5,
                                                                        color: AppTheme
                                                                            .themeColor),
                                                                    Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            11.5,
                                                                        color: AppTheme
                                                                            .themeColor),
                                                                    Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            11.5,
                                                                        color: AppTheme
                                                                            .themeColor),
                                                                    Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            11.5,
                                                                        color: AppTheme
                                                                            .themeColor),
                                                                    Icon(
                                                                        Icons
                                                                            .star_border,
                                                                        size:
                                                                            11.5,
                                                                        color: AppTheme
                                                                            .themeColor),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 7),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .location_on_sharp,
                                                                        color: AppTheme
                                                                            .blueColor,
                                                                        size:
                                                                            13),
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        "",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                /*   InkWell(
                                                          onTap:(){
                                                           */ /* Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        AcademyDetailsScreen(academyList[pos]['user_slug'])));*/ /*
                                            },
                                                          child: Container(
                                                            width: 103,
                                                            height: 39,
                                                            child: ElevatedButton(
                                                                child: Text('Explore',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            13)),
                                                                style: ButtonStyle(
                                                                    foregroundColor:
                                                                        MaterialStateProperty.all<Color>(Colors
                                                                            .white),
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all<Color>(Colors
                                                                            .black),
                                                                    shape: MaterialStateProperty.all<
                                                                            RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  4),
                                                                    ))),
                                                                onPressed: () {


                                                                }),
                                                          ),
                                                        ),*/

                                                                Text('Explore',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueAccent,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        fontSize:
                                                                            13)),
                                                                SizedBox(
                                                                    height: 8),
                                                              ],
                                                            ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EventsDetailsScreen(
                                                                      eventsList[
                                                                              pos]
                                                                          [
                                                                          'slug'])));
                                                    },
                                                  ),
                                                  SizedBox(height: 10)
                                                ],
                                              );
                                            })
                                    : Container()
              ],
            ),
    );
  }

  bookingAPI(BuildContext context, bool pinCodeFilter) async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "newGetHomeContent",
      "data": {
    /*    "search_type": 'facilities',
        "category_group": "",
        "category": catId,
        "category_name": "",
        "location": "",*/
        "category":catId,
        "latitude": currentLat,
        "longitude": currentLong,
        "address": "",
        "zipcode": pinCodeFilter ? pinController.text : "",
        "type": [
          "coach",
          "workshop",
          "facilities",
          "event",
          "most_watched",
          "categories",
          "trending"
        ],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 12,
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
        await helper.postAPI('newGetHomeContent', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'] == 'success') {}
    /* totalKandy = responseJSON['decodedData']['result']['total'].toString();
    AvailableKandy = responseJSON['decodedData']['result']['available'].toString();*/
    isLoading = false;
    print('Decoded');
    imageUrl = responseJSON['decodedData']['coach_list']['image_url'];
    eventImageUrl = responseJSON['decodedData']['event_image_url'];
    coachList = responseJSON['decodedData']['coach_list']['list'];
    print("Coach Length"+coachList.length.toString());
    hotPackagelist = responseJSON['decodedData']['hot_package_list']['list'];
    exclusivePackagelist =
        responseJSON['decodedData']['exclusive_package_list']['list'];
    popularPackagelist =
        responseJSON['decodedData']['popular_package_list']['list'];
    eventsList = responseJSON['decodedData']['event_list']['list'];
    academyList = responseJSON['decodedData']['facility_list']['list'];
    programsList = responseJSON['decodedData']['workshop_list']['list'];
    workshopList = responseJSON['decodedData']['workshop_list']['list'];
    print(workshopList.length.toString());
    /*  categoryList =
        responseJSON['decodedData']['categories'][0]['sub_categories'];*/

    setState(() {});
    print(responseJSON);
  }
  coachPaginateAPI(BuildContext context, bool pinCodeFilter, int page) async {
    setState(() {
      isPagLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "newGetHomeContent",
      "data": {
        "latitude": currentLat,
        "longitude": currentLong,
        "address": "",
        "zipcode": pinCodeFilter ? pinController.text : "",
        "type": [
          "coach",
        ],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": page,
        "pageSize": 9,
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
    await helper.postAPI('newGetHomeContent', requestModel, context);
    var responseJSON = json.decode(response.body);
    isPagLoading = false;
    imageUrl = responseJSON['decodedData']['coach_list']['image_url'];
    List<dynamic> newCoachList = responseJSON['decodedData']['coach_list']['list'];
    if (newCoachList.length == 0) {
      loadMoreData = false;
    } else {
      List<dynamic> combo = coachList + newCoachList;
      coachList = combo;
    }

    setState(() {});
    print(responseJSON);
  }
  academyPaginateAPI(BuildContext context, bool pinCodeFilter, int page) async {
    setState(() {
      isPagLoading2 = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "newGetHomeContent",
      "data": {
        "latitude": currentLat,
        "longitude": currentLong,
        "address": "",
        "zipcode": pinCodeFilter ? pinController.text : "",
        "type": [
          "facilities",
        ],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": page,
        "pageSize": 9,
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
    await helper.postAPI('newGetHomeContent', requestModel, context);
    var responseJSON = json.decode(response.body);
    isPagLoading2 = false;
    List<dynamic> newAcademyList = responseJSON['decodedData']['facility_list']['list'];
    if (newAcademyList.length == 0) {
      loadMoreData2 = false;
    } else {
      List<dynamic> combo = academyList + newAcademyList;
      academyList = combo;
    }

    setState(() {});
    print(responseJSON);
  }
  updateData(BuildContext context, Map<String, dynamic> categoryData) async {
    currentCategoryName = categoryData['category'];
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "newGetHomeContent",
      "data": {
        "search_type": "facilities",
        "category_group": categoryData['category_group_id'],
        "category": categoryData['category_id'],
        "category_name": categoryData['category'],
        "location": "",
        "latitude": currentLat,
        "longitude": currentLong,
        "address": "",
        "zipcode": pinController.text,
        "type": [
          "coach",
          "workshop",
          "facilities",
          "event",
          "most_watched",
          "categories",
          "trending"
        ],
        "orderColumn": "created",
        "orderDir": "desc",
        "pageNumber": 0,
        "pageSize": 8,
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
        await helper.postAPI('newGetHomeContent', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']['status'] == 'success') {}
    /* totalKandy = responseJSON['decodedData']['result']['total'].toString();
    AvailableKandy = responseJSON['decodedData']['result']['available'].toString();*/
    isLoading = false;
    print('Decoded');
    imageUrl = responseJSON['decodedData']['coach_list']['image_url'];
    eventImageUrl = responseJSON['decodedData']['event_image_url'];
    coachList = responseJSON['decodedData']['coach_list']['list'];
    hotPackagelist = responseJSON['decodedData']['hot_package_list']['list'];
    exclusivePackagelist =
        responseJSON['decodedData']['exclusive_package_list']['list'];
    popularPackagelist =
        responseJSON['decodedData']['popular_package_list']['list'];
    eventsList = responseJSON['decodedData']['event_list']['list'];
    academyList = responseJSON['decodedData']['facility_list']['list'];
    programsList = responseJSON['decodedData']['workshop_list']['list'];
    workshopList = responseJSON['decodedData']['workshop_list']['list'];
    print('9999');
    print(workshopList.length.toString());
    /*  categoryList =
        responseJSON['decodedData']['categories'][0]['sub_categories'];*/

    setState(() {});
    print(responseJSON);
  }

  _fetchCurrentCategoryId() async {
    currentCategoryId =
        await MyUtils.getSharedPreferences('current_category_id');
  }

  _fetchCategoryList(BuildContext context) async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getLearnerCategoryList",
      "data": {
        "slug": AppModel.slug,
        "orderColumn": "created",
        "orderDir": "asc",
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('getLearnerCategoryList', requestModel, context);
    var responseJSON = json.decode(response.body);
    categoryList = responseJSON['decodedData']['result'];
    categoryBaseUrl = responseJSON['decodedData']['image_url'];
    if (categoryList.length != 0) {


      for(int i=0;i<categoryList.length;i++)
      {
        if(catId==categoryList[i]['category_id'])
        {
          selectedCateIndex=i;
          currentCategoryImageUrl =
              categoryBaseUrl + categoryList[i]['category_image'];
          currentCategoryName = categoryList[i]['category'];
          break;
        }
      }




    }
    setState(() {});
    print(responseJSON);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCurrentCategoryId();
    pinController.text="302017";
    bookingAPI(context, true);
    _fetchCategoryList(context);
  }

  refreshHomeScreenData(Map<String, dynamic> categoryData) {
    updateData(context, categoryData);
  }

  _changeAddressBottomSheet() {
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
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                              child: Text('Change ',
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
                                Text('Location',
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
                        child: Text('Enter Pincode',
                            style: TextStyle(
                                color: AppTheme.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                            controller: pinController,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF6F6F6),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 7),
                                hintText: 'Pin code',
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
                              if (pinController.text.length == 6) {
                                Navigator.pop(context);
                                changeLocation();
                              }
                            }),
                      )
                    ],
                  ),
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

  changeLocation() async {
    APIDialog.showAlertDialog(context, "Changing location...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');

    var data = {
      "method_name": "checkPinCode",
      "data": {
        "pin_code": pinController.text,
        "slug": AppModel.slug,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('checkPinCode', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    if (responseJSON['decodedData']['status'] == 'success') {
      isLoading=true;
      setState(() {

      });
      pinResults = responseJSON['decodedData']['result'];
      locationName = pinResults['city_name'] + ', ' + pinResults['state_name'];
      locationPin = pinController.text;
      List<Location> locations = await locationFromAddress(pinResults['city_name']);
      print(locations.toString());
      print('Location Data');
      currentLat=locations[0].latitude;
      currentLong=locations[0].longitude;
      bookingAPI(context, true);
    } else {
      Toast.show(responseJSON['decodedData']['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    print(responseJSON);
  }
}
