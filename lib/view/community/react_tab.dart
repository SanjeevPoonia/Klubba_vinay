

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/loader.dart';

class ReactTab extends StatefulWidget
{
  String postID;

  ReactTab(this.postID);
  LikeState createState()=>LikeState();
}

class LikeState extends State<ReactTab>
{
  bool isLoading=false;
  List<dynamic> likesList=[];
  @override
  Widget build(BuildContext context) {
    return

      isLoading?


      Center(
        child: Loader(),
      ):



      ListView.builder(
          itemCount: likesList.length,
          itemBuilder: (BuildContext context,int pos)
          {
            return

              likesList[pos]["liked_type"]=="heart_emoji_count"?


              Container():



              Column(
                children: [

                  Row(
                    children: [

                      Container(
                        width: 54,
                        height: 54,
                        child: Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 2,color: Colors.white),
                                  image:

                                  likesList[pos]["profile_image"]!=""?

                                  DecorationImage(
                                      fit: BoxFit.cover,
                                      image:NetworkImage(AppConstant.profileImageURL+likesList[pos]["profile_image"])
                                  ):

                                  DecorationImage(
                                      fit: BoxFit.cover,
                                      image:

                                      AssetImage("assets/profile_dummy.jpg")
                                  )
                              ),
                            ),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 19,
                                height: 19,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF6F6F6)
                                ),
                                child: Image.asset(likesList[pos]["liked_type"] == "thumb_emoji_count"
                                    ? 'assets/thumbs_up.png'
                                    : likesList[pos]["liked_type"] == "wow_emoji_count"
                                    ? 'assets/wow.png'
                                    : likesList[pos]["liked_type"] == "sad_emoji_count"
                                    ? 'assets/sad.png'
                                    : likesList[pos]["liked_type"] == "laugh_emoji_count"
                                    ? 'assets/laughing.png'
                                    : likesList[pos]["liked_type"] == "namaste_emoji_count"
                                    ? 'assets/namaste.png'
                                    : ""),
                              ),
                            )


                          ],
                        ),
                      ),
                      SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          likesList[pos]["name"],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B1B1B)),
                        ),
                      ),
                      SizedBox(width: 5),

                      Container(
                        height: 36,
                        width: 100,
                        child: ElevatedButton(
                            child: Text(likesList[pos]["is_friend"]!=0?"Unfollow":'Follow',
                                style: TextStyle(
                                    color:likesList[pos]["is_friend"]!=0?Colors.black: Colors.white, fontSize: 14)),
                            style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    likesList[pos]["is_friend"]!=0?AppTheme.themeColor:
                                    Color(0xFF01345B)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ))),
                            onPressed: () {
                            }),
                      ),

                      SizedBox(width: 5)


                    ],
                  ),

                  Divider()

                ],
              );
          }


      );
  }


  fetchLikes() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getAllLikeListsForUser",
      "data": {
        "post_id":widget.postID,
        "page": 1,
        "limit": 10,
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
        'getAllLikeListsForUser', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    likesList = responseJSON['decodedData']['result'][0]['records'];

    setState(() {});
    print(responseJSON);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLikes();
  }

}



