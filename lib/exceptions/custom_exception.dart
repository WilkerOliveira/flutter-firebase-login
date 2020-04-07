import 'package:summarizeddebts/exceptions/exception_messages.dart';

class CustomException implements Exception {
  String cause;
  ExceptionMessages status;

  CustomException();

  CustomException.withCause(this.cause);

  CustomException.withCode(this.cause, this.status);
}
