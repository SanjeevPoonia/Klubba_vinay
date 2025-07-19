import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/app_theme.dart';
import 'package:klubba/view/splash_screen.dart';
import 'package:klubba/view/update_app_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString('access_token')??'';
  if(token!='')
  {
    String? slug=prefs.getString('slug')??'';
    // create session for user
    AppModel.setTokenValue(token.toString());
    AppModel.setSlugValue(slug);
  }
  WidgetsFlutterBinding.ensureInitialized();

  runApp( MyApp(token.toString()));
}

class MyApp extends StatelessWidget {
  final String token;
   MyApp(this.token);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.themeColor,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Klubba',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreen(token)
    );
  }



}

