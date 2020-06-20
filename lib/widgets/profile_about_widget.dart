import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';

class ProfileAboutWidget extends StatelessWidget {
  final Profile profile;
  const ProfileAboutWidget(
    this.profile, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        if (profile.bio != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${profile.user.name}\'s Bio',
                style: themeData.textTheme.headline5,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                profile.bio,
                style: themeData.textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        Divider(height: 10, thickness: 2),
        Text(
          'Skill Set',
          style: themeData.textTheme.headline5,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10.0,
          children: profile.skills
              .map(
                (skill) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check),
                    Text(skill),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
