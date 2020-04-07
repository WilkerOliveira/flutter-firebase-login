import 'package:summarizeddebts/exceptions/custom_exception.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
import 'package:summarizeddebts/repositories/util/connectivity.dart';

abstract class BaseRepository {
  Future<void> checkInternetConnection() async {
    if (!await Connectivity.hasInternetConnection()) {
      throw CustomException.withCode(
          null, ExceptionMessages.noInternetConnection);
    }
  }
}
