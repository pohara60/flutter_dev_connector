import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/widgets/nav_bar_item/navbar_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'navbar_logo.dart';

class NavigationBarTabletDesktop extends StatelessWidget {
  const NavigationBarTabletDesktop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final themeData = Theme.of(context);
    return Container(
      height: 80,
      color: themeData.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (authService.isAuth)
                NavBarItem(
                  'Dashboard',
                  DashboardViewRoute,
                  icon: Icons.person,
                ),
              if (authService.isAuth)
                SizedBox(
                  width: 20,
                ),
              NavBarItem(
                'Developers',
                ProfileListViewRoute,
                icon: Icons.developer_mode,
              ),
              SizedBox(
                width: 20,
              ),
              if (authService.isAuth)
                NavBarItem(
                  'Posts',
                  PostsViewRoute,
                  icon: Icons.email,
                ),
              if (authService.isAuth)
                SizedBox(
                  width: 20,
                ),
              if (!authService.isAuth)
                NavBarItem(
                  'Register',
                  AuthScreenSignupRoute,
                  icon: FontAwesomeIcons.pencilAlt,
                ),
              if (!authService.isAuth)
                SizedBox(
                  width: 20,
                ),
              if (!authService.isAuth)
                NavBarItem(
                  'Login',
                  AuthScreenLoginRoute,
                  icon: FontAwesomeIcons.signInAlt,
                ),
              if (!authService.isAuth)
                SizedBox(
                  width: 20,
                ),
              if (authService.isAuth)
                NavBarItem(
                  'Logout',
                  AuthScreenLoginRoute,
                  icon: FontAwesomeIcons.signOutAlt,
                  action: authService.logout,
                ),
            ],
          )
        ],
      ),
    );
  }
}
