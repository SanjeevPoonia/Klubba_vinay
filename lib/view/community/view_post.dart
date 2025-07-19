import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/network/constants.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/friend_profile_screen.dart';
import 'package:klubba/utils/example_data.dart' as example_data;
import 'package:klubba/view/community/full_video_screen.dart';
import 'package:klubba/view/community/reshare_post.dart';
import 'package:klubba/view/community/view_likes_screen.dart';
import 'package:klubba/view/community/view_reply_screen.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:klubba/widgets/reaction_widget/reaction.dart';
import 'package:klubba/widgets/reaction_widget/reaction_toggle.dart';
import 'package:klubba/widgets/video_widget.dart';
import 'package:mime/mime.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewPostScreen extends StatefulWidget {
  Map<String, dynamic> postData;
  List<dynamic> mediaFiles;
  String profileImage;

  ViewPostScreen(this.postData, this.mediaFiles, this.profileImage);

  ViewPostState createState() => ViewPostState();
}

class ViewPostState extends State<ViewPostScreen> {
  int selectedMoreIndex = 9999;
  int replyIndex=9999;
  bool isLoading = false;
  String replyTo="";
  List<dynamic> commentsList = [];
  late PageController _pageController;
  var addCommentController=TextEditingController();
  int activePage = 1;
  List<String> moreList = [
    "Unfollow",
    "Report",
    "Block",
  ];
  bool replyEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
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
                      Icons.arrow_back_ios_new,
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
                        const TextSpan(
                          text: 'View ',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Post',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7, right: 10),
                  child: GestureDetector(
                      onTap: () {
                        postOptionsBottomSheet();
                      },
                      child: Image.asset("assets/horizontal_dot.png",
                          width: 27, height: 30)),
                )
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                //  width: MediaQuery.of(context).size.width,
                height: 220,
                child: PageView.builder(
                    itemCount: widget.mediaFiles.length,
                    pageSnapping: true,
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        activePage = page;
                      });
                    },
                    itemBuilder: (context, pagePosition) {
                      bool active = pagePosition == activePage;
                      return slider(widget.mediaFiles, pagePosition, active);
                    }),
              ),
              Container(
                height: 220,
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              indicators(widget.mediaFiles.length, activePage)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: Loader(),
                  )
                : Container(
                    transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(37),
                              topLeft: Radius.circular(37))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 21),

                            /*  RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A1A1A),
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Obsessed with my desk at work. All cleaned & organized after 5 years ',
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFF484D54),fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: '#workdesk #worklife #agency',
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2676E1)),
                            ),
                          ],
                        ),
                      ),*/

                            Text(
                                widget.postData
                                        .toString()
                                        .contains("repostData")
                                    ?
                                widget.postData["repostData"]
                                ["description"]!=null?

                                widget.postData["repostData"]
                                        ["description"]:""
                                    :
                                widget.postData["description"]!=null?
                                widget.postData["description"]:"",
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF484D54),
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 3),
                            Text(
                                widget.postData
                                        .toString()
                                        .contains("repostData")
                                    ? timeago.format(DateTime.parse(widget
                                        .postData["repostData"]["created_at"]))
                                    : timeago.format(DateTime.parse(
                                        widget.postData["created_at"])),
                                style: const TextStyle(
                                    fontSize: 11.6,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF484D54))),
                            Divider(),
                            SizedBox(height: 2),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      widget.postData["like"].length == 0
                                          ? Image.asset("assets/heart_ic.png",
                                              width: 17, height: 17)
                                          : Container(
                                              height: 15,
                                              child: ListView.builder(
                                                  itemCount: widget
                                                      .postData["like"].length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int pos22) {
                                                    bool showEmojis = true;

                                                    String currentEmoji = widget
                                                            .postData["like"]
                                                        [pos22]["liked_type"];

                                                    if (widget.postData["like"]
                                                            .length >
                                                        1) {
                                                      print(pos22.toString());
                                                      for (int i = pos22 - 1;
                                                          i >= 0;
                                                          i--) {
                                                        if (widget.postData[
                                                                    "like"][i][
                                                                "liked_type"] ==
                                                            currentEmoji) {
                                                          showEmojis = false;
                                                          break;
                                                        }
                                                      }
                                                    }

                                                    return !showEmojis
                                                        ? Container()
                                                        : Align(
                                                            widthFactor: 0.7,
                                                            child: Image.asset(
                                                                widget.postData["like"][pos22]
                                                                            [
                                                                            "liked_type"] ==
                                                                        "heart_emoji_count"
                                                                    ? "assets/heart.png"
                                                                    : widget.postData["like"][pos22]["liked_type"] ==
                                                                            "thumb_emoji_count"
                                                                        ? 'assets/thumbs_up.png'
                                                                        : widget.postData["like"][pos22]["liked_type"] ==
                                                                                "wow_emoji_count"
                                                                            ? 'assets/wow.png'
                                                                            : widget.postData["like"][pos22]["liked_type"] == "sad_emoji_count"
                                                                                ? 'assets/sad.png'
                                                                                : widget.postData["like"][pos22]["liked_type"] == "laugh_emoji_count"
                                                                                    ? 'assets/laughing.png'
                                                                                    : widget.postData["like"][pos22]["liked_type"] == "namaste_emoji_count"
                                                                                        ? 'assets/namaste.png'
                                                                                        : "",
                                                                width: 14,
                                                                height: 14),
                                                          );
                                                  }),
                                            ),
                                      SizedBox(width: 5),
                                      Text(
                                          widget.postData["like"].length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //   Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ViewPostScreen(widget.postData,mediaFiles)));
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset("assets/comments.png",
                                            width: 17, height: 17),
                                        SizedBox(width: 5),
                                        Text(
                                            commentsList.length
                                                .toString()=="0"?"":
                                            commentsList.length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                    /*  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResharePostWidget()));*/
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset("assets/repost_ic.png",
                                            width: 17, height: 17),
                                        SizedBox(width: 5),
                                        Text("0",
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset("assets/share_ic.png",
                                          width: 17, height: 17),
                                      SizedBox(width: 5),
                                   /*   Text("0",
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          )),*/
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Divider(),
                            SizedBox(height: 2),
                            Expanded(
                                child: ListView(
                              padding: EdgeInsets.zero,
                              children: [


                                Text(
                                    "Liked by " +
                                        widget.postData["like"].length
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                                Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: commentsList.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int pos) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewReplyScreen(widget.postData["_id"],commentsList[pos]["_id"],commentsList[pos])));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(9),
                                              color: Color(0xFF7A8FA6)
                                                  .withOpacity(0.1),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [

                                                  commentsList[
                                                  pos][
                                                  "profile_image"]==null?
                                                  CircleAvatar(
                                                    radius: 22,
                                                    backgroundImage: AssetImage(
                                                        "assets/dummy_profile.png"),
                                                  ):

                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FriendProfileScreen(commentsList[
                                                                  pos]["user_id"])));
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
                                                                  commentsList[
                                                                          pos][
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
                                                              commentsList[pos]
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
                                                                      commentsList[pos]
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
                                                          commentsList[pos]
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
                                                            commentsList[pos][
                                                                            "selfLike"]
                                                                        .length !=
                                                                    0
                                                                ? GestureDetector(
                                                                    child: Image
                                                                        .asset(
                                                                      commentsList[pos]["selfLike"][0]["liked_type"] ==
                                                                              "heart_emoji_count"
                                                                          ? "assets/heart.png"
                                                                          : commentsList[pos]["selfLike"][0]["liked_type"] == "thumb_emoji_count"
                                                                              ? 'assets/thumbs_up.png'
                                                                              : commentsList[pos]["selfLike"][0]["liked_type"] == "wow_emoji_count"
                                                                                  ? 'assets/wow.png'
                                                                                  : commentsList[pos]["selfLike"][0]["liked_type"] == "sad_emoji_count"
                                                                                      ? 'assets/sad.png'
                                                                                      : commentsList[pos]["selfLike"][0]["liked_type"] == "laugh_emoji_count"
                                                                                          ? 'assets/laughing.png'
                                                                                          : commentsList[pos]["selfLike"][0]["liked_type"] == "namaste_emoji_count"
                                                                                              ? 'assets/namaste.png'
                                                                                              : "",
                                                                      width: 12,
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    onTap: () {
                                                                      likePost(
                                                                          commentsList[pos]
                                                                              [
                                                                              "post_id"],
                                                                          commentsList[pos]["selfLike"][0]
                                                                              [
                                                                              "liked_type"],
                                                                          "unlike",
                                                                          pos,
                                                                          commentsList[pos]
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
                                                                            commentsList[pos]["post_id"],
                                                                            commentsList[pos]["selfLike"][0]["liked_type"],
                                                                            "unlike",
                                                                            pos,
                                                                            commentsList[pos]["_id"]);
                                                                      } else {
                                                                        likePost(
                                                                            commentsList[pos]["post_id"],
                                                                            value.toString(),
                                                                            "like",
                                                                            pos,
                                                                            commentsList[pos]["_id"]);
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

                                                            /*                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
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
                                                            color: Color(
                                                                0xFF01345B),
                                                          )),
                                                      SizedBox(width: 11),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Image.asset(
                                                            "assets/smiley_yellow.png",
                                                            width: 13,
                                                            height: 13),
                                                      ),
                                                      SizedBox(width: 3),*/

                                                            SizedBox(width: 5),
                                                            Text(
                                                                commentsList[
                                                                            pos]
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
                                                                commentsList[pos]
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
                                                              onTap: () {
                                                                replyTo=commentsList[pos]
                                                                ["name"];
                                                                replyIndex=pos;
                                                                replyEnabled =
                                                                    !replyEnabled;
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                  "Reply",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xFF01345B),
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
                                            Divider()
                                          ],
                                        ),
                                      );
                                    })
                              ],
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
                                            text: '@'+replyTo,
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
                              transform:
                                  Matrix4.translationValues(0.0, 15.0, 0.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFFAFAFA),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Color(0X00000029),
                                      blurRadius: 6,
                                      offset: Offset(0, 0)),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                widget.profileImage))),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      height: 38,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFAFAFA)),
                                      // height: 50,
                                      child: TextFormField(
                                          cursorHeight: 21,
                                          controller: addCommentController,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            fillColor: Color(0xFF7A8FA6)
                                                .withOpacity(0.1),
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    13.0, 0.0, 5.0, 12.0),
                                            hintText: 'Add a comment',
                                            hintStyle: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0XFFD1D1D1),
                                            ),
                                          )),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                   InkWell(
                                     onTap: (){
                                       if(addCommentController.text!="")
                                         {
                                          if(replyEnabled)
                                            {
                                              addReplyComments(commentsList[replyIndex]["_id"]);
                                            }
                                          else
                                            {
                                              addComments();
                                            }
                                         }
                                     },
                                     child: Icon(
                                      Icons.send,
                                      size: 30,
                                      color: Color(0xFF01345B),
                                  ),
                                   ),
                                  SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  postOptionsBottomSheet() {
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('More',
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
                      SizedBox(height: 10),
                      Divider(),
                      ListView.builder(
                          itemCount: moreList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      selectedMoreIndex == pos
                                          ? Icon(Icons.radio_button_on,
                                              color: AppTheme.themeColor)
                                          : GestureDetector(
                                              child:
                                                  Icon(Icons.radio_button_off),
                                              onTap: () {
                                                dialogState(() {
                                                  selectedMoreIndex = pos;
                                                });
                                              },
                                            ),
                                      SizedBox(width: 5),
                                      Text(
                                        moreList[pos],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 18)
                              ],
                            );
                          }),
                      SizedBox(height: 27),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, top: 5, bottom: 25),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            child: Text('Save',
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
                            onPressed: () {}),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 1.0, initialPage: 1);
    fetchPostComments();
  }

  InkWell slider(images, pagePosition, active) {
    double margin = active ? 8 : 8;
    return InkWell(
      onTap: () {
        if (lookupMimeType(images[pagePosition])
            .toString()
            .startsWith('video/')) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FullVideoScreen(images[pagePosition], "")));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageView(images[pagePosition])));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.all(0),
        decoration:
            lookupMimeType(images[pagePosition]).toString().startsWith('video/')
                ? BoxDecoration()
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(images[pagePosition]))),
        child:
            lookupMimeType(images[pagePosition]).toString().startsWith('video/')
                ? VideoWidget(
                    url: images[pagePosition],
                    play: true,
                    loaderColor: AppTheme.themeColor)
                : Container(),
      ),
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
                ? AppTheme.themeColor
                : Colors.grey.withOpacity(0.45),
            shape: BoxShape.circle),
      );
    });
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
        "post_id": widget.postData["_id"],
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
    isLoading = false;
    commentsList = responseJSON['decodedData']['result'][0]['totalData'];

    setState(() {});
    print(responseJSON);
  }

  likePost(String postID, String emojiType, String type, int pos,
      String commentID) async {
    if (type == "like") {
      if (commentsList[pos]["selfLike"].length == 0) {
        commentsList[pos]["selfLike"].add({
          "_id": "64b63c6e2e5ef2592a7d6c55",
          "post_id": postID,
          "user_id": "61b9c5c64e85c44c9df8fa93",
          "comment_id": commentID,
          "liked_type": emojiType,
          "status": 1,
          "created_at": "2023-07-18T07:17:02.890Z",
          "updated_at": "2023-07-18T07:17:02.890Z"
        });
      } else {
        commentsList[pos]["selfLike"][0] = {
          "_id": "64b63c6e2e5ef2592a7d6c55",
          "post_id": postID,
          "user_id": "61b9c5c64e85c44c9df8fa93",
          "comment_id": commentID,
          "liked_type": emojiType,
          "status": 1,
          "created_at": "2023-07-18T07:17:02.890Z",
          "updated_at": "2023-07-18T07:17:02.890Z"
        };
      }
    } else if (type == "unlike") {
      commentsList[pos]["selfLike"].removeAt(0);
    }

    setState(() {});

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "manageNewLikeRecordForComment",
      "data": {
        "user_id": id,
        "post_id": postID,
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

  addComments() async {
    APIDialog.showAlertDialog(context, "Adding comment...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "createCommentForAPost",
      "data": {
        "user_id": id,
        "post_id": widget.postData["_id"],
        "comment": addCommentController.text,
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
      commentsList.add(responseJSON['decodedData']["result"][0]);
      setState(() {});
    }

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
        "post_id": widget.postData["_id"],
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
      if(replyEnabled)
        {
          replyEnabled=false;
        }
      setState(() {});
    }

    print(responseJSON);
  }


}
