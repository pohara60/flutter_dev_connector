import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/app_theme.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/views/auth_screen.dart';
import 'package:flutter_dev_connector/views/dashboard_view.dart';
import 'package:flutter_dev_connector/views/profile_list_view.dart';
import 'package:flutter_dev_connector/views/splash_screen.dart';
import 'package:flutter_dev_connector/views/update_profile_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DevConnectorApp());
}

class DevConnectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final log = getLogger('DevConnectorApp');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (ctx) => AuthService(),
        ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        //   create: (ctx) => Products(),
        //   update: (ctx, auth, products) => products
        //     ..update(
        //       auth.token,
        //       auth.userId,
        //     ),
        // ),
        ChangeNotifierProxyProvider<AuthService, ProfileService>(
          create: (ctx) => ProfileService(),
          update: (ctx, authService, profileService) =>
              profileService..updateAuth(authService),
        ),
      ],
      child: Consumer<AuthService>(builder: (ctx, authService, _) {
        Widget ifAuth(Widget targetScreen) =>
            authService.isAuth ? targetScreen : AuthScreen();
        log.v('building MaterialApp with isAuth=${authService.isAuth}');
        return MaterialApp(
          title: 'Flutter Dev Connector',
          theme: getAppTheme(context),
          home: authService.isAuth
              ? DashboardView()
              : FutureBuilder(
                  future: authService.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            DashboardView.routeName: (ctx) => ifAuth(DashboardView()),
            ProfileListView.routeName: (ctx) => ProfileListView(),
            UpdateProfileView.createRouteName: (ctx) =>
                ifAuth(UpdateProfileView()),
            UpdateProfileView.editRouteName: (ctx) =>
                ifAuth(UpdateProfileView(true)),
          },
        );
      }),
    );
  }
}
