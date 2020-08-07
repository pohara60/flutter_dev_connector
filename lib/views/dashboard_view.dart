import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
import 'package:flutter_dev_connector/services/profile_service.dart';
import 'package:flutter_dev_connector/utils/date_format.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/alert_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  final log = getLogger('DashboardView');

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    final authService = Provider.of<AuthService>(context);
    final profileService = Provider.of<ProfileService>(context);
    return FutureBuilder(
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
              AlertWidget(),
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
                        locator<NavigationService>()
                            .navigateTo(UpdateProfileViewCreateRoute);
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
                      DeleteAccountWidget(
                          themeData: themeData, profileService: profileService),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class DeleteAccountWidget extends StatelessWidget {
  const DeleteAccountWidget({
    Key key,
    @required this.themeData,
    @required this.profileService,
  }) : super(key: key);

  final ThemeData themeData;
  final ProfileService profileService;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FlatButton.icon(
          icon: Icon(Icons.remove),
          color: themeData.errorColor,
          label: Text('Delete My Account'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Are you sure? This cannot be undone!'),
                content: Text('Do you want to delete ypur Account?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => locator<NavigationService>().goBack(false),
                  ),
                  FlatButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        await profileService.deleteAccount();
                        Provider.of<AlertService>(context, listen: false)
                            .addAlert(
                                "Your account has been permanently deleted");
                        locator<NavigationService>().goBack(true);
                      }),
                ],
              ),
            );
          },
        ),
      ],
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
            locator<NavigationService>().navigateTo(UpdateProfileViewEditRoute);
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
                locator<NavigationService>().navigateTo(AddExperienceViewRoute);
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
                        Provider.of<AlertService>(context, listen: false)
                            .addAlert("Experience deleted");
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
                locator<NavigationService>().navigateTo(AddEducationViewRoute);
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
                        Provider.of<AlertService>(context, listen: false)
                            .addAlert("Education deleted");
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
