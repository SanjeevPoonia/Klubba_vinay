import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/*class FullPhoto extends StatelessWidget {
  final List<String> imageList;
  int currentIndex;
  final String url;
  FullPhoto (this.imageList,this.currentIndex,this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),

        backgroundColor: Color(0x44000000).withOpacity(0.0),
        elevation: 0,
        centerTitle: true,
      ),
      body: FullPhotoScreen(url: url,imageList: imageList,currentIndex: currentIndex),
    );
  }
}*/

class FullPhotoScreen extends StatefulWidget {
  final List<String> imageList;
  int currentIndex;
  final String url;


  FullPhotoScreen (this.imageList,this.currentIndex,this.url);


  @override
  State createState() => FullPhotoScreenState(url: url,activePage: currentIndex);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;
  int activePage=0;
  late PageController _pageController;

  FullPhotoScreenState({ required this.url,required this.activePage});

  @override
  void initState() {
    super.initState();
    print("Init Triggered");
    print(widget.currentIndex.toString());
    activePage=widget.currentIndex;
    _pageController = PageController(viewportFraction: 1.0, initialPage: activePage);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),

        backgroundColor: Color(0x44000000).withOpacity(0.0),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child:
        PageView.builder(
            itemCount: widget.imageList.length,
            pageSnapping: true,
            controller: _pageController,
            onPageChanged: (page) {
              print("The current Page is "+page.toString());
              setState(() {
                activePage = page;
              });
            },
            itemBuilder: (context, pagePosition) {
              bool active =
                  pagePosition == activePage;
              return slider(
                  widget.imageList, pagePosition, active);
            }),





        /*PhotoView(
          imageProvider: NetworkImage(url),

        ),*/
      ),
    );
  }

  AnimatedContainer slider(images, pagePosition, active) {
    print("Indicator");
    print(pagePosition.toString());
    print(active.toString());

    double margin = active ? 8 : 8;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          /*image: DecorationImage(
              image: NetworkImage(images[pagePosition]))*/),

        child:
      PhotoView(
        imageProvider: NetworkImage(images[pagePosition]),

      ),



    );
  }
}
