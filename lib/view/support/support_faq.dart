import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/loader.dart';
import '../app_theme.dart';

class supportFaq extends StatefulWidget {
  _supportFaq createState() => _supportFaq();
}

class _supportFaq extends State<supportFaq> {
  bool isLoading = false;
  List<dynamic> faqList = [];

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
                  text: '',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextSpan(
                  text: 'Faq',
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
        body: isLoading
            ? Center(
                child: Loader(),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: faqList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int pos) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(width: 1, color: Color(0xFfD3D3D3))),
                        child: ListTileTheme(
                            contentPadding: EdgeInsets.all(0),
                            child: ExpansionTile(
                              collapsedBackgroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              title: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                height: 47,
                                alignment: Alignment.centerLeft,
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Q" + (pos + 1).toString() + ": ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13.5)),
                                    Expanded(
                                      child: Text(
                                        faqList[pos]['question'].toString(),
                                        style: TextStyle(
                                            color: AppTheme.blueColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5, right: 5, bottom: 5),
                                    child: Text(
                                      removeAllHtmlTags(faqList[pos]['answer']),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      SizedBox(height: 5)
                    ],
                  );
                }));
  }

  @override
  void initState() {
    super.initState();

    _fetchDropDown(context);
  }

  _fetchDropDown(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    String? id = await MyUtils.getSharedPreferences('_id');
    String? role = await MyUtils.getSharedPreferences('current_role');
    String? catId = await MyUtils.getSharedPreferences('current_category_id');
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "method_name": "getFaq",
      "data": {
        "slug": AppModel.slug,
        "action_performed_by": id,
        "current_category_id": catId,
        "current_role": role,
      }
    };
    var requestModel = {'req': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('getFaq', requestModel, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if (responseJSON['decodedData']['status'].toString() == 'success') {
      faqList.clear();
      faqList = responseJSON['decodedData']['result'];
    } else {
      Toast.show(responseJSON['decodedData']['errors'].toString(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      Navigator.of(context).pop();
    }
    setState(() {
      isLoading = false;
    });
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
