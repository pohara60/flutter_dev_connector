import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/date_format.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        DashboardActionsWidget(),
                        ExperienceWidget(profile.experience),
                        EducationWidget(profile.education),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Experience', style: themeData.textTheme.headline5),
            FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/add-experience');
              },
              icon: Icon(FontAwesomeIcons.blackTie),
              label: Text('Add Experience'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Table(columnWidths: {
          3: FixedColumnWidth(30)
        }, children: [
          TableRow(
            decoration: BoxDecoration(
              color: themeData.backgroundColor,
            ),
            children: [
              PaddedCell('Company', heading: true, themeData: themeData),
              PaddedCell('Title', heading: true, themeData: themeData),
              PaddedCell('Years', heading: true, themeData: themeData),
              PaddedCell('', heading: true, themeData: themeData),
            ],
          ),
          ...experience
              .map(
                (exp) => TableRow(
                  children: [
                    PaddedCell(exp.company, themeData: themeData),
                    PaddedCell(exp.title, themeData: themeData),
                    PaddedCell(formatDateRange(exp.from, exp.to),
                        themeData: themeData),
                    FlatButton(
                      padding: EdgeInsets.all(1),
                      child: Icon(
                        Icons.remove,
                      ),
                      color: themeData.errorColor,
                      onPressed: () async {
                        Provider.of<ProfileService>(context, listen: false)
                            .deleteExperience(exp);
                      },
                    ),
                  ],
                ),
              )
              .toList(),
        ]),
        SizedBox(height: 10),
      ],
    );
  }
}

class PaddedCell extends StatelessWidget {
  const PaddedCell(
    this.text, {
    this.themeData,
    this.heading = false,
  });

  final ThemeData themeData;
  final String text;
  final bool heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: heading
            ? themeData.textTheme.subtitle2
                .copyWith(fontWeight: FontWeight.bold)
            : themeData.textTheme.subtitle2,
      ),
    );
  }
}

class EducationWidget extends StatelessWidget {
  final log = getLogger('EducationWidget');
  final List<Education> education;

  EducationWidget(this.education);

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Education', style: themeData.textTheme.headline5),
            FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/add-education');
              },
              icon: Icon(FontAwesomeIcons.graduationCap),
              label: Text('Add Education'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Table(columnWidths: {
          3: FixedColumnWidth(30)
        }, children: [
          TableRow(
            decoration: BoxDecoration(
              color: themeData.backgroundColor,
            ),
            children: [
              PaddedCell('School', heading: true, themeData: themeData),
              PaddedCell('Degree', heading: true, themeData: themeData),
              PaddedCell('Years', heading: true, themeData: themeData),
              PaddedCell('', heading: true, themeData: themeData),
            ],
          ),
          ...education
              .map(
                (edu) => TableRow(
                  children: [
                    PaddedCell(edu.school, themeData: themeData),
                    PaddedCell(edu.degree, themeData: themeData),
                    PaddedCell(formatDateRange(edu.from, edu.to),
                        themeData: themeData),
                    FlatButton(
                      padding: EdgeInsets.all(1),
                      child: Icon(
                        Icons.remove,
                      ),
                      color: themeData.errorColor,
                      onPressed: () async {
                        Provider.of<ProfileService>(context, listen: false)
                            .deleteEducation(edu);
                      },
                    ),
                  ],
                ),
              )
              .toList(),
        ]),
        SizedBox(height: 10),
      ],
    );
  }
}
