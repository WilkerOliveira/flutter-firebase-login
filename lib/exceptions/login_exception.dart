import 'package:summarizeddebts/exceptions/custom_exception.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';

class LoginException extends CustomException {
  LoginException(String cause) {
    this.cause = cause;
  }

  LoginException.withCode(String cause, ExceptionMessages status) {
    this.cause = cause;
    this.status = status;
  }
}
