import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/alert.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:provider/provider.dart';

class AlertWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Consumer<AlertService>(
      builder: (ctx, alertService, _) => Column(
        children: alertService.alerts
            .map(
              (alert) => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: alert.alertType == AlertType.Success
                      ? Colors.green
                      : alert.alertType == AlertType.Danger
                          ? themeData.errorColor
                          : alert.alertType == AlertType.Primary
                              ? themeData.highlightColor
                              : themeData.highlightColor,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Text(alert.msg),
              ),
            )
            .toList(),
      ),
    );
  }
}
