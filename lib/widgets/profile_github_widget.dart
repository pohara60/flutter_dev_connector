import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileGithubWidget extends StatelessWidget {
  final String username;
  const ProfileGithubWidget(
    this.username, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
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
                  FaIcon(FontAwesomeIcons.github, color: themeData.accentColor),
                  SizedBox(width: 10),
                  Text(
                    'Github Repos',
                    style: themeData.textTheme.headline5,
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
                            style: themeData.textTheme.headline6,
                          ),
                          if (repos[index].description != null)
                            Text(
                              repos[index].description,
                              style: themeData.textTheme.bodyText1,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        CountBox(
                          color: Theme.of(context).accentColor,
                          text: Text(
                            'Stars: ${repos[index].stargazersCount}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        CountBox(
                          color: Theme.of(context).primaryColor,
                          text: Text(
                            'Watchers: ${repos[index].watchersCount}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        CountBox(
                          color: Colors.white,
                          text: Text(
                            'Forks: ${repos[index].forksCount}',
                            style: TextStyle(color: Colors.black),
                          ),
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

class CountBox extends StatelessWidget {
  final Text text;
  final Color color;
  const CountBox({@required this.text, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1), color: color),
      child: Center(child: text),
      padding: EdgeInsets.all(4),
      width: 100,
    );
  }
}
