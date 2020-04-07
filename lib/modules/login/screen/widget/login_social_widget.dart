import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_images.dart';

class LoginSocialWidget extends StatelessWidget {
  final Function onGoogleLoginTap;
  final Function onFacebookLoginTap;

  const LoginSocialWidget(
      {Key key,
      @required this.onGoogleLoginTap,
      @required this.onFacebookLoginTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            this.onGoogleLoginTap();
          },
          child: new Container(
            width: ScreenUtil().setWidth(AppDimen.buttonAltLoginWidth),
            height: ScreenUtil().setHeight(AppDimen.buttonAltLoginHeight),
            decoration: AppDecorations.buttonBoxDecoration(Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Image.asset(AppImages.google),
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(1)),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            this.onFacebookLoginTap();
          },
          child: new Container(
            width: ScreenUtil().setWidth(AppDimen.buttonAltLoginWidth),
            height: ScreenUtil().setHeight(AppDimen.buttonAltLoginHeight),
            decoration: AppDecorations.buttonBoxDecoration(
                AppColor.facebookLoginBackground),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Image.asset(AppImages.facebook),
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(1)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
