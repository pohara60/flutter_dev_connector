import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:intl/intl.dart';

class ProfileEducationWidget extends StatelessWidget {
  final List<Education> education;
  const ProfileEducationWidget(
    this.education, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final dateFormatter = DateFormat('yyyy/MM/dd');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
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
                education[index].school,
                style: themeData.textTheme.subtitle1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
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
