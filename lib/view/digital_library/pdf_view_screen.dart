

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/digital_library/pdf_view_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PDFView extends StatefulWidget
{
  final String url;
  PDFView(this.url);
  PDFState createState()=>PDFState();
}
class PDFState extends State<PDFView>
{
  bool isLoading=true;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.themeColor,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_sharp,
                color: Colors.black),
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
                  text: 'PDF ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: '',
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
          children: [
            Expanded(child:  Stack(
              children: <Widget>[
                WebView(
                  key: _key,
                  initialUrl: 'https://docs.google.com/gview?embedded=true&url='+widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                isLoading ? Center( child: CircularProgressIndicator(),)
                    : Stack(),
              ],
            ))
          ],
        )

    );
  }
}