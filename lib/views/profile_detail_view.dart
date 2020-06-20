import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/profile_about_widget.dart';
import 'package:flutter_dev_connector/widgets/profile_education.dart';
import 'package:flutter_dev_connector/widgets/profile_experience_widget.dart';
import 'package:flutter_dev_connector/widgets/profile_github_widget.dart';
import 'package:flutter_dev_connector/widgets/profile_top_widget.dart';
import 'package:provider/provider.dart';

class ProfileDetailView extends StatelessWidget {
  static const routeName = "/profile";
  final log = getLogger('ProfileDetailView');

  @override
  Widget build(BuildContext context) {
    log.v('build called v');
    // TODO: Why does this line causes rebuild on pop?
    final String userId = ModalRoute.of(context).settings.arguments;
    final profileService = Provider.of<ProfileService>(context, listen: false);
    return FutureBuilder(
      future: profileService.getProfileById(userId),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final Profile profile = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(profile.user.name),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  // FlatButton.icon(
                  //   icon: Icon(Icons.arrow_back),
                  //   label: Text('Go Back'),
                  //   onPressed: () {
                  //     Navigator.of(ctx).pop();
                  //   },
                  // ),
                  section(
                    context: context,
                    child: ProfileTopWidget(profile),
                    color: Colors.cyan,
                  ),
                  SizedBox(height: 20),
                  section(context: context, child: ProfileAboutWidget(profile)),
                  SizedBox(height: 20),
                  section(
                      context: context,
                      child: ProfileExperienceWidget(profile.experience)),
                  SizedBox(height: 20),
                  section(
                      context: context,
                      child: ProfileEducationWidget(profile.education)),
                  SizedBox(height: 20),
                  section(
                      context: context,
                      child: ProfileGithubWidget(profile.githubusername)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget section({BuildContext context, Widget child, Color color}) {
  //if (color == null) color = Theme.of(context).backgroundColor;
  return Material(
    color:
        color, // Set background color on Material so IconButton splash is visible
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    ),
  );
}
