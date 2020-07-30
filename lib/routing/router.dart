import 'package:flutter/material.dart';
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
  Widget ifAuth(Widget targetScreen) =>
      authService.isAuth ? targetScreen : AuthScreen();

  switch (settings.name) {
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
      );
    case ProfileListViewRoute:
      return MaterialPageRoute(builder: (context) => ProfileListView());
    case ProfileDetailViewRoute:
      final userId = settings.arguments;
      return MaterialPageRoute(builder: (context) => ProfileDetailView(userId));
    case UpdateProfileViewCreateRoute:
      return MaterialPageRoute(
          builder: (context) => ifAuth(UpdateProfileView()));
    case UpdateProfileViewEditRoute:
      return MaterialPageRoute(
          builder: (context) => ifAuth(UpdateProfileView(true)));
    case AuthScreenLoginRoute:
      return MaterialPageRoute(builder: (context) => ifAuth(AuthScreen()));
    case AuthScreenSignupRoute:
      return MaterialPageRoute(builder: (context) => ifAuth(AuthScreen(true)));
    case AddExperienceViewRoute:
      return MaterialPageRoute(
          builder: (context) => ifAuth(AddExperienceView()));
    case AddEducationViewRoute:
      return MaterialPageRoute(
          builder: (context) => ifAuth(AddEducationView()));
    case PostsViewRoute:
      return MaterialPageRoute(builder: (context) => ifAuth(PostsView()));
    case PostViewRoute:
      final postId = settings.arguments;
      return MaterialPageRoute(builder: (context) => ifAuth(PostView(postId)));

    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(name: settings.name));
  }
}
