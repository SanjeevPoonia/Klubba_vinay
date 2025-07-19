
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/widgets/heading_text_widget.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/textfield_widget.dart';
import '../app_theme.dart';
class EncashKandy extends StatefulWidget{

  final String totalKandy;
  const EncashKandy(this.totalKandy,{super.key});
  _encashKandyState createState()=>_encashKandyState();
}
class _encashKandyState extends State<EncashKandy>{

  TextEditingController kandyController = TextEditingController();
  TextEditingController modeController = TextEditingController();
  String _mode = "Encash Mode*";
  bool _fromTop = true;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(

       elevation: 0,
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
               text: 'Encash ',
               style: const TextStyle(fontSize: 16, color: Colors.black),
             ),
             TextSpan(
               text: 'Klubba Kandy',
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
     body: ListView(
       children: [
         Container(
           padding: EdgeInsets.only(top: 10),
           margin: EdgeInsets.symmetric(horizontal: 12),
           child: DottedBorder(
             color: Color(0xFF01345B),
             borderType: BorderType.RRect,
             radius: Radius.circular(4),

             child: ClipRRect(
                 borderRadius: BorderRadius.all(Radius.circular(4)),
                 child: Container(
                   height: 85,
                   width: double.infinity,
                   color: Color(0xFFF3F3F3),
                   child: Row(
                     children: [
                       Container(
                         width: 85,
                         height: 85,
                         child: Lottie.asset('assets/encash_kandy_anim.json'),
                       ),
                       Spacer(),
                       Column(
                         children: [
                           SizedBox(height: 15),
                           Text('Available Klubba Kandy',
                               style: TextStyle(
                                   color: Colors.black,
                                   fontWeight: FontWeight.w600,
                                   fontSize: 14)),
                           SizedBox(height: 8),
                           Text('${widget.totalKandy} Kandy',
                               style: TextStyle(
                                   color: AppTheme.blueColor,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 20)),
                         ],
                       ),
                       SizedBox(width: 15),
                     ],
                   ),
                 )),
           ),
         ),
         SizedBox( height: 10,),
         HeadingTextWidget("Point ", "Redemption"),
         SizedBox( height: 10,),
         Padding(
             padding: EdgeInsets.symmetric(horizontal: 12),
         child: Text('Klubba Kandy',
             style: TextStyle(
                 color: AppTheme.blueColor,
                 fontWeight: FontWeight.w600,
                 fontSize: 13)),
         ),
         SizedBox( height: 5,),
         Container(
           color: Color(0xFFF6F6F6) ,
           margin: const EdgeInsets.symmetric(
               horizontal: 12),
           child: TextFieldNumber(
             labeltext: 'Enter Kandy Redemption Points',
             validator: kandyValidator,
             controller: kandyController,
             fieldIC: const Icon(Icons.mail,
                 size: 20,
                 color: AppTheme.themeColor),
             suffixIc: const Icon(
               Icons.mail,
               size: 20,
             ), maxLength: 5,
           ),
         ),
         SizedBox( height: 10,),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 12),
           child: Text('Amount',
               style: TextStyle(
                   color: AppTheme.blueColor,
                   fontWeight: FontWeight.w600,
                   fontSize: 13)),
         ),
         SizedBox( height: 5,),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 12),
           child: Text('0',
               style: TextStyle(
                   color: AppTheme.blueColor,
                   fontWeight: FontWeight.w600,
                   fontSize: 13)),
         ),
         SizedBox( height: 10,),
         HeadingTextWidget("Select ", "Encash Mode"),
         SizedBox( height: 10,),
         Container(
           height: 40,
           width: MediaQuery.of(context).size.width,
           child: Row(
             children: [
               Container(
                 height: 40,
                 width: MediaQuery.of(context).size.width*0.4,
                 child:  RadioListTile(
                     title: Image.asset("assets/encash_ppay.png"
                         ,height: 40),
                     value: "phone_pay",
                     groupValue: _mode,
                     onChanged: (value) {
                       setState(() {
                         _mode = value.toString();
                       });
                       Navigator.pop(context);
                     }),
               ),
               Container(
                 height: 40,
                 width: MediaQuery.of(context).size.width*0.4,
                 child: RadioListTile(
                     title: Image.asset("assets/encash_paytm.png"
                         ,height: 40),
                     value: "paytm",
                     groupValue: _mode,
                     onChanged: (value) {
                       setState(() {
                         _mode = value.toString();
                       });
                       Navigator.pop(context);
                     }),
               )

             ],
           ),
         ),
         Container(
           height: 40,
           width: MediaQuery.of(context).size.width,
           child: Row(
             children: [
               Container(
                 height: 40,
                 width: MediaQuery.of(context).size.width*0.4,
                 child: RadioListTile(
                     title: Image.asset("assets/encash_lazy.png"
                         ,height: 40),
                     value: "lazy_pay",
                     groupValue: _mode,
                     onChanged: (value) {
                       setState(() {
                         _mode = value.toString();
                       });
                       Navigator.pop(context);
                     }),
               ),
               Container(
                 height: 40,
                 width: MediaQuery.of(context).size.width*0.4,
                 child: RadioListTile(
                     title: Image.asset(
                         "assets/encash_ggl.png"
                         ,height: 40),
                     value: "google_wallet",
                     groupValue: _mode,
                     onChanged: (value) {
                       setState(() {
                         _mode = value.toString();
                       });
                       Navigator.pop(context);
                     }),
               )

             ],
           ),
         ),
         SizedBox( height: 30,),
         InkWell(
           onTap: () {
             _showCongratulationsDialog();
             /*Route route = MaterialPageRoute(builder: (context) => DialogScreen());
                                        Navigator.pushAndRemoveUntil(
                                            context, route, (Route<dynamic> route) => false);*/
           },
           child: Container(
               margin: const EdgeInsets.symmetric(
                   horizontal: 17),
               width: double.infinity,
               decoration: BoxDecoration(
                   color: Colors.black,
                   borderRadius:
                   BorderRadius.circular(5)),
               height: 50,
               child: const Center(
                 child: Text('Continue',
                     style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                         color: Colors.white)),
               )),
         ),




       ],
     ),
   );
  }

  String? kandyValidator(String? value) {
    if(value!=null){
      var totalAvailab= int.parse(widget.totalKandy);
      var ente = int.parse(value);
      if(totalAvailab<ente){
        return 'Enter valid Kandy';
      }
      return null;
    }
    return null;
  }

  _showCongratulationsDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
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


                  SizedBox(height: 16),
                  Container(
                    height: 250,
                    child: Lottie.asset('assets/encash_congrat_anim.json'),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Congratulations!! You have successfully redeem your Klubba Kandy',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.blueColor,
                        ),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 27),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30, right: 30, top: 5, bottom: 25),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Text('Back to Refer & Earn',
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.5)),
                        style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ))),
                        onPressed: () => {
                          Navigator.of(context).pop()
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
          Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

}