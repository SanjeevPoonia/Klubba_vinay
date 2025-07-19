/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget
{
  final String videoUrl;
  YoutubePlayerScreen(this.videoUrl);
  YoutubeState createState()=>YoutubeState();
}
class YoutubeState extends State<YoutubePlayerScreen>
{
  String videoIdUrl='';
  late YoutubePlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerBuilder(
      player: YoutubePlayer(
      controller: _controller,
    ),
    builder: (context, player) {
      return Column(
        children: [
          // some widgets
          player,
          //some other widgets
        ],
      );
    }),


    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVideoId();

  }

  fetchVideoId()
  {
    videoIdUrl = YoutubePlayer.convertUrlToId(widget.videoUrl)!;
    print(videoIdUrl);
   _controller = YoutubePlayerController(
  initialVideoId: videoIdUrl,
  flags: YoutubePlayerFlags(
  autoPlay: true,
    ),
    );
    setState(() {

    });
  }


}*/
