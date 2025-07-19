import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../widgets/loader.dart';
import 'add_review.dart';
import '../app_theme.dart';

class MyReview extends StatefulWidget{
  _myReview createState()=> _myReview();
}
class _myReview extends State<MyReview>{
  bool isLoading=false;
  List<dynamic> reviewList=[];
  double avgRating=0;
  int totalRecords=0;
  String imageURL="";


  String isAdded="0";

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
          text: const TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'My ',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Review',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading?
      Center(
        child: Loader(),
      ):reviewList.length==0?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 10,),
               Center(
                 child:  Text("No Reviews Found"),

               ),
                /*SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    _navigateNaddreview(context);
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                          BorderRadius.circular(5)),
                      height: 50,
                      child: const Center(
                        child: Text('Add Review',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      )),
                ),*/
                SizedBox(height: 10,),
              ],
            )

      :Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            height: MediaQuery.of(context).size.height*0.6,
            child: ListView.builder(
                itemCount: reviewList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context,int pos){
                  String userImage=reviewList[pos]['ratedFor']['profile_image']??"";
                  String fullImageUrl=imageURL+userImage;
                  String fullName=reviewList[pos]['ratedFor']['full_name'];
                  var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(reviewList[pos]['created'].toString()).toLocal();
                  String formattedDate = DateFormat("dd MMM yyyy hh:mm a").format(dateValue);
                  double rating=reviewList[pos]['rating'].toDouble();
                  String comment=reviewList[pos]['comment']??"";
                  return Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppTheme.backBlueColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.all(10),
                              child:  userImage==''?
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                    Border.all(width: 2, color: Colors.white),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/dummy_profile.png'))),
                              )
                                  :
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                    Border.all(width: 2, color: Colors.white),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(fullImageUrl))),
                              ),),

                              Expanded(
                                child:  Padding(
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width*0.8,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                            flex: 1,
                                            child:  Text(fullName,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: AppTheme.blueColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),
                                            ),

                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: RatingBarIndicator(
                                                rating: rating,
                                                itemBuilder: (context, index) => Icon(
                                                  Icons.star,
                                                  color: AppTheme.primarySwatch.shade800,
                                                ),
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                            flex: 1,
                                          ),


                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 3,),
                                      Text(formattedDate,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12
                                        ),)
                                    ],
                                  ),
                                ),

                              ),


                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                        child: Text(comment,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          ),),),
                        SizedBox(height: 10,),
                      ],
                    ),
                  );
                }
            ),
          ),
          SizedBox(height: 10,),
         /* InkWell(
            onTap: () {
              _navigateNaddreview(context);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                    BorderRadius.circular(5)),
                height: 50,
                child: const Center(
                  child: Text('Add Review',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                )),
          ),
          SizedBox(height: 10,),*/
        ],
      )

    );
  }


  _fetchReviewList(BuildContext) async{
    setState(() {
      isLoading=true;
    });
    String? id=await MyUtils.getSharedPreferences('_id');
    String? role=await MyUtils.getSharedPreferences('current_role');
    String? catId=await MyUtils.getSharedPreferences('current_category_id');

    APIDialog.showAlertDialog(context, "Please Wait...");
    var data = {
      "method_name": "getMyRatingList",
      "data": {
        "action_performed_by":id,
        "current_category_id":catId,
        "current_role":role,
        "orderColumn":"created",
        "orderDir":"desc",
        "pageNumber":1,
        "pageSize":2,
        "review_for":"me",
        "slug": AppModel.slug
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('getMyRatingList', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if( responseJSON['decodedData']['status'].toString()=='success'){
      imageURL=responseJSON['decodedData']['image_url'];
      avgRating=double.parse(responseJSON['decodedData']['avgRating'].toString());
      totalRecords=int.parse(responseJSON['decodedData']['recordsTotal'].toString());
      reviewList.clear();
      reviewList=responseJSON['decodedData']['result'];


    }else{
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }

    setState(() {
      isLoading=false;
    });

  }

  @override
  void initState() {
    super.initState();
    _fetchReviewList(context);
  }

  Future<void>_navigateNaddreview(BuildContext context) async{
    final result= await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddReview()));
    if(!mounted) return;
    isAdded=result;

    if(result==1){
      _fetchReviewList(context);
    }
  }



}