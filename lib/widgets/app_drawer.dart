import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
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
            () => locator<NavigationService>()
                .navigateReplace(DashboardViewRoute),
          ),
          buildListTile(
            'Developers',
            Icons.developer_mode,
            () => locator<NavigationService>()
                .navigateReplace(ProfileListViewRoute),
          ),
          buildListTile(
            'Posts',
            Icons.email,
            () => locator<NavigationService>().navigateReplace(PostsViewRoute),
          ),
          buildListTile('Register', FontAwesomeIcons.pencilAlt, () {
            locator<NavigationService>().navigateReplace(AuthScreenSignupRoute);
          }),
          buildListTile('Login', FontAwesomeIcons.signInAlt, () {
            locator<NavigationService>().navigateReplace(AuthScreenLoginRoute);
          }),
          buildListTile('Logout', FontAwesomeIcons.signOutAlt, () {
            Provider.of<AuthService>(context, listen: false).logout();
            locator<NavigationService>().navigateReplace(AuthScreenLoginRoute);
          }),
        ],
      ),
    );
  }
}
