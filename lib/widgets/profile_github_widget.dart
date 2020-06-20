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
