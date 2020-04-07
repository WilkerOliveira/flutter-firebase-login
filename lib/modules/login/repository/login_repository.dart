import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/exceptions/login_exception.dart';
import 'package:summarizeddebts/modules/login/model/user.dart';
import 'package:summarizeddebts/modules/login/repository/api/login_api.dart';
import 'package:summarizeddebts/modules/login/repository/api/login_request.dart';
import 'package:summarizeddebts/repositories/base/base_repository.dart';

class LoginRepository extends BaseRepository {
  static final facebookLogin = "FACEBOOK";
  static final googleLogin = "GOOGLE";
  static final customLogin = "CUSTOM";

  final LoginApi _loginService;
  User currentUser;

  LoginRepository(this._loginService);

  Future<void> loginWithFacebook() async {
    //New version, but this new version has an issue
//    final facebookLoginResult =
//        await FacebookLogin().logIn(['email', 'public_profile']);
    //Old version
    final facebookLoginResult =
        await FacebookLogin().logIn(['email', 'public_profile']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          FirebaseUser firebaseUser = await this
              ._loginService
              .signInWithFacebook(facebookLoginResult.accessToken);

          if (firebaseUser != null)
            await mountUser(firebaseUser.uid, facebookLogin);
        } on PlatformException catch (ex) {
          if (ex.code == "ERROR_INVALID_CREDENTIAL") {
            throw new LoginException.withCode(
                null, ExceptionMessages.userNotRegistered);
          } else if (ex.code ==
              "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
            throw new LoginException.withCode(
                null, ExceptionMessages.userRegisteredWithDiffCredential);
          } else {
            throw new LoginException.withCode(null, ExceptionMessages.error);
          }
        } catch (ex) {
          throw new LoginException.withCode(null, ExceptionMessages.error);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw new LoginException.withCode(
            null, ExceptionMessages.cancelledByUser);
      case FacebookLoginStatus.error:
        throw new LoginException.withCode(null, ExceptionMessages.error);
    }
  }

  Future<void> loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    try {
      var firebaseUser =
          await this._loginService.signInWithGoogle(googleSignInAuthentication);

      if (firebaseUser != null) await mountUser(firebaseUser.uid, googleLogin);
    } on PlatformException catch (ex) {
      if (ex.code == "ERROR_INVALID_CREDENTIAL") {
        throw new LoginException.withCode(
            null, ExceptionMessages.userNotRegistered);
      } else if (ex.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
        throw new LoginException.withCode(
            null, ExceptionMessages.userRegisteredWithDiffCredential);
      } else {
        throw new LoginException.withCode(null, ExceptionMessages.error);
      }
    } catch (ex) {
      throw new LoginException.withCode(null, ExceptionMessages.error);
    }
  }

  Future<String> signUp(LoginRequest request) async {
    await super.checkInternetConnection();

    if (!await this._loginService.checkEmailExist(request.user.email)) {
      if (!await this._loginService.checkNickNameExist(request.user.nickName)) {
        var uuid = await this
            ._loginService
            .signUp(request.user.email, request.user.password);

        request.user.customLogin = customLogin;
        request.user.userID = uuid;
        request.user.password = null;

        this.addUser(request.user);

        await this._loginService.sendEmailVerification();

        return uuid;
      } else {
        throw LoginException.withCode(
            null, ExceptionMessages.userNickNameAlreadyExists);
      }
    } else {
      throw LoginException.withCode(
          null, ExceptionMessages.userEmailAlreadyExists);
    }
  }

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    return await this._loginService.getCurrentFirebaseUser();
  }

  Future<void> addUser(User user) async {
    bool userExist = await this._loginService.checkUserExist(user.userID);

    if (!userExist) {
      this._loginService.addUser(user);
    } else {
      print("User already exist");
    }
  }

  Future<User> getUser(String uid) async {
    try {
      User current = await this._loginService.getUser(uid);

      return current;
    } on Exception catch (ex) {
      print(ex);
      throw new LoginException.withCode(null, ExceptionMessages.error);
    }
  }

  Future<User> signIn(String email, String password) async {
    try {
      String uid = await this._loginService.signIn(email, password);

      if (uid != null) {
        if ((await getCurrentFirebaseUser()).isEmailVerified) {
          var user = await mountUser(null, customLogin);

          return user;
        } else {
          logout();
          throw new LoginException.withCode(
              null, ExceptionMessages.emailNotVerified);
        }
      }
    } on PlatformException catch (ex) {
      if (ex.code == "ERROR_WRONG_PASSWORD" ||
          ex.code == "ERROR_USER_NOT_FOUND") {
        throw new LoginException.withCode(
            null, ExceptionMessages.invalidEmailOrPassword);
      } else {
        throw new LoginException.withCode(null, ExceptionMessages.error);
      }
    }

    throw LoginException.withCode(null, ExceptionMessages.userNotRegistered);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await this._loginService.sendPasswordResetEmail(email);
    } on PlatformException catch (ex) {
      if (ex.code == "ERROR_USER_NOT_FOUND") {
        throw new LoginException.withCode(
            null, ExceptionMessages.emailNotFound);
      } else {
        throw new LoginException.withCode(null, ExceptionMessages.error);
      }
    }
  }

  Future<void> logout() async {
    await this._loginService.signOut();
  }

  Future<User> mountUser(String uid, String customLogin) async {
    var fireBaseUser = await this.getCurrentFirebaseUser();

    if (fireBaseUser != null) {
      var user = await getUser(fireBaseUser.uid);

      this.currentUser = new User(
        firstName: user == null ? fireBaseUser.displayName : user.firstName,
        userID: uid == null ? fireBaseUser.uid : uid,
        nickName: user == null ? "" : user.nickName,
        email: user == null ? fireBaseUser.email : user.email,
        profilePictureURL:
            user == null ? fireBaseUser.photoUrl : user.profilePictureURL,
        customLogin: user != null && customLogin == null
            ? user.customLogin
            : customLogin,
        customAvatar: user == null ? false : user.customAvatar,
      );

      await this.addUser(this.currentUser);
    }

    return this.currentUser;
  }
}
