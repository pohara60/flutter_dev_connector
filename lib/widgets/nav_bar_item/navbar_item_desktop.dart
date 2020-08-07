import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/navbar_item_model.dart';

class NavBarItemTabletDesktop extends StatelessWidget {
  final NavBarItemModel model;
  NavBarItemTabletDesktop(this.model);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Text(
      model.title,
      style: themeData.textTheme.headline5.copyWith(color: Colors.white),
    );
  }
}
