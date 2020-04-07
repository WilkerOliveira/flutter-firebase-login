import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/controller/base/base_controller.dart';
import 'package:summarizeddebts/exceptions/login_exception.dart';
import 'package:summarizeddebts/modules/login/model/user.dart';
import 'package:summarizeddebts/modules/login/repository/login_repository.dart';

part 'login_controller.g.dart';

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase extends BaseController with Store {
  LoginRepository _loginRepository;

  LoginControllerBase(this._loginRepository);

  @action
  Future<void> signIn(User user) async {
    setState(ViewState.Busy);

    super.error = false;
    super.customErrorMessage = null;

    try {
      await this._loginRepository.signIn(user.email, user.password);
    } on LoginException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
    } finally {
      setState(ViewState.Idle);
    }
  }

  @action
  Future<void> loginWithFacebook() async {
    setState(ViewState.Busy);

    super.error = false;
    super.customErrorMessage = null;

    try {
      await this._loginRepository.loginWithFacebook();

      return null;
    } on LoginException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
      return null;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
      return null;
    } finally {
      setState(ViewState.Idle);
    }
  }

  @action
  Future<void> loginWithGoogle() async {
    setState(ViewState.Busy);

    super.error = false;
    super.customErrorMessage = null;

    try {
      await this._loginRepository.loginWithGoogle();

      return null;
    } on LoginException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
      return null;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
      return null;
    } finally {
      setState(ViewState.Idle);
    }
  }

  @action
  Future<bool> sendPasswordResetEmail(String email) async {
    setState(ViewState.Busy);

    super.error = false;
    super.customErrorMessage = null;

    try {
      await this._loginRepository.sendPasswordResetEmail(email);

      return true;
    } on LoginException catch (ex) {
      super.error = true;
      super.customErrorMessage = ex.status;
      return false;
    } catch (ex) {
      super.error = true;
      super.customErrorMessage = null;
      return false;
    } finally {
      setState(ViewState.Idle);
    }
  }

  @action
  Future<void> logout() async {
    this._loginRepository.logout();
  }
}
