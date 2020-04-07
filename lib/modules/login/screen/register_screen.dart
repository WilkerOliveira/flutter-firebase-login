import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/generated/i18n.dart';
import 'package:summarizeddebts/modules/login/controller/register_controller.dart';
import 'package:summarizeddebts/modules/login/model/user.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';
import 'package:summarizeddebts/ui/resources/app_dimen.dart';
import 'package:summarizeddebts/ui/resources/app_styles.dart';
import 'package:summarizeddebts/ui/utility/screen_utility.dart';
import 'package:summarizeddebts/ui/validation/common_form_validation.dart';
import 'package:summarizeddebts/ui/validation/register_form_validation.dart';
import 'package:summarizeddebts/ui/widget/appbar/custom_appbar.dart';
import 'package:summarizeddebts/ui/widget/dialog/alert_dialogs.dart';
import 'package:summarizeddebts/ui/widget/progress/custom_circular_progress_indicator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState
    extends ModularState<RegisterScreen, RegisterController>
    with CommonFormValidation, RegisterFormValidation {
  final _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  var emailKey = GlobalKey<FormFieldState>();

  User newUser = User();

  FocusNode _nameFocus;
  FocusNode _emailFocus;
  FocusNode _emailConfirmFocus;
  FocusNode _password;
  FocusNode _confPassword;

  Size _size;

  @override
  void initState() {
    super.initState();

    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _emailConfirmFocus = FocusNode();
    _password = FocusNode();
    _confPassword = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _nameFocus.dispose();
    _emailFocus.dispose();
    _emailConfirmFocus.dispose();
    _password.dispose();
    _confPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.commonValidationContext = context;
    this.registerValidationContext = context;
    this._size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
              appBarType: AppBarType.simple, title: S.of(context).new_register)
          .build(context),
      body: SingleChildScrollView(child: _body()),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(AppDimen.defaultMargin),
        right: ScreenUtil().setWidth(AppDimen.defaultMargin),
      ),
      color: AppColor.darkBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          registerForm(),
          Observer(builder: (_) {
            return controller.viewState == ViewState.Busy
                ? CustomCircularProgressIndicator()
                : submitButton();
          }),
          SizedBox(
            height: ScreenUtil().setHeight(
              AppDimen.sizedBoxSpace,
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButton() {
    return Material(
      elevation: ScreenUtil().setWidth(5.0),
      borderRadius: BorderRadius.circular(
        ScreenUtil().setWidth(AppDimen.borderButton),
      ),
      color: AppColor.loginButtonBackground,
      child: MaterialButton(
        minWidth: ScreenUtil().setWidth(this._size.width),
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(0.0),
          ScreenUtil().setWidth(20.0),
          ScreenUtil().setWidth(0.0),
          ScreenUtil().setWidth(20.0),
        ),
        onPressed: () async {
          _doRegister();
        },
        child: Text(
          S.of(context).btn_register,
          textAlign: TextAlign.center,
          style: AppStyles.formTextStyle(
                  AppColor.darkBlue, ScreenUtil().setSp(AppDimen.formTextSize))
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _doRegister() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      AlertDialogs.showLoading(context, S.of(context).please_wait);

      await controller.registerNewUser(newUser);

      AlertDialogs.closeDialog(context);

      if (controller.isError) {
        AlertDialogs.showErrorDialog(
            context, S.of(context).error_title, controller.errorMessage);
      } else if (controller.errorMessage != null &&
          controller.errorMessage.toString().isNotEmpty) {
        AlertDialogs.showInfoDialog(
            context, S.of(context).info_title, controller.errorMessage);
      } else {
        AlertDialogs.showSuccessDialog(
            context,
            S.of(context).success_title,
            S.of(context).email_confirmation_sent,
            () => Navigator.pop(context));
      }
    }
  }

  Widget registerForm() {
    final nameField = ScreenUtility.getBaseTextFormField(
        context: context,
        maxLength: 50,
        onSaved: (String value) {
          newUser.firstName = value.trim();
        },
        textInputAction: TextInputAction.next,
        focusNode: _nameFocus,
        validator: requiredField,
        onFieldSubmitted: (term) {
          ScreenUtility.fieldFocusChange(context, _nameFocus, _emailFocus);
        });

    final emailField = ScreenUtility.getBaseTextFormField(
      context: context,
      key: emailKey,
      maxLength: 100,
      onSaved: (String value) {
        newUser.email = value.trim();
      },
      validator: emailValidation,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(context, _emailFocus, _emailConfirmFocus);
      },
      keyboardType: TextInputType.emailAddress,
    );

    final confirmEmailField = ScreenUtility.getBaseTextFormField(
      context: context,
      keyboardType: TextInputType.emailAddress,
      maxLength: 100,
      onSaved: (String value) {
        newUser.email = value.trim();
      },
      validator: (confirmation) {
        String email = emailKey.currentState.value;
        return confirmation.trim() == email.trim()
            ? null
            : S.of(context).email_not_match;
      },
      textInputAction: TextInputAction.next,
      focusNode: _emailConfirmFocus,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(context, _emailFocus, _password);
      },
    );

    final passwordField = ScreenUtility.getBaseTextFormField(
      context: context,
      obscureText: true,
      key: passKey,
      maxLength: 8,
      onSaved: (String value) {
        newUser.password = value.trim();
      },
      validator: passwordValidation,
      textInputAction: TextInputAction.next,
      focusNode: _password,
      onFieldSubmitted: (term) {
        ScreenUtility.fieldFocusChange(context, _password, _confPassword);
      },
    );

    final confirmPassword = ScreenUtility.getBaseTextFormField(
      context: context,
      obscureText: true,
      maxLength: 8,
      onSaved: (String value) {
        newUser.confirmPassword = value.trim();
      },
      validator: (confirmation) {
        String password = passKey.currentState.value;
        return confirmation.trim() == password.trim()
            ? null
            : S.of(context).password_not_match;
      },
      textInputAction: TextInputAction.done,
      focusNode: _confPassword,
      onFieldSubmitted: (term) {
        _doRegister();
      },
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(10),
                  left: ScreenUtil().setWidth(5)),
              child: Text(
                S.of(context).name,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: nameField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).email,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: emailField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).confirm_email,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: confirmEmailField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).password,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: passwordField,
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            Padding(
              padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(5),
              ),
              child: Text(
                S.of(context).confirm_password,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: confirmPassword,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
          ],
        ),
      ),
    );
  }
}
