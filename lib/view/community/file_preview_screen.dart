

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/widgets/video_widget.dart';
import 'package:klubba/widgets/video_widget_local.dart';
import 'package:mime/mime.dart';

class FilePreviewScreen extends StatefulWidget
{
  XFile file;
  FilePreviewScreen(this.file);
  FileState createState()=>FileState();
}
class FileState extends State<FilePreviewScreen>
{

  var chatController=TextEditingController();
  late File convertedFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.close,
              color: Colors.black,size: 34),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [

          SizedBox(height: 15),

          Expanded(child:

          lookupMimeType(widget.file.path.toString())
              .toString()
              .startsWith('video/')?


              VideoWidgetLocal( url:convertedFile,
                  play: true,
                  loaderColor: AppTheme.themeColor):






          Image.file(File(widget.file.path.toString()))),

          SizedBox(height: 10),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(

            ),
            child: Row(

              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9)),
                    // height: 50,
                    child: TextFormField(
                        cursorHeight: 21,
                        controller: chatController,
                        textCapitalization:
                        TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          fillColor: Color(0xFF7A8FA6).withOpacity(0.1),
                          filled: true,
                          contentPadding: const EdgeInsets.fromLTRB(
                              10.0, 12.0, 5.0, 12.0),
                          hintText: 'Type your message here',
                          hintStyle: const TextStyle(
                            fontSize: 13.0,
                            fontFamily: "Poppins",
                            color: Color(0XFFD1D1D1),
                          ),
                        )),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context,chatController.text==""?"Only file":chatController.text);
                  },
                  child: Icon(
                    Icons.send,
                    color: AppTheme.blueColor,
                    size: 34,
                  ),
                )


              ],
            ),
          ),

          SizedBox(height: 10)
















        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    convertedFile = File(widget.file.path.toString());

  }
}