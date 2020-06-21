import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/views/profile_detail_view.dart';
import 'package:flutter_dev_connector/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  static const routeName = '/dashboard';
  final log = getLogger('DashboardView');

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    final profileService = Provider.of<ProfileService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dev Connector'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: profileService.getCurrentProfile(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData) {
            var error = profileService.error;
            String msg;
            if (error == null)
              msg = 'Profile is empty without error!';
            else
              msg = error['msg'];
            return Center(
                child: Text(msg, style: Theme.of(context).textTheme.headline5));
          }
          final Profile profile = snapshot.data;
          return ProfileListTileView(profile);
        },
      ),
    );
  }
}

class ProfileListTileView extends StatelessWidget {
  final Profile profile;
  const ProfileListTileView(this.profile);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ListTile(
      leading: profile.user.avatar == null
          ? null
          : CircleAvatar(
              backgroundImage: NetworkImage("http:" + profile.user.avatar),
              // backgroundColor: Colors.transparent,
            ),
      title: Text(
        profile.user.name,
        style: themeData.textTheme.headline6,
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
