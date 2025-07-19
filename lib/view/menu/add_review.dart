import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';

class AddReview extends StatefulWidget{
  _addReview createState()=>_addReview();
}
class _addReview extends State<AddReview>{
  final _formKeyReview = GlobalKey<FormState>();
  TextEditingController reviewController = TextEditingController();
  double selectedRating=0.0;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
            onPressed: () => Navigator.pop(context,"0"),
          ),
          backgroundColor: AppTheme.themeColor,
          title: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1A1A1A),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Add ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Review',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKeyReview,
          child: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(height: 15,),
                  Center(
                    child:  Lottie.asset('assets/add_review_anim.json',
                        width: MediaQuery.of(context).size.width *
                            0.6,
                        height:
                        MediaQuery.of(context).size.height *
                            0.35),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: double.infinity,
                    child:RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),

                        itemBuilder: (context,_)=>Icon(
                          Icons.star,
                          color: AppTheme.primarySwatch.shade800,
                        ), onRatingUpdate: (rating){
                           selectedRating=rating;
                           print(rating);

                    }) ,
                  ),
                  SizedBox(height: 15,),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Review",
                      style: TextStyle(
                          color: AppTheme.blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppTheme.greyColor,
                    ),
                    
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: reviewController,
                      maxLength: 250,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: "Enter Your Experience",
                          hintStyle: TextStyle(
                              color: AppTheme.hintColor,
                              fontSize: 15
                          ),
                        border: InputBorder.none
                      ),
                      validator: reViewValidatior,

                    ),
                  ),

                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () {
                      _submitHandler(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                            BorderRadius.circular(5)),
                        height: 50,
                        child: const Center(
                          child: Text('Submit',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        )),
                  )

                ],
              )
            ],
          ),
        )

    );
  }

  String? reViewValidatior(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your Experience!';
    }
    return null;
  }
  void _submitHandler(BuildContext context) async {
    if (!_formKeyReview.currentState!.validate()) {
      return;
    }
    _formKeyReview.currentState!.save();
    _checkValidations();
  }
  _checkValidations() {
    if (selectedRating == 0) {
      Toast.show('Please Select Rating',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    else {
      // All validations Passed
     Navigator.pop(context,"1");


    }
  }

}