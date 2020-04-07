import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(AppColor.green),
      strokeWidth: 6.0,
    );
  }
}
