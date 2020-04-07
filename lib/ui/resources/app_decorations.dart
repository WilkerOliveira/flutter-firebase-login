import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';

class AppDecorations {
  static BoxDecoration headerDecoration() {
    return new BoxDecoration(
      color: AppColor.darkBlue,
      gradient: AppDecorations.gradientDecoration(),
      borderRadius: new BorderRadius.only(
        bottomRight: const Radius.circular(AppDimen.borderContainer),
        bottomLeft: const Radius.circular(AppDimen.borderContainer),
      ),
    );
  }

  static LinearGradient gradientDecoration() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColor.darkBlue, AppColor.topHead],
    );
  }

  static BoxDecoration transparentButtonBoxDecoration() {
    return new BoxDecoration(
      border: Border.all(color: Color(0xff45619d), width: 1),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static InputDecoration formInputDecoration(String hint, Color errorColor) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(20.0),
        ScreenUtil().setWidth(15.0),
        ScreenUtil().setWidth(20.0),
        ScreenUtil().setWidth(15.0),
      ),
      hintText: hint,
      counterStyle: TextStyle(
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10.0)),
      ),
      errorStyle: TextStyle(color: errorColor),
    );
  }

  static BoxDecoration buttonBoxDecoration(Color color) {
    return new BoxDecoration(
      color: color,
      border: Border.all(color: color, width: 1),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
