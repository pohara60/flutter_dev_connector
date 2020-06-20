import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:intl/intl.dart';

class ProfileExperienceWidget extends StatelessWidget {
  final List<Experience> experience;
  const ProfileExperienceWidget(
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
