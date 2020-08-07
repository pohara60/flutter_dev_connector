import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return FlatButton.icon(
      icon: Icon(Icons.developer_mode, color: Colors.white),
      onPressed: null,
      label: Text('DevConnector',
          style: themeData.textTheme.headline5.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
