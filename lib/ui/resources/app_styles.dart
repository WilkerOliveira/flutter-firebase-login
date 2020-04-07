import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';

class AppStyles {
  static ThemeData defaultThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColor.green,
      canvasColor: AppColor.darkBlue,
    );
  }

  static TextStyle buttonTextStyle({Color color, double fontSize}) => TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: ScreenUtil().setSp(fontSize),
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.15000000596046448,
      );

  static TextStyle formTextStyle(Color color, double fontSize) => TextStyle(
        fontFamily: 'Roboto',
        fontSize: ScreenUtil().setSp(fontSize),
        color: color,
      );

  static TextStyle defaultTextStyle() {
    return TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white,
      fontSize: ScreenUtil().setSp(16),
      height: ScreenUtil().setHeight(1.4),
    );
  }
}
