import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/models/user.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:provider/provider.dart';

class CreateProfileView extends StatelessWidget {
  static const routeName = "/create-profile";
  final log = getLogger('CreateProfileView');

  @override
  Widget build(BuildContext context) {
    log.v('build called v');
    final authService = Provider.of<AuthService>(context);
    final profileService = Provider.of<ProfileService>(context, listen: false);
    final profile = Profile(
      id: '',
      user: User(
        id: '',
        name: '',
        email: '',
        password: '',
        avatar: '',
        date: DateTime.now(),
      ),
      company: '',
      website: '',
      location: '',
      status: '',
      skills: [],
      bio: '',
      githubusername: '',
      experience: [],
      education: [],
      social: Social(
        youtube: '',
        twitter: '',
        facebook: '',
        linkedin: '',
        instagram: '',
      ),
      date: DateTime.now(),
    );

    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(authService.user.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FlatButton.icon(
              //   icon: Icon(Icons.arrow_back),
              //   label: Text('Go Back'),
              //   onPressed: () {
              //     Navigator.of(ctx).pop();
              //   },
              // ),
              Text('Create Your Profile', style: themeData.textTheme.headline5),
              Text('Let\'s get some information to make your profile stand out',
                  style: themeData.textTheme.headline6),
            ],
          ),
        ),
      ),
    );
  }
}
