import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';

class InlineProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: Colors.white,
      size: ScreenUtil().setWidth(AppDimen.loadingSize),
    );
  }
}
