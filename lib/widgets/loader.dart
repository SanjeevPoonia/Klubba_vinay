
import 'package:flutter/material.dart';
import 'package:klubba/view/app_theme.dart';


class Loader extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.themeColor),
      ),
    );
  }

}