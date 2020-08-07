import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/routing/router.dart' as router;
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
import 'package:flutter_dev_connector/services/post_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/app_theme.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/views/layout_template/layout_template.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
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
        ChangeNotifierProvider<AlertService>(
          create: (ctx) => AlertService(),
        ),
        ChangeNotifierProxyProvider<AuthService, ProfileService>(
          create: (ctx) => ProfileService(),
          update: (ctx, authService, profileService) =>
              profileService..updateAuth(authService),
        ),
        ChangeNotifierProxyProvider<AuthService, PostService>(
          create: (ctx) => PostService(),
          update: (ctx, authService, profileService) =>
              profileService..updateAuth(authService),
        ),
      ],
      child: Consumer<AuthService>(builder: (ctx, authService, _) {
        log.v('building MaterialApp with isAuth=${authService.isAuth}');
        return MaterialApp(
          title: 'Flutter Dev Connector',
          theme: getAppTheme(context),
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: (settings) =>
              router.generateRoute(authService, settings),
          initialRoute: DashboardViewRoute,
          builder: (context, child) => LayoutTemplate(
            child: child,
          ),
        );
      }),
    );
  }
}
