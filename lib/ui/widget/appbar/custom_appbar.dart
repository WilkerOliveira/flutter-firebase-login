import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';

enum AppBarType { simple, silverAppBar, noAppBar, signUpSilverAppBar }

class CustomAppBar {
  final AppBarType appBarType;
  final String title;
  final bool showBackArrow;
  final List<Widget> actions;
  final bool showDrawer;
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomAppBar({
    Key key,
    @required this.appBarType,
    @required this.title,
    this.actions,
    this.showBackArrow = true,
    this.showDrawer = false,
    this.scaffoldKey,
  });

  Widget build(BuildContext context) {
    switch (this.appBarType) {
      case AppBarType.simple:
        return this._mainAppHeader(context, title);
      case AppBarType.silverAppBar:
        return this._silverAppbar(context, title);
      case AppBarType.signUpSilverAppBar:
        return this._silverSingUpAppbar(context, title);
      case AppBarType.noAppBar:
        return this._noAppBar(context, title);
      default:
        return null;
    }
  }

  PreferredSizeWidget _noAppBar(context, title) {
    return AppBar(
      elevation: 0.0,
      leading: this.showDrawer
          ? IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              })
          : null,
      flexibleSpace: Container(
        color: AppColor.darkBlue,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      automaticallyImplyLeading: this.showBackArrow,
      iconTheme: new IconThemeData(color: AppColor.green),
      actions: this.actions,
    );
  }

  PreferredSizeWidget _mainAppHeader(context, title) {
    return AppBar(
      leading: this.showDrawer
          ? IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              })
          : null,
      flexibleSpace: Container(
          decoration: BoxDecoration(
        gradient: AppDecorations.gradientDecoration(),
      )),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      automaticallyImplyLeading: this.showBackArrow,
      iconTheme: new IconThemeData(color: AppColor.green),
      actions: this.actions,
    );
  }

  Widget _silverAppbar(context, title) {
    return SliverAppBar(
      backgroundColor: AppColor.topHead,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      expandedHeight: ScreenUtil().setHeight(AppDimen.loginHeaderHeight),
      floating: false,
      pinned: true,
      elevation: 2.0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(26),
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: AppDecorations.headerDecoration(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _silverSingUpAppbar(context, title) {
    return SliverAppBar(
      backgroundColor: AppColor.topHead,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      expandedHeight: ScreenUtil().setHeight(AppDimen.signUpHeaderHeight),
      floating: false,
      pinned: true,
      elevation: 2.0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(26),
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: AppDecorations.headerDecoration(),
            ),
          ],
        ),
      ),
    );
  }
}
