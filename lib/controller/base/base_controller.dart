import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:summarizeddebts/exceptions/exception_messages.dart';
part "base_controller.g.dart";

/// Represents the state of the view
enum ViewState { Idle, Busy }

class BaseController = BaseControllerBase with _$BaseController;

abstract class BaseControllerBase with Store {
  @observable
  ViewState _state = ViewState.Idle;

  ViewState get viewState => this._state;

  @protected
  bool error;
  @protected
  ExceptionMessages customErrorMessage;

  bool isEditing = false;

  bool get isError => error;

  ExceptionMessages get errorMessage => customErrorMessage;

  @action
  void setState(ViewState viewState) {
    _state = viewState;
  }

  void logError(ex) {
    print(ex.toString());
  }
}
