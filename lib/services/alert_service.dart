import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_dev_connector/models/alert.dart';

const ALERT_DURATION = 4;

class AlertService with ChangeNotifier {
  Timer _alertTimer;
  List<Alert> _alerts = [];
  List<DateTime> _alertExpiryTimes = [];

  List<Alert> get alerts => _alerts;

  bool get isAlert {
    return _alerts.length > 0;
  }

  void addAlert(String msg, [AlertType alertType = AlertType.Success]) {
    _alerts.insert(0, Alert(alertType, msg));
    final duration = Duration(seconds: ALERT_DURATION);
    _alertExpiryTimes.insert(0, DateTime.now().add(duration));
    if (_alertTimer == null) {
      _alertTimer = Timer(duration, expireAlert);
    }
    notifyListeners();
  }

  void expireAlert() {
    // Earliest (top) alert always expires first
    // Also expire alerts that are about to expire
    DateTime expiryTime = DateTime.now().add(Duration(milliseconds: 100));
    int last = _alerts.length - 1;
    while (last >= 0 && _alertExpiryTimes[last].isBefore(expiryTime)) {
      _alerts.length = last;
      _alertExpiryTimes.length = last;
      last--;
    }

    _alertTimer = null;
    if (last >= 0) {
      final duration = _alertExpiryTimes[last].difference(DateTime.now());
      _alertTimer = Timer(duration, expireAlert);
    }
    notifyListeners();
  }
}
