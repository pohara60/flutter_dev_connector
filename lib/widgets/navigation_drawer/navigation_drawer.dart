import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/widgets/nav_bar_item/navbar_item.dart';
import 'package:flutter_dev_connector/widgets/navigation_drawer/navigation_drawer_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 16),
        ],
      ),
      child: Column(
        children: <Widget>[
          NavigationDrawerHeader(),
          // BONUS: Combine the UI for this widget with the NavBarItem and make it responsive.
          // The UI for the current DrawerItem shows when it's in mobile, else it shows the NavBarItem ui.
          if (authService.isAuth)
            NavBarItem(
              'Dashboard',
              DashboardViewRoute,
              icon: Icons.person,
              drawer: true,
            ),
          NavBarItem(
            'Developers',
            ProfileListViewRoute,
            icon: Icons.developer_mode,
            drawer: true,
          ),
          if (authService.isAuth)
            NavBarItem(
              'Posts',
              PostsViewRoute,
              icon: Icons.email,
              drawer: true,
            ),
          if (!authService.isAuth)
            NavBarItem(
              'Register',
              AuthScreenSignupRoute,
              icon: FontAwesomeIcons.pencilAlt,
              drawer: true,
            ),
          if (!authService.isAuth)
            NavBarItem(
              'Login',
              AuthScreenLoginRoute,
              icon: FontAwesomeIcons.signInAlt,
              drawer: true,
            ),
          if (authService.isAuth)
            NavBarItem(
              'Logout',
              AuthScreenLoginRoute,
              icon: FontAwesomeIcons.signOutAlt,
              action: authService.logout,
              drawer: true,
            ),
        ],
      ),
    );
  }
}
