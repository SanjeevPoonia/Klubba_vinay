
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/loader.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
class LocalVideoScreen extends StatefulWidget
{
  @override
  FullVideoScreenState createState()=>FullVideoScreenState();
}

class FullVideoScreenState extends State<LocalVideoScreen>
{
   VideoPlayerController? _controller;
  late final chewieController;
  bool pageNavigator=false;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.themeColor,
      child: SafeArea(child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Padding(padding: EdgeInsets.only(top: 15,left: 10),

              child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },

                  child: Icon(Icons.arrow_back_outlined,color: Colors.white,size: 23)),

            ),


            Expanded(child:  _controller!.value.isInitialized
               ? Center(
             child: SizedBox(
                 child: AspectRatio(
                     aspectRatio: _controller!.value.aspectRatio,
                     child:

                     Chewie(
                       controller: chewieController,
                     )


                 )
             ),
           )
               :


          Container()



             /*  Center(
             child: Loader(),
           ),*/)
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    prepareVideo();

    print('******Playing****');

   // _onControllerChange("assets/klubba_video.mp4");


 /*   _controller = VideoPlayerController.network(widget.videoUrl, videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            _controller.play();
          }
        });
        _controller.play();
        setState(() {});
      });*/
  }

  prepareVideo() async {
    _controller=VideoPlayerController.asset(
        "assets/klubba_video.mp4");
    await _controller!.initialize();

    chewieController=await ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: false,
    );
    setState(() {

    });

  }


  Future<void> _onControllerChange(String link) async {
    if (_controller == null) {
      // If there was no controller, just create a new one
     prepareVideo();
    } else {
      // If there was a controller, we need to dispose of the old one first
      final oldController = _controller;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController!.dispose();

        // Initing new controller
        prepareVideo();
      });

      // Making sure that controller is not used by setting it to null
      setState(() {
        _controller = null!;
      });
    }}
  @override
  void dispose() {

    _controller!.pause();
    _controller!.dispose();
    chewieController.dispose();
    Wakelock.disable();
    super.dispose();
  }

}