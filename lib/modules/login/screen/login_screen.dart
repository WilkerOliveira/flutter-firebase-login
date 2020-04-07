import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/login/controller/login_controller.dart';
import 'package:summarizeddebts/modules/login/model/user.dart';
import 'package:summarizeddebts/modules/login/screen/widget/login_form_widget.dart';
import 'package:summarizeddebts/modules/login/screen/widget/login_social_widget.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/routers.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/header/logo_header_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ModularState<LoginScreen, LoginController> {
  Size _size;

  @override
  Widget build(BuildContext context) {
    ScreenUtility.initScreenUtil(context: context);

    this._size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: this._size.width,
        height: this._size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Header
              LogoHeaderWidget(),
              _body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          LoginFormWidget(
            onForgotPasswordTap: _forgotPassword,
            onSignInTap: _signIn,
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.extraMargin),
          ),
          LoginSocialWidget(
            onGoogleLoginTap: _onGoogleLoginTap,
            onFacebookLoginTap: _onFacebookLoginTap,
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.sizedBoxSpace),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.pushNamed(context, Routers.signUp);
            },
            child: Container(
              width: ScreenUtil().setWidth(AppDimen.buttonDefaultWidth),
              height: ScreenUtil().setHeight(AppDimen.buttonDefaultHeight),
              decoration: AppDecorations.transparentButtonBoxDecoration(),
              child: Center(
                child: RichText(
                    text: new TextSpan(children: [
                  new TextSpan(
                    text: S.of(context).dont_have_account,
                    style: AppStyles.buttonTextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(AppDimen.buttonTextSize),
                    ),
                  ),
                  new TextSpan(
                    text: S.of(context).sign_up_now,
                    style: AppStyles.buttonTextStyle(
                      color: AppColor.markTextColor,
                      fontSize: ScreenUtil().setSp(AppDimen.buttonTextSize),
                    ),
                  ),
                ])),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.sizedBoxSpace),
          ),
        ],
      ),
    );
  }

  Future<void> _checkLogin() async {
    if (controller.isError) {
      AlertDialogs.showErrorDialog(
          context, S.of(context).error_title, controller.errorMessage);
    } else if (controller.errorMessage != null &&
        controller.errorMessage.toString().isNotEmpty) {
      AlertDialogs.showInfoDialog(
          context, S.of(context).info_title, controller.errorMessage);
    } else {
      Navigator.pushNamed(context, Routers.home, arguments: null);
    }
  }

  _forgotPassword() {
    AlertDialogs.showResetPassword(context, (email) async {
      await controller.sendPasswordResetEmail(email);

      if (controller.isError) {
        AlertDialogs.showErrorDialog(
            context, S.of(context).error_title, controller.errorMessage);
      } else if (controller.errorMessage != null &&
          controller.errorMessage.toString().isNotEmpty) {
        AlertDialogs.showInfoDialog(
            context, S.of(context).info_title, controller.errorMessage);
      } else {
        AlertDialogs.showSuccessDialog(context, S.of(context).info_title,
            S.of(context).new_password_sent, () {});
      }
    });
  }

  _signIn(User currentUser) async {
    await controller.signIn(currentUser);

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    _checkLogin();
  }

  _onGoogleLoginTap() async {
    await controller.loginWithGoogle();
    _checkLogin();
  }

  _onFacebookLoginTap() async {
    await controller.loginWithFacebook();
    _checkLogin();
  }
}
