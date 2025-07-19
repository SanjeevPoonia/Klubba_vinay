import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/network/Utils.dart';
import 'package:klubba/network/api_dialog.dart';
import 'package:klubba/network/api_helper.dart';
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:toast/toast.dart';

class ProgressPictureView extends StatefulWidget {
  List<dynamic> progressPictures;
  String imageID;
  final String imageBase;
  final String title;
  final String date;

  ProgressPictureView(
      this.progressPictures, this.imageBase, this.title, this.date,this.imageID);

  ProgressState createState() => ProgressState();
}

class ProgressState extends State<ProgressPictureView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
            ),
            children: <TextSpan>[
              const TextSpan(
                text: 'Progress ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: 'Pictures',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(widget.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showPictureRemoveDialog("");
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.delete, color: AppTheme.blueColor),
                ),
              )
            ],
          ),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.date,
                style: TextStyle(
                    color: Color(0xFF9A9CB8),
                    fontWeight: FontWeight.w500,
                    fontSize: 13)),
          ),
          Expanded(
            child: Container(
             //   height: 300,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: widget.progressPictures.length != 0
                    ? ListView.builder(
                        itemCount: widget.progressPictures.length,
                        itemBuilder: (BuildContext context, int pos) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 170,
                                width: 220,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.4),
                                        width: 1),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(widget.imageBase +
                                            widget.progressPictures[pos]
                                            ['image']))),
                              ),
                              SizedBox(height: 10)
                            ],
                          );
                        })
                    : Center(
                        child: Text('No images found'),
                      )),
          ),
        ],
      ),
    );
  }

  showPictureRemoveDialog(String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Remove",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        deletePicture();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Picture?"),
      content: Text("Are you sure you want to remove this picture ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deletePicture() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var currentRole = await MyUtils.getSharedPreferences('current_role');
    String? id = await MyUtils.getSharedPreferences('_id');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    var data = {
      "method_name": "deleteProgressivePicture",
      "data": {
        "slug":AppModel.slug,
        "image_token": widget.imageID,
        "current_role": currentRole,
        "current_category_id": catId,
        "action_performed_by": id
      }
    };
    print(data);
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('deleteProgressivePicture', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      Toast.show(responseJSON['decodedData']['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,"Refresh screen");
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}
