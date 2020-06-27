import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  static const routeName = '/dashboard';
  final log = getLogger('DashboardView');

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    final authService = Provider.of<AuthService>(context);
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
          final Profile profile = snapshot.data;
          final themeData = Theme.of(context);
          return Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: themeData.textTheme.headline3),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.person, color: themeData.accentColor),
                    Text('Welcome ${authService.user?.name}',
                        style: themeData.textTheme.headline5),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (profile == null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'You have not yet setup a profile, please add some info'),
                      RaisedButton(
                        child: Text('Create Profile',
                            style: themeData.accentTextTheme.button),
                        color: themeData.accentColor,
                        //textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/create-profile');
                        },
                      ),
                    ],
                  ),
                if (profile != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardActionsWidget(),
                      ExperienceWidget(profile.experience),
                      EducationWidget(profile.education),
                      FlatButton.icon(
                        icon: Icon(Icons.remove),
                        color: themeData.errorColor,
                        label: Text('Delete My Account'),
                        onPressed: () {},
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DashboardActionsWidget extends StatelessWidget {
  final log = getLogger('DashboardActionsWidget');

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    return Row(
      children: [
        FlatButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed('/edit-profile');
          },
          icon: Icon(Icons.person),
          label: Text('Edit Profile'),
        ),
      ],
    );
  }
}

class ExperienceWidget extends StatelessWidget {
  final log = getLogger('ExperienceWidget');
  final List<Experience> experience;

  ExperienceWidget(this.experience);

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    return Center(child: Text('Experience'));
  }
}

class EducationWidget extends StatelessWidget {
  final log = getLogger('EducationWidget');
  final List<Education> education;

  EducationWidget(this.education);

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    return Center(child: Text('Education'));
  }
}
