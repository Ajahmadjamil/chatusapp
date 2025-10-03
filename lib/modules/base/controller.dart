import 'dart:async';
import 'package:chatus/modules/base/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BaseController extends ChangeNotifier {
  BaseRepository apiHandler = BaseRepository();
  bool isLoading = false;

  int count = 0;
  int mCount = 0;
  List<String> list = [];
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;
  int _index = 0;

  int get index => _index;

  setIndex(val) {
    _index = val;
    notifyListeners();
  }

  BaseController() {
    init();
  }

  init() async {}

  set index(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void setAlert(bool status) {
    isAlertSet = status;
    notifyListeners();
  }
}
