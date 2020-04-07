import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';

class ScreenUtility {
  static void initScreenUtil({@required BuildContext context}) {
    ScreenUtil.init(
      context,
      width: AppDimen.baseScreenWidth,
      height: AppDimen.baseScreenHeight,
    );
  }

  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static TextFormField getBaseTextFormField(
      {@required context,
      obscureText = false,
      @required maxLength,
      onSaved,
      textInputAction,
      focusNode,
      validator,
      onFieldSubmitted,
      keyboardType = TextInputType.text,
      key}) {
    return TextFormField(
      key: key,
      obscureText: obscureText,
      style: AppStyles.formTextStyle(
          AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize)),
      validator: validator,
      decoration: AppDecorations.formInputDecoration(
          S.of(context).name, AppColor.loginErrorColor),
      maxLength: maxLength,
      onSaved: onSaved,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
