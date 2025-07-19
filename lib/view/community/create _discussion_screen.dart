import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
class CreateDiscussionScreen extends StatefulWidget {

  @override
  PostState createState() => PostState();
}

class PostState extends State<CreateDiscussionScreen> {
  var addPostController = TextEditingController();
  List<String> timeList=[
    "1 Day",
    "2 Day",
    "3 Day",
    "4 Day",
    "5 Day",
    "6 Day"
  ];
  String? selectedTimeValue;
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
                         text: 'Discussion',
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
                    EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                    hintText: 'Ask a question.....',
                    hintStyle: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB8B6B6)
                    ),
                  )),
            ),

            SizedBox(height: 5),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: Color(0xFFE5E5E5),width: 1)
              ),

              child: Column(
                children: [

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFE5E5E5),width: 1)
                          ),
                          height: 42,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: EdgeInsets.only(bottom: 10,left: 10),
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFFB8B6B6),fontSize: 12),
                              hintText: "Choice 1",
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Icon(Icons.close),

                      SizedBox(width: 5),




                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFE5E5E5),width: 1)
                          ),
                          height: 42,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: EdgeInsets.only(bottom: 10,left: 10),
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFFB8B6B6),fontSize: 12),
                              hintText: "Choice 2",
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Icon(Icons.add),

                      SizedBox(width: 5),




                    ],
                  ),
                  SizedBox(height: 18),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Color(0xFFE5E5E5),
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Discussion Time',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),


                      Container(
                        height: 40,
                        margin: EdgeInsets.only(right: 3),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            icon: Icon(Icons.keyboard_arrow_down_outlined,
                                color: Colors.black),
                            hint: Text(
                              'Select Time',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: timeList
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedTimeValue,
                            onChanged: (value) {
                              setState(() {
                                selectedTimeValue = value as String;
                              });
                            },
                            buttonHeight: 40,
                            buttonWidth: 90,
                            itemHeight: 40,
                          ),
                        ),
                      ),






                    ],
                  ),

                  SizedBox(height: 3),



                ],
              ),


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
