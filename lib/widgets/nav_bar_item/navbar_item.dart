import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
import 'package:flutter_dev_connector/widgets/nav_bar_item/navbar_item_desktop.dart';
import 'package:flutter_dev_connector/widgets/nav_bar_item/navbar_item_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_dev_connector/models/navbar_item_model.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String navigationPath;
  final IconData icon;
  final Function action;
  final bool drawer;
  const NavBarItem(this.title, this.navigationPath,
      {this.icon, this.action, this.drawer = false});

  @override
  Widget build(BuildContext context) {
    var model = NavBarItemModel(
      title: title,
      navigationPath: navigationPath,
      iconData: icon,
    );
    return InkWell(
      onTap: () {
        // DON'T EVER USE A SERVICE DIRECTLY IN THE UI TO CHANGE ANY KIND OF STATE
        // SERVICES SHOULD ONLY BE USED FROM A VIEWMODEL
        if (drawer) {
          // Our navigator does not have drawer window
          //locator<NavigationService>().goBack(); // Pop drawer
        }
        if (action != null) {
          action();
        }
        locator<NavigationService>().navigateReplace(navigationPath);
      },
      child: ScreenTypeLayout(
        tablet: NavBarItemTabletDesktop(model),
        mobile: NavBarItemMobile(model),
      ),
    );
  }
}
