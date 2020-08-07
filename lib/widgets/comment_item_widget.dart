import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/models/post.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
import 'package:flutter_dev_connector/services/post_service.dart';
import 'package:flutter_dev_connector/utils/date_format.dart';
import 'package:provider/provider.dart';

class CommentItemWidget extends StatelessWidget {
  const CommentItemWidget({
    Key key,
    @required this.postId,
    @required this.comment,
  }) : super(key: key);

  final String postId;
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width - 40 - 22;
    final avatarWidth = width / 4;
    final commentWidth = width - avatarWidth;
    final dateFormat = getDateFormat();

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: avatarWidth,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (comment.avatar != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage("http:" + comment.avatar),
                  ),
                Text(
                  comment.name,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: commentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.text, style: themeData.textTheme.subtitle1),
                SizedBox(height: 10),
                Text(dateFormat.format(comment.date)),
                SizedBox(
                  width: 30,
                  child: FlatButton(
                    padding: EdgeInsets.all(1),
                    child: Icon(
                      Icons.remove,
                    ),
                    color: themeData.errorColor,
                    onPressed: () async {
                      try {
                        await Provider.of<PostService>(context, listen: false)
                            .removeComment(postId, comment);
                        Provider.of<AlertService>(context, listen: false)
                            .addAlert("Comment deleted");
                      } catch (error) {
                        await showDialog<Null>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('An error occurred!'),
                            content: Text(error.toString()),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    locator<NavigationService>().goBack();
                                  })
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
