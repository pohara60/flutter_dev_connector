import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget buildListTile(String title, IconData icon, Function tapHandler) =>
      ListTile(
        leading: Icon(
          icon,
          // size: 26,
        ),
        title: Text(
          title,
          // style: TextStyle(
          //   fontSize: 24,
          //   fontWeight: FontWeight.bold,
          // ),
        ),
        onTap: () => tapHandler(),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Dev Connector'),
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 20),
          // DrawerHeader(
          //   child: Text('Dev Connector'),
          // ),
//          SizedBox(height: 20),
          buildListTile(
            'Developers',
            Icons.developer_mode,
            () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          buildListTile('Register', FontAwesomeIcons.pencilAlt, () {
            //Navigator.of(context)
            //.pushReplacement(CustomRoute(builder: (ctx) => OrdersScreen()));
          }),
          buildListTile('Login', FontAwesomeIcons.signInAlt, () {
            //Navigator.of(context)
            //.pushReplacement(CustomRoute(builder: (ctx) => OrdersScreen()));
          }),
          buildListTile('Logout', FontAwesomeIcons.signOutAlt, () {
            // Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            //Provider.of<Auth>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }
}
