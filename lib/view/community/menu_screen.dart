
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/community/members_screen.dart';
import 'package:klubba/view/community/menu_event_screen.dart';
import 'package:klubba/view/community/menu_my_community.dart';
import 'package:klubba/view/community/menu_my_gallery.dart';
import 'package:klubba/view/community/menu_recent_posts.dart';
import 'package:toast/toast.dart';
import 'menu_request.dart';
import 'menu_view_members.dart';
import 'menu_talent.dart';
import 'menu_settings.dart';
import 'menu_announcements.dart';

class MenuScreen extends StatefulWidget
{
  MenuState createState()=>MenuState();
}
class MenuState extends State<MenuScreen>
{

  List<String> menuName = [
  /*  'Create Community',*/
    'My Community',
    'Announcements',
    'Request',
    'Gallery',
    'Members',
    'Events',
    'My Activities',
    'Talent',
   /* 'Settings',*/
  ];
  List<String> menuIcons = [
    /*'assets/menu_1.png',*/
    'assets/menu_2.png',
    'assets/menu_3.png',
    'assets/menu_4.png',
    'assets/menu_5.png',
    'assets/menu_6.png',
    'assets/menu_7.png',
    'assets/menu_8.png',
    'assets/menu_9.png',
   /* 'assets/menu_10.png',*/
  ];


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: Column(
        children: [
           SizedBox(height:30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text('Menu',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
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


                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 17,right: 5),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppTheme.themeColor,
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.close,color: Colors.white,size: 15),
                  ),
                )




              ],
            ),
          ),

          SizedBox(height: 5),

          Divider(),

          Expanded(child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 5,right: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 12,
                mainAxisSpacing: 15,
                crossAxisCount: 3,
                childAspectRatio: (2 / 2)),
            itemCount: menuName.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                   if(index==0){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => menuMyCommunity()));
                  }else if(index==1){
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => menuAnnoucements()));

                  }else if(index==2){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => menuRequest()));
                  }else if(index==3){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => menuMyGallery()));
                  }else if(index==4){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MembersScreen()));
                  }else if(index==5){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => menuEventScreen()));

                   /* Toast.show(
                        menuName[index],
                        duration: Toast.lengthLong,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.red);*/

                  }else if(index==6){
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => MenuMyPostScreen()));


                  }else if(index==7){
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => menuTalent()));
                  }/*else if(index==8){
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => menuSettings()));
                  }*/
                },
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      index==11?
                      Image.asset(menuIcons[11], width: 45, height: 45,color:Color(0xFFFFCE15).withOpacity(0.5)):
                      Image.asset(menuIcons[index], width: 45, height: 45),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(menuName[index],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // Item rendering
            },
          ))


        ],
      ),
    );
  }

}
