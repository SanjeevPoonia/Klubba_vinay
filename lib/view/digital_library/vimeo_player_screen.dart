


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/custom_video_widget.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VimeoPlayer22 extends StatefulWidget
{
  final String url;
  VimeoPlayer22(this.url);
  VimeoState createState()=>VimeoState(url);
}
class VimeoState extends State<VimeoPlayer22>
{
  final String url;
  bool isLoading=true;
  WebView? web;
  InAppWebView? webView;
  VimeoState(this.url);
  var iframe ;

  var frm;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       // automaticallyImplyLeading: false,
       leading: IconButton(
         icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
         onPressed: () {
           Navigator.of(context).pop();
         },
       ),
       backgroundColor: AppTheme.themeColor,
       /*title: RichText(
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
               text: 'Planner',
               style: const TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                   color: Colors.black),
             ),
           ],
         ),
       ),
       centerTitle: true,*/
     ),
     body: Center(
       child:  Container(
        // height: 250,
         child: Stack(
           children: [
             isLoading
                 ? const Center(child: CircularProgressIndicator())
                 : const SizedBox(),
             Column(
               children: [
               //  const SizedBox(height: 30),
                 Expanded(
                   child: InAppWebView(
                     onLoadStop: (controller, url) {

                       setState(() {
                         isLoading = false;
                       });
                     },
                     onEnterFullscreen: (controller) {
                       SystemChrome.setPreferredOrientations([
                         DeviceOrientation.landscapeRight,
                         DeviceOrientation.landscapeLeft,
                       ]);
                     },
                     onExitFullscreen: (controller) {
                       SystemChrome.setPreferredOrientations([
                         DeviceOrientation.portraitDown,
                         DeviceOrientation.portraitUp,
                         DeviceOrientation.landscapeRight,
                         DeviceOrientation.landscapeLeft,
                       ]);
                     },
                     initialOptions: InAppWebViewGroupOptions(
                       android: AndroidInAppWebViewOptions(
                         useWideViewPort: false,
                       ),
                       ios: IOSInAppWebViewOptions(
                         enableViewportScale: false,
                       ),
                       crossPlatform: InAppWebViewOptions(
                         javaScriptEnabled: true,
                       ),
                     ),
                     initialUrlRequest: URLRequest(url: frm),
                   ),
                 ),
               ],
             )
           ],
         ),






       ),
     ),
   );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
    iframe = '''
<html>
  <iframe src="https://player.vimeo.com/video/$url" width="100%" height="100%" frameborder="0" allow="autoplay; fullscreen" allowfullscreen
  ></iframe>
</html>
''';
  frm= Uri.dataFromString(
      iframe,
      mimeType: 'text/html',
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

  }
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

}
