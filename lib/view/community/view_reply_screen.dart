
import 'dart:convert';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/utils/example_data.dart' as example_data;
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/friend_profile_screen.dart';
import 'package:klubba/view/community/view_likes_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:klubba/widgets/reaction_widget/reaction.dart';
import 'package:klubba/widgets/reaction_widget/reaction_toggle.dart';

class ViewReplyScreen extends StatefulWidget
{
  String postID;
  String commentID;
  Map<String,dynamic> commentData;
  ViewReplyScreen(this.postID,this.commentID,this.commentData);
  ViewReplyState createState()=>ViewReplyState();
}
class ViewReplyState extends State<ViewReplyScreen>
{
  bool isLoading=false;
  int replyIndex=9999;
  String replyTo="";
  var addCommentController=TextEditingController();
  bool replyEnabled = false;

  List<dynamic> commentList=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              fontFamily: "Poppins",
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'View ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Reply',
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
      body:
      isLoading?

          Center(
            child: Loader(),
          ):


      Column(
        children: [

          SizedBox(height: 7),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(9),
            color: Color(0xFF7A8FA6)
                .withOpacity(0.1),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [


                widget.commentData[
                "profile_image"]==null?
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(
                      "assets/dummy_profile.png"),
                ):

                InkWell(
                  onTap: () {
                  /*  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FriendProfileScreen()));*/
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        shape: BoxShape
                            .circle,
                        border: Border.all(
                            width: 2,
                            color: Colors
                                .white),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(AppConstant
                                .profileImageURL +
                                widget.commentData[
                                "profile_image"]))),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Row(
                          children: [
                            Text(
                                widget.commentData
                                ["name"],
                                style: TextStyle(
                                    color: Color(
                                        0xFF1B1B1B),
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    fontSize:
                                    14)),
                            Spacer(),
                            Text(
                                timeago.format(
                                    DateTime.parse(
                                        widget.commentData
                                        [
                                        "created_at"])),
                                style: TextStyle(
                                    color: Color(
                                        0xFFACACAC),
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    fontSize:
                                    10)),
                          ],
                        ),
                        /*  Text(
                                                    '#Photoshoot #Smile #Beautiful #Fashion',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF2FBBF0),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11)),*/
                        Text(
                            widget.commentData
                            ["comment"],
                            style: TextStyle(
                                color: Color(
                                    0xFF7A8FA6),
                                fontWeight:
                                FontWeight
                                    .w500,
                                fontSize: 11)),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder:
                                        (context) =>
                                        ViewLikesScreen("")));
                          },
                          child: Row(
                            children: [
                              widget.commentData[
                              "selfLike"]
                                  .length !=
                                  0
                                  ? GestureDetector(
                                child: Image
                                    .asset(
                                  widget.commentData["selfLike"][0]["liked_type"] ==
                                      "heart_emoji_count"
                                      ? "assets/heart.png"
                                      : widget.commentData["selfLike"][0]["liked_type"] == "thumb_emoji_count"
                                      ? 'assets/thumbs_up.png'
                                      : widget.commentData["selfLike"][0]["liked_type"] == "wow_emoji_count"
                                      ? 'assets/wow.png'
                                      : widget.commentData["selfLike"][0]["liked_type"] == "sad_emoji_count"
                                      ? 'assets/sad.png'
                                      : widget.commentData["selfLike"][0]["liked_type"] == "laugh_emoji_count"
                                      ? 'assets/laughing.png'
                                      : widget.commentData["selfLike"][0]["liked_type"] == "namaste_emoji_count"
                                      ? 'assets/namaste.png'
                                      : "",
                                  width: 12,
                                  height:
                                  12,
                                ),
                                onTap: () {

                                },
                              ):Image.asset("assets/heart_ic.png",
                                  width: 17, height: 17),
                              SizedBox(width: 5),
                              Text(
                                 widget.commentData
                                  ["like"]
                                      .length
                                      .toString(),
                                  style:
                                  TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    color: Color(
                                        0xFF01345B),
                                  )),
                              SizedBox(width: 17),
                              Container(
                                width: 21,
                                height: 21,
                                decoration: BoxDecoration(
                                    shape: BoxShape
                                        .circle,
                                    border: Border.all(
                                        width: 2,
                                        color: Colors
                                            .white),
                                    image: DecorationImage(
                                        fit: BoxFit
                                            .cover,
                                        image: AssetImage(
                                            "assets/profile_dummy.jpg"))),
                              ),
                              SizedBox(width: 3),
                              Text(
                                  widget.commentData
                                  [
                                  "replied"]
                                      .length
                                      .toString() +
                                      " Replies",
                                  style:
                                  TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    color: Color(
                                        0xFF01345B),
                                  )),


                              Spacer(),

                              GestureDetector(
                                onTap:(){
                                  replyEnabled =
                                  !replyEnabled;
                                  setState(() {});
                                },
                                child: Text("Reply",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w500,
                                      color: Color(0xFF01345B),
                                    )),
                              ),


                              SizedBox(width: 8)
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),


          SizedBox(height: 10),

          Expanded(child: ListView.builder(
              itemCount: commentList.length,
              itemBuilder: (BuildContext context,int pos)
          {
            return Column(
              children: [
                Container(

                  margin: EdgeInsets.only(right: 10,left: 30),
                  padding: EdgeInsets.all(9),
                  color: Color(0xFF7A8FA6).withOpacity(0.1),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2,color: Colors.white),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(AppConstant.profileImageURL+commentList[pos]["profile_image"])
                            )
                        ),
                      ),

                      SizedBox(width: 6),

                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Text(commentList[pos]["name"],
                                  style: TextStyle(
                                      color: Color(0xFF1B1B1B),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),

                              Spacer(),


                              Text( timeago.format(
                                  DateTime.parse(
                                      commentList[pos]
                                      [
                                      "created_at"])),
                                  style: TextStyle(
                                      color: Color(0xFFACACAC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10)),
                            ],
                          ),

                          Text(commentList[pos]["comment"],
                              style: TextStyle(
                                  color: Color(0xFF7A8FA6),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11)),


                          SizedBox(height: 10),


                          Row(
                            children: [

                              commentList[pos][
                              "selfLike"]
                                  .length !=
                                  0
                                  ? GestureDetector(
                                child: Image
                                    .asset(
                                  commentList[pos]["selfLike"][0]["liked_type"] ==
                                      "heart_emoji_count"
                                      ? "assets/heart.png"
                                      : commentList[pos]["selfLike"][0]["liked_type"] == "thumb_emoji_count"
                                      ? 'assets/thumbs_up.png'
                                      : commentList[pos]["selfLike"][0]["liked_type"] == "wow_emoji_count"
                                      ? 'assets/wow.png'
                                      : commentList[pos]["selfLike"][0]["liked_type"] == "sad_emoji_count"
                                      ? 'assets/sad.png'
                                      : commentList[pos]["selfLike"][0]["liked_type"] == "laugh_emoji_count"
                                      ? 'assets/laughing.png'
                                      : commentList[pos]["selfLike"][0]["liked_type"] == "namaste_emoji_count"
                                      ? 'assets/namaste.png'
                                      : "",
                                  width: 12,
                                  height:
                                  12,
                                ),
                                onTap: () {
                                  likePost(
                                      commentList[pos]["selfLike"][0]
                                      [
                                      "liked_type"],
                                      "unlike",
                                      pos,
                                      commentList[pos]
                                      [
                                      "_id"]);
                                },
                              )
                                  : ReactionButtonToggle<
                                  String>(
                                onReactionChanged:
                                    (String?
                                value,
                                    bool
                                    isChecked) {
                                  debugPrint(
                                      'Selected value: $value, isChecked: $isChecked');

                                  print(
                                      value);

                                  if (value ==
                                      null) {
                                    likePost(
                                        commentList[pos]["selfLike"][0]["liked_type"],
                                        "unlike",
                                        pos,
                                        commentList[pos]["_id"]);
                                  } else {
                                    likePost(
                                        value.toString(),
                                        "like",
                                        pos,
                                        commentList[pos]["_id"]);
                                  }
                                },

                                reactions:
                                example_data
                                    .reactions,
                                initialReaction:
                                Reaction<
                                    String>(
                                  value:
                                  null,
                                  icon:
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(0.0),
                                    child: Image
                                        .asset(
                                      "assets/heart_ic.png",
                                      width:
                                      12,
                                      height:
                                      12,
                                    ),
                                  ),
                                ),
                                // selectedReaction: Example.reactions[1],

                                boxDuration:
                                const Duration(
                                    milliseconds:
                                    400),
                                itemScaleDuration:
                                const Duration(
                                    milliseconds:
                                    200),
                                boxPadding:
                                EdgeInsets
                                    .all(5),
                                //  boxColor: Colors.redAccent.withOpacity(0.5),
                              ),





                              /*  Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Image.asset(
                                    "assets/heart_red.png",
                                    width: 12,
                                    height: 12),
                              ),
                              SizedBox(width: 5),
                              Text("30",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w500,
                                    color: Color(0xFF01345B),
                                  )),


                              SizedBox(width: 11),



                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Image.asset(
                                    "assets/smiley_yellow.png",
                                    width: 13,
                                    height: 13),
                              ),*/
                              SizedBox(width: 3),
                              Text(commentList[pos]["like"].length.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w500,
                                    color: Color(0xFF01345B),
                                  )),

                              SizedBox(width: 17),



                            /*  Container(
                                width: 21,
                                height: 21,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2,color: Colors.white),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("assets/profile_dummy.jpg")
                                    )
                                ),
                              ),

                              SizedBox(width: 3),
                              Text("3 Replies",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w500,
                                    color: Color(0xFF01345B),
                                  )),
*/


                              SizedBox(width: 8)



                            ],
                          ),




                        ],


                      ))





                    ],
                  ),


                ),
                SizedBox(height: 10)
              ],
            );
          }


          )),



          replyEnabled
              ? Container(
            height: 37,
            width: double.infinity,
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 10),
            color: AppTheme.blueColor,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Replying to ',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  TextSpan(
                    text: '@'+widget.commentData["name"],
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
              : Container(),


          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6,
                    offset: Offset(0,0)
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Row(
              children: [
                SizedBox(width: 5),

                Image.asset("assets/smile.png",width: 25,height: 25),


                SizedBox(width: 10),




                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    // height: 50,
                    child: TextFormField(
                        cursorHeight: 21,
                        controller: addCommentController,
                        textCapitalization:
                        TextCapitalization
                            .sentences,
                        keyboardType:
                        TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border:
                          OutlineInputBorder(
                            borderSide:
                            const BorderSide(
                              width: 1,
                              color: Color(0XFF9A9EA4),

                            ),
                            borderRadius:
                            BorderRadius
                                .circular(23.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                          const EdgeInsets
                              .fromLTRB(
                              13.0,
                              0.0,
                              5.0,
                              12.0),
                          hintText: 'Type a message....',
                          hintStyle:
                          const TextStyle(
                            fontSize: 11.0,
                            color:
                            Color(0XFF7C8085),
                          ),
                        )),
                  ),
                ),
                SizedBox(width: 15),
                 GestureDetector(
                   onTap: (){
                     if(addCommentController.text!="")
                       {
                        addReplyComments(widget.commentData["_id"]);
                       }
                   },
                   child: Icon(
                    Icons.send,
                    size: 30,
                    color: Color(0xFF01345B),
                ),
                 ),

                SizedBox(width: 10),

              ],
            ),
          ),


        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPostComments();

  }
  fetchPostComments() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getUserCommentByPost",
      "data": {
        "user_id": id,
        "post_id": widget.postID,
        "slug": AppModel.slug,
        "replied_comment_id": widget.commentID,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };

    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'getUserCommentByPost', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    commentList = responseJSON['decodedData']['result']['repliedCommentData'];
    setState(() {});
    print(responseJSON);
  }


  likePost(String emojiType, String type, int pos,
      String commentID) async {
    if (type == "like") {
      if (commentList[pos]["selfLike"].length == 0) {
        commentList[pos]["selfLike"].add({
          "_id": "64b63c6e2e5ef2592a7d6c55",
          "post_id": widget.postID,
          "user_id": "61b9c5c64e85c44c9df8fa93",
          "comment_id": commentID,
          "liked_type": emojiType,
          "status": 1,
          "created_at": "2023-07-18T07:17:02.890Z",
          "updated_at": "2023-07-18T07:17:02.890Z"
        });
      } else {
        commentList[pos]["selfLike"][0] = {
          "_id": "64b63c6e2e5ef2592a7d6c55",
          "post_id": widget.postID,
          "user_id": "61b9c5c64e85c44c9df8fa93",
          "comment_id": commentID,
          "liked_type": emojiType,
          "status": 1,
          "created_at": "2023-07-18T07:17:02.890Z",
          "updated_at": "2023-07-18T07:17:02.890Z"
        };
      }
    } else if (type == "unlike") {
      commentList[pos]["selfLike"].removeAt(0);
    }

    setState(() {});

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "manageNewLikeRecordForComment",
      "data": {
        "user_id": id,
        "post_id": widget.postID,
        "comment_id": commentID,
        "liked_type": emojiType,
        "new_liked_type": emojiType,
        "type": type,
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
        'manageNewLikeRecordForComment', requestModel, context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['decodedData']["status"] == "success") {}
    setState(() {});
    print(responseJSON);
  }

  addReplyComments(String commentID) async {
    APIDialog.showAlertDialog(context, "Adding comment...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "createCommentForAPost",
      "data": {
        "user_id": id,
        "post_id": widget.postID,
        "comment": addCommentController.text,
        "replied_comment_id": commentID,
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
        'getUserCommentByPost', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);

    if (responseJSON['decodedData']["status"] == "success") {

      addCommentController.text="";
      FocusScope.of(context).unfocus();
      commentList.insert(0,responseJSON['decodedData']["result"][0]);
      if(replyEnabled)
      {
        replyEnabled=false;
      }
      setState(() {});
    }

    print(responseJSON);
  }
  
}
