import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/extensions/string_extensions.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/routing/undefined_view.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/views/add_education.dart';
import 'package:flutter_dev_connector/views/add_experience.dart';
import 'package:flutter_dev_connector/views/auth_screen.dart';
import 'package:flutter_dev_connector/views/dashboard_view.dart';
import 'package:flutter_dev_connector/views/post_view.dart';
import 'package:flutter_dev_connector/views/posts_view.dart';
import 'package:flutter_dev_connector/views/profile_detail_view.dart';
import 'package:flutter_dev_connector/views/profile_list_view.dart';
import 'package:flutter_dev_connector/views/splash_screen.dart';
import 'package:flutter_dev_connector/views/update_profile_view.dart';

Route<dynamic> generateRoute(AuthService authService, RouteSettings settings) {
  var routingData = settings.name.getRoutingData; // Get the routing Data

  Widget ifAuth(Widget targetScreen) =>
      authService.isAuth ? targetScreen : AuthScreen();

  switch (routingData.route) {
    case DashboardViewRoute:
      return MaterialPageRoute(
        builder: (context) => authService.isAuth
            ? DashboardView()
            : FutureBuilder(
                future: authService.tryAutoLogin(),
                builder: (ctx, authSnapshot) =>
                    authSnapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
        settings: settings,
      );
    case ProfileListViewRoute:
      return MaterialPageRoute(
        builder: (context) => ProfileListView(),
        settings: settings,
      );
    case ProfileDetailViewRoute:
      var userId = routingData['id']; // Get the id from the data.
      return MaterialPageRoute(
        builder: (context) => ProfileDetailView(userId),
        settings: settings,
      );
    case UpdateProfileViewCreateRoute:
      return MaterialPageRoute(
        builder: (context) => ifAuth(UpdateProfileView()),
        settings: settings,
      );
    case UpdateProfileViewEditRoute:
      return MaterialPageRoute(
        builder: (context) => ifAuth(UpdateProfileView(true)),
        settings: settings,
      );
    case AuthScreenLoginRoute:
      return MaterialPageRoute(
        builder: (context) => ifAuth(AuthScreen()),
        settings: settings,
      );
    case AuthScreenSignupRoute:
      return MaterialPageRoute(
        builder: (context) => ifAuth(AuthScreen(true)),
        settings: settings,
      );
    case AddExperienceViewRoute:
      return MaterialPageRoute(
        builder: (context) => ifAuth(AddExperienceView()),
        settings: settings,
      );
    case AddEducationViewRoute:
      return MaterialPageRoute(
        builder: (context) => ifAuth(AddEducationView()),
        settings: settings,
      );
    case PostsViewRoute:
      return MaterialPageRoute(
        builder: (context) => ifAuth(PostsView()),
        settings: settings,
      );
    case PostViewRoute:
      var postId = routingData['id']; // Get the id from the data.
      return MaterialPageRoute(
        builder: (context) => ifAuth(PostView(postId)),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (context) => UndefinedView(name: settings.name),
        settings: settings,
      );
  }
}

String routeWithQueryParams(String routeName,
    {Map<String, String> queryParams}) {
  if (queryParams != null) {
    routeName = Uri(path: routeName, queryParameters: queryParams).toString();
  }
  return routeName;
}
