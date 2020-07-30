import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
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
            'Dashboard',
            Icons.person,
            () =>
                Navigator.of(context).pushReplacementNamed(DashboardViewRoute),
          ),
          buildListTile(
            'Developers',
            Icons.developer_mode,
            () => Navigator.of(context)
                .pushReplacementNamed(ProfileListViewRoute),
          ),
          buildListTile(
            'Posts',
            Icons.email,
            () => Navigator.of(context).pushReplacementNamed(PostsViewRoute),
          ),
          buildListTile('Register', FontAwesomeIcons.pencilAlt, () {
            Navigator.of(context).pushReplacementNamed(AuthScreenSignupRoute);
          }),
          buildListTile('Login', FontAwesomeIcons.signInAlt, () {
            Navigator.of(context).pushReplacementNamed(AuthScreenLoginRoute);
          }),
          buildListTile('Logout', FontAwesomeIcons.signOutAlt, () {
            Provider.of<AuthService>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }
}
