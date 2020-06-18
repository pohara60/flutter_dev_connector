import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:provider/provider.dart';

class ProfileListView extends StatelessWidget {
  static const routeName = '/profiles';

  const ProfileListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
