import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/views/profile_detail_view.dart';
import 'package:provider/provider.dart';

class ProfileListView extends StatelessWidget {
  static const routeName = '/profiles';
  final log = getLogger('ProfileListView');

  @override
  Widget build(BuildContext context) {
    log.v('build called');
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
            return ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (ctx, index) => ProfileListTileView(profiles[index]),
            );
          },
        ),
      ),
    );
  }
}

class ProfileListTileView extends StatelessWidget {
  final Profile profile;
  const ProfileListTileView(this.profile);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: profile.user.avatar == null
          ? null
          : CircleAvatar(
              backgroundImage: NetworkImage("http:" + profile.user.avatar),
              // backgroundColor: Colors.transparent,
            ),
      title: Text(
        profile.user.name,
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      subtitle: Text(
        profile.status +
            (profile.company != null ? " at " + profile.company : null),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ProfileDetailView(),
            settings: RouteSettings(arguments: profile.user.id),
          ),
        );
      },
    );
  }
}
