import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future _launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   throw 'Could not launch $url';
  }
}

class ProfileTopWidget extends StatelessWidget {
  final Profile profile;
  const ProfileTopWidget(
    this.profile, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        if (profile.user.avatar != null)
          CircleAvatar(
            backgroundImage: NetworkImage("http:" + profile.user.avatar),
            // backgroundColor: Colors.transparent,
          ),
        Text(
          profile.user.name,
          style: themeData.textTheme.headline5.copyWith(color: Colors.white),
        ),
        Text(
          profile.status +
              (profile.company != null ? " at " + profile.company : null),
          style: themeData.textTheme.headline6.copyWith(color: Colors.white),
        ),
        Text(
          profile.location,
          style: themeData.textTheme.headline6.copyWith(color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (profile.website != null)
              IconButton(
                icon: Icon(Icons.web),
                color: Colors.white,
                highlightColor: Colors.pink,
                hoverColor: Colors.red,
                onPressed: () => _launchURL(profile.website),
              ),
            if (profile.social?.facebook != null)
              IconButton(
                icon: FaIcon(FontAwesomeIcons.facebook),
                color: Colors.white,
                highlightColor: Colors.pink,
                onPressed: () => _launchURL(profile.social.facebook),
              ),
            if (profile.social?.twitter != null)
              IconButton(
                icon: FaIcon(FontAwesomeIcons.twitter),
                color: Colors.white,
                highlightColor: Colors.pink,
                onPressed: () => _launchURL(profile.social.twitter),
              ),
            if (profile.social?.linkedin != null)
              IconButton(
                icon: FaIcon(FontAwesomeIcons.linkedin),
                color: Colors.white,
                highlightColor: Colors.pink,
                onPressed: () => _launchURL(profile.social.linkedin),
              ),
            if (profile.social?.youtube != null)
              IconButton(
                icon: FaIcon(FontAwesomeIcons.youtube),
                color: Colors.white,
                highlightColor: Colors.pink,
                onPressed: () => _launchURL(profile.social.youtube),
              ),
            if (profile.social?.instagram != null)
              IconButton(
                icon: FaIcon(FontAwesomeIcons.instagram),
                color: Colors.white,
                highlightColor: Colors.pink,
                onPressed: () => _launchURL(profile.social.instagram),
              ),
          ],
        ),
      ],
    );
  }
}
