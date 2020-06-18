import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileService(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dev Connector'),
        ),
        body: Consumer<ProfileService>(
          builder: (ctx, profileService, _) => FutureBuilder(
            future: profileService.getProfiles(),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              final List<Profile> profiles = snapshot.data;
              return ListView(
                children: profiles.map((p) => Text(p.user.name)).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
