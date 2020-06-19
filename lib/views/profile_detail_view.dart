import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileDetailView extends StatelessWidget {
  static const routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    final String userId = ModalRoute.of(context).settings.arguments;
    return Consumer<ProfileService>(
      builder: (ctx, profileService, _) => FutureBuilder(
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
                    section(
                      context: context,
                      child: ProfileTop(profile),
                      color: Colors.cyan,
                    ),
                    SizedBox(height: 20),
                    section(context: context, child: ProfileAbout(profile)),
                    SizedBox(height: 20),
                    section(
                        context: context,
                        child: ProfileExperience(profile.experience)),
                    SizedBox(height: 20),
                    section(
                        context: context,
                        child: ProfileEducation(profile.education)),
                    SizedBox(height: 20),
                    section(
                        context: context,
                        child: ProfileGithub(profile.githubusername)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future _launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   throw 'Could not launch $url';
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

class ProfileTop extends StatelessWidget {
  final Profile profile;
  const ProfileTop(
    this.profile, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (profile.user.avatar != null)
          CircleAvatar(
            backgroundImage: NetworkImage("http:" + profile.user.avatar),
            // backgroundColor: Colors.transparent,
          ),
        Text(
          profile.status +
              (profile.company != null ? " at " + profile.company : null),
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        Text(
          profile.location,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
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

class ProfileAbout extends StatelessWidget {
  final Profile profile;
  const ProfileAbout(
    this.profile, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (profile.bio != null)
          Column(
            children: [
              Text(
                '${profile.user.name}\'s bio',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                profile.bio,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        Divider(height: 10, thickness: 2),
        Text(
          'Skill Set',
          style: TextStyle(
            fontSize: 24,
          ),
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

class ProfileExperience extends StatelessWidget {
  final List<Experience> experience;
  const ProfileExperience(
    this.experience, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy/MM/dd');
    return Column(
      children: [
        Text(
          'Experience',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) =>
              Divider(height: 10, thickness: 2),
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(experience[index].company,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 4),
              Text(dateFormatter.format(experience[index].from) +
                  ' - ' +
                  (experience[index].to == null
                      ? 'Now'
                      : dateFormatter.format(experience[index].to))),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Position:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 5.0),
                  Flexible(child: Text(experience[index].title)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Description:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 5.0),
                  Flexible(child: Text(experience[index].description)),
                ],
              ),
            ],
          ),
          itemCount: experience.length,
        ),
      ],
    );
  }
}

class ProfileEducation extends StatelessWidget {
  final List<Education> education;
  const ProfileEducation(
    this.education, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy/MM/dd');
    return Column(
      children: [
        Text(
          'Education',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) =>
              Divider(height: 10, thickness: 2),
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(education[index].school,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 4),
              Text(dateFormatter.format(education[index].from) +
                  ' - ' +
                  (education[index].to == null
                      ? 'Now'
                      : dateFormatter.format(education[index].to))),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Degree:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 5.0),
                  Flexible(child: Text(education[index].degree)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Field of Study:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 5.0),
                  Flexible(child: Text(education[index].fieldofstudy)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Description:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 5.0),
                  Flexible(child: Text(education[index].description)),
                ],
              ),
            ],
          ),
          itemCount: education.length,
        ),
      ],
    );
  }
}

class ProfileGithub extends StatelessWidget {
  final String username;
  const ProfileGithub(
    this.username, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileService>(
      builder: (ctx, profileService, _) => FutureBuilder(
        future: profileService.getGithubRepos(username),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final List<Repo> repos = snapshot.data;
          return Column(
            children: [
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.github),
                  Text(
                    'Github Repos',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (ctx, index) =>
                    Divider(height: 10, thickness: 2),
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repos[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (repos[index].description != null)
                            Text(
                              repos[index].description,
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 5,
                              // softWrap: true,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1), color: Colors.cyan),
                          child: Center(
                              child: Text(
                            'Stars: ${repos[index].stargazersCount}',
                            style: TextStyle(color: Colors.white),
                          )),
                          padding: EdgeInsets.all(4),
                          width: 100,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              color: Colors.black),
                          child: Center(
                              child: Text(
                            'Watchers: ${repos[index].watchersCount}',
                            style: TextStyle(color: Colors.white),
                          )),
                          padding: EdgeInsets.all(4),
                          width: 100,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              color: Colors.white),
                          child: Center(
                              child: Text(
                            'Forks: ${repos[index].forksCount}',
                            style: TextStyle(color: Colors.black45),
                          )),
                          padding: EdgeInsets.all(4),
                          width: 100,
                        ),
                      ],
                    ),
                  ],
                ),
                itemCount: repos.length,
              ),
            ],
          );
        },
      ),
    );
  }
}
