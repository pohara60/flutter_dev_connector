import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/utils/date_format.dart';

class ProfileExperienceWidget extends StatelessWidget {
  final List<Experience> experience;
  const ProfileExperienceWidget(
    this.experience, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience',
          style: themeData.textTheme.headline5,
        ),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) =>
              Divider(height: 10, thickness: 2),
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                experience[index].company,
                style: themeData.textTheme.subtitle1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(formatDateRange(
                  experience[index].from, experience[index].to)),
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
