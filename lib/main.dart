import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/views/profile_list_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<Auth>(
        //   create: (ctx) => Auth(),
        // ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        //   create: (ctx) => Products(),
        //   update: (ctx, auth, products) => products
        //     ..update(
        //       auth.token,
        //       auth.userId,
        //     ),
        // ),
        ChangeNotifierProvider<ProfileService>(
          create: (ctx) => ProfileService(),
        ),
      ],
      // child: Consumer<Auth>(
      //   builder: (ctx, auth, _) {
      //     ifAuth(targetScreen) => auth.isAuth ? targetScreen : AuthScreen();
      // return MaterialApp(
      child: MaterialApp(
        title: 'Flutter Dev Connector',
        // theme: ThemeData(
        //     primarySwatch: Colors.purple,
        //     accentColor: Colors.deepOrange,
        //     fontFamily: 'Lato',
        //     pageTransitionsTheme: PageTransitionsTheme(builders: {
        //       TargetPlatform.android: CustomerPageTransitionBuilder(),
        //       TargetPlatform.iOS: CustomerPageTransitionBuilder(),
        //     })),
        // home: auth.isAuth
        //     ? ProductsOverviewScreen()
        //     : FutureBuilder(
        //         future: auth.tryAutoLogin(),
        //         builder: (ctx, authSnapshot) =>
        //             authSnapshot.connectionState ==
        //                     ConnectionState.waiting
        //                 ? SplashScreen()
        //                 : AuthScreen(),
        //       ),
        home: ProfileListView(),
        routes: {
          // ProfileListView.routeName: (ctx) => ifAuth(ProfileListView()),
          ProfileListView.routeName: (ctx) => ProfileListView(),
        },
      ),
    );
  }
}
