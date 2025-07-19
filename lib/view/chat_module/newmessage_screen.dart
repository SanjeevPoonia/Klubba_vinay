import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../app_theme.dart';

class newMessageScreen extends StatefulWidget{
  _newMessageScreen createState()=>_newMessageScreen();
}
class _newMessageScreen extends State<newMessageScreen>{

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
                text: 'New ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Message',
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
      body: Stack(
        children: [
          Padding(padding: EdgeInsets.all(5),
            child: ListView(
              children: [
                Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(
                              0, 0), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      border: Border.all(
                          width: 1, color: const Color(0xFFCDCDCD))),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        suffixIcon:
                        Icon(Icons.search, color: AppTheme.blueColor),
                        contentPadding: EdgeInsets.only(left: 8, top: 11),
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: Color(0xFF919191),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int pos) {
                      return Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 6),
                                child: Row(
                                  children: [
                                    // assets/dummy_profile.png
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundImage: AssetImage(
                                              "assets/dummy_profile.png"),
                                        ),
                                        Positioned(
                                            right: 2,
                                            bottom: 2,
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF06D451),
                                              ),
                                            )
                                        )
                                      ],
                                    ),

                                    SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text("Michael Bruno",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                    "Poppins",
                                                    color: AppTheme
                                                        .blueColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500)),

                                          ],
                                        )),
                                    SizedBox(width: 10,),

                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(
                            color: AppTheme.greyColor,
                            height: 07,
                          ),
                          SizedBox(height: 5),
                        ],
                      );
                    })


              ],
            ),
          ),
          Positioned(
            child: InkWell(
              onTap: (){},
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape:BoxShape.circle,
                  color: AppTheme.themeColor,
                ),
                child: Icon(Icons.arrow_right_alt_sharp,color: Colors.white,),
              ),
            ),
            right: 10,
            bottom: 20,
          )
        ],
      ),
    );
  }

}