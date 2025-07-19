import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/community/full_video_screen.dart';
import 'package:klubba/view/image_view_screen.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:klubba/widgets/video_widget.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class menuMyGallery extends StatefulWidget {
  _menuMyGallery createState() => _menuMyGallery();
}

class _menuMyGallery extends State<menuMyGallery> {
  bool isLoading = false;
  List<dynamic> videoList = [];
  List<dynamic> imageList = [];
  List<dynamic> talentList = [];
  List<dynamic> allMediaList = [];
  bool noData=false;
  final SliverGridDelegate delegate =
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3);

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
                text: 'My ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Gallery',
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
      body:
      isLoading?

          Center(
            child: Loader(),
          ):


          noData?

              Center(
                child: Text("No data found!"),
              ):







      GridView.builder(
          gridDelegate: delegate,
          padding: EdgeInsets.all(5),
          itemCount: allMediaList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  
                  allMediaList[index].toString().contains("images")?


                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageView(allMediaList[index]["images"])));
                        },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(allMediaList[index]["images"])
                            )
                          ),
                        ),
                      ):

                      InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullVideoScreen(allMediaList[index]["video"],"")));
                          },
                          child: VideoWidget(url:allMediaList[index]["video"] , play: true, loaderColor:AppTheme.themeColor,showControls: false)),



                  // For Image ic_image_icon
                  // For Video ic_video_icon
                  allMediaList[index].toString().contains("images")?
                  Positioned(
                    child: SvgPicture.asset(
                      "assets/ic_image_icon.svg",
                      height: 12,
                      width: 12,
                    ),
                    bottom: 10,
                    left: 5,
                  ):

                  Positioned(
                    child: SvgPicture.asset(
                      "assets/ic_video_icon.svg",
                      height: 15,
                      width: 15,
                    ),
                    bottom: 10,
                    left: 5,
                  )

                ],
              ),
            );
          }),
    );
  }

  fetchImages() async {
    setState(() {
      isLoading = true;
    });
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getPostImageorVideos",
      "data": {
        "user_id": id,
        "type": "images",
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
        'getPostImageorVideos', requestModel, context);
    var responseJSON = json.decode(response.body);
    isLoading = false;
    imageList = responseJSON['decodedData']['result'];
    allMediaList = imageList;

    setState(() {});
    fetchVideos();
    print(responseJSON);
  }


  fetchVideos() async {

    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getPostImageorVideos",
      "data": {
        "user_id": id,
        "type": "video",
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
        'getPostImageorVideos', requestModel, context);
    var responseJSON = json.decode(response.body);
    videoList = responseJSON['decodedData']['result'];
    allMediaList=allMediaList+videoList;
    setState(() {});
    fetchTalent();
    print(responseJSON);
  }

  fetchTalent() async {
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "getPostImageorVideos",
      "data": {
        "user_id": id,
        "type": "talent",
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
        'getPostImageorVideos', requestModel, context);
    var responseJSON = json.decode(response.body);
    talentList = responseJSON['decodedData']['result'];
    allMediaList=allMediaList+talentList;

    if(allMediaList.length==0)
      {
        noData=true;
      }


    setState(() {});
    print(responseJSON);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImages();
  }
}
