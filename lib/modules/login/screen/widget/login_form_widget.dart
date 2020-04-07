import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/login/controller/login_controller.dart';
import 'package:summarizeddebts/modules/login/model/user.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_decorations.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/validation/register_form_validation.dart';

class LoginFormWidget extends StatefulWidget {
  final Function onSignInTap;
  final Function onForgotPasswordTap;

  LoginFormWidget(
      {Key key, @required this.onSignInTap, @required this.onForgotPasswordTap})
      : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState
    extends ModularState<LoginFormWidget, LoginController>
    with CommonFormValidation, RegisterFormValidation {
  final User _currentUser = User();
  final _formKey = GlobalKey<FormState>();

  FocusNode _emailFocus;
  FocusNode _password;
  TextEditingController userNameController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    this.userNameController = TextEditingController();
    this.passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _emailFocus = FocusNode();
    _password = FocusNode();
    var size = MediaQuery.of(context).size;

    this.commonValidationContext = context;
    this.registerValidationContext = context;

    TextStyle style = AppStyles.formTextStyle(
        AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize));

    final emailField = TextFormField(
      controller: userNameController,
      keyboardType: TextInputType.emailAddress,
      maxLength: 100,
      obscureText: false,
      style: style,
      decoration: AppDecorations.formInputDecoration(
          S.of(context).email, AppColor.loginErrorColor),
      onSaved: (String value) {
        _currentUser.email = value.trim();
      },
      validator: emailValidation,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(context, _emailFocus, _password);
      },
    );

    final passwordField = TextFormField(
      controller: passwordController,
      obscureText: true,
      maxLength: 8,
      style: style,
      decoration: AppDecorations.formInputDecoration(
          S.of(context).password, AppColor.loginErrorColor),
      onSaved: (String value) {
        _currentUser.password = value.trim();
      },
      validator: passwordValidation,
      textInputAction: TextInputAction.done,
      focusNode: _password,
      onFieldSubmitted: (term) {
        this._onSigInTap();
      },
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(AppDimen.defaultMargin),
                left: ScreenUtil().setWidth(AppDimen.defaultMargin),
                right: ScreenUtil().setWidth(AppDimen.defaultMargin),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(AppDimen.defaultMargin),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).email,
                        style: AppStyles.defaultTextStyle(),
                      ),
                    ),
                  ),
                  emailField,
                  SizedBox(
                    height: ScreenUtil().setHeight(AppDimen.defaultMargin),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(AppDimen.defaultMargin),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).password,
                        style: AppStyles.defaultTextStyle(),
                      ),
                    ),
                  ),
                  passwordField,
                  SizedBox(
                    height: ScreenUtil().setHeight(AppDimen.extraMargin),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.sizedBoxSpace),
          ),
          Observer(
            builder: (_) {
              return Container(
                child: controller.viewState == ViewState.Busy
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: ScreenUtil().setWidth(AppDimen.loadingSize),
                      )
                    : Material(
                        elevation: ScreenUtil().setWidth(5.0),
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setWidth(AppDimen.borderButton),
                        ),
                        color: AppColor.loginButtonBackground,
                        child: MaterialButton(
                          minWidth: ScreenUtil().setWidth(size.width),
                          onPressed: () {
                            this._onSigInTap();
                          },
                          child: Text(
                            S.of(context).btn_login,
                            textAlign: TextAlign.center,
                            style: AppStyles.formTextStyle(AppColor.darkBlue,
                                    ScreenUtil().setSp(AppDimen.formTextSize))
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              );
            },
          ),
          SizedBox(
            height: ScreenUtil().setHeight(AppDimen.extraMargin),
          ),
          GestureDetector(
            onTap: () {
              widget.onForgotPasswordTap();
            },
            child: new Text(
              S.of(context).forgot_password,
              textAlign: TextAlign.center,
              style: AppStyles.defaultTextStyle().copyWith(
                decoration: TextDecoration.underline,
                fontSize: ScreenUtil().setSp(AppDimen.buttonTextSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _emailFocus.dispose();
    _password.dispose();

    this.userNameController.text = "";
    this.passwordController.text = "";

    super.dispose();
  }

  void _onSigInTap() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      this.userNameController.text = "";
      this.passwordController.text = "";
      _password.unfocus();
      _emailFocus.requestFocus();

      this.widget.onSignInTap(_currentUser);
    }
  }
}
