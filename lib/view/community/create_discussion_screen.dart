import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
class CreateDiscussionScreen extends StatefulWidget {
  final String postType;
  final int? groupId;

  CreateDiscussionScreen(this.postType, this.groupId);

  @override
  PostState createState() => PostState();
}

class PostState extends State<CreateDiscussionScreen> {
  var addPostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        body: Column(
          children: [


         Container(
           height: 85,
           padding: EdgeInsets.only(left: 12,right: 10,top: 20),
           width: double.infinity,
           color: AppTheme.themeColor,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               InkWell(
                 onTap: (){
                   Navigator.pop(context);
                 },
                 child: Padding(
                   padding: const EdgeInsets.only(left: 2,top: 7),
                   child: Icon(Icons.close_outlined,color:Colors.black,size: 28,),
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.only(left: 5,top: 7),
                 child: RichText(
                   text: TextSpan(
                     style: TextStyle(
                       fontSize: 13,
                       fontFamily: "Poppins",
                       color: Color(0xFF1A1A1A),
                     ),
                     children: <TextSpan>[
                       const TextSpan(
                         text: 'Create ',
                         style: const TextStyle(fontSize: 16, color: Colors.black),
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


               Container(
                 height: 40,
                 width: 80,
                 child: ElevatedButton(
                     child: Text('Post',
                         style: TextStyle(color: Colors.white, fontSize: 13,fontWeight: FontWeight.w600)),
                     style: ButtonStyle(
                         foregroundColor:
                         MaterialStateProperty.all<Color>(Colors.white),
                         backgroundColor:
                         MaterialStateProperty.all<Color>(Colors.black),
                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                             RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(4),
                             ))),
                     onPressed: () {
                     }),
               ),





             ],
           ),
         ),


         SizedBox(height: 8),

         Row(
           children: [
             SizedBox(width: 8),
             Container(
               width: 55,
               height: 55,
               margin: EdgeInsets.only(top: 3),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(4),
                   border: Border.all(
                       width: 1.2, color: Colors.white),
                   image: DecorationImage(
                       fit: BoxFit.cover,
                       image: AssetImage(
                           "assets/profile_dummy.jpg"))),
             ),
             SizedBox(width: 5),

             Expanded(child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,

               children: [
               Text("Rahul Singh",
                   style: TextStyle(
                       color: Colors.black,
                       fontWeight: FontWeight.w600,
                       fontSize: 15)),
                 SizedBox(height: 5),

                 Container(
                   width:66,
                   height: 20,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(9),
                     color: AppTheme.themeColor
                   ),
                   child: Row(
                     children: [
                       SizedBox(width: 7),

                       Text("Public",
                           style: TextStyle(
                               color: Colors.black,
                               fontWeight: FontWeight.w500,
                               fontSize: 11.5)),
                       SizedBox(width: 2),
                       
                       Icon(Icons.keyboard_arrow_down,size: 18,)

                     ],
                   ),
                 )
                 







             ],))




           ],
         ),












            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: addPostController,
                  textCapitalization:
                  TextCapitalization
                      .sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(4.0, 5.0, 0.0, 10.0),
                    hintText: 'What\'s on your mind?',
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB8B6B6)
                    ),
                  )),
            ),




            Row(
              children: [
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(Icons.location_pin,color: Color(0xFF484D54),size: 12),
                ),
                SizedBox(width: 2),

                Text('Jaipur, Rajasthan',
                    style: TextStyle(
                        color: Color(0xFF484D54),
                        fontWeight: FontWeight.w500,
                        fontSize: 11)),
              ],
            ),


            Spacer(),

            Container(
              height:50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(
                        0, 0), // changes position of shadow
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 18,right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/post_image.png",width: 31,height: 31),
                    Image.asset("assets/post_video.png",width: 31,height: 31),
                    Image.asset("assets/post_link.png",width: 27,height: 27),
                    Image.asset("assets/post_doc.png",width: 27,height: 27),
                    Image.asset("assets/post_emojis.png",width: 27,height: 27),

                  ],
                ),
              ),

            )





          ],
        ));
  }

}
