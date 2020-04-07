import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_images.dart';

class LogoHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.headerDecoration(),
      width: MediaQuery.of(context).size.width,
      height: ScreenUtil().setHeight(AppDimen.loginHeaderHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(AppDimen.logoLoginMarginTop),
            ),
            child: SvgPicture.asset(
              AppImages.logo,
              width: ScreenUtil().setWidth(AppDimen.logoLoginWidth),
              height: ScreenUtil().setHeight(AppDimen.logoLoginHeight),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(AppDimen.labelLogoLoginMarginTop),
              bottom:
                  ScreenUtil().setWidth(AppDimen.labelLogoLoginMarginBottom),
            ),
            child: Text(
              S.of(context).app_name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(AppDimen.labelSplashScreenSize),
              ),
            ),
          )
        ],
      ),
    );
  }
}
