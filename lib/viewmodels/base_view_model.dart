import 'package:flutter/widgets.dart';
import 'package:moneygram/utils/enum/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
