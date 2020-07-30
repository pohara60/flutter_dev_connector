import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/models/post.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/post_service.dart';
import 'package:provider/provider.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({
    Key key,
    @required this.post,
    this.update = true,
  }) : super(key: key);

  final Post post;
  final bool update;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width - 40 - 22;
    final avatarWidth = width / 4;
    final postWidth = width - avatarWidth;

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
                if (post.avatar != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage("http:" + post.avatar),
                  ),
                Text(
                  post.name,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: postWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.text, style: themeData.textTheme.subtitle1),
                SizedBox(height: 10),
                Text('No date!'),
                if (update)
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    IconButton(
                      padding: EdgeInsets.all(1),
                      onPressed: () async {
                        Provider.of<PostService>(context, listen: false)
                            .addLike(post.id);
                      },
                      icon: Icon(Icons.thumb_up),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(1),
                      onPressed: () async {
                        Provider.of<PostService>(context, listen: false)
                            .removeLike(post.id);
                      },
                      icon: Icon(Icons.thumb_down),
                    ),
                    RaisedButton(
                      child: Text('Discussion',
                          style: themeData.accentTextTheme.button),
                      color: themeData.accentColor,
                      onPressed: !update
                          ? null
                          : () {
                              Navigator.of(context).pushNamed(
                                PostViewRoute,
                                arguments: post.id,
                              );
                            },
                    ),
                    SizedBox(width: 16),
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
                              await Provider.of<PostService>(context,
                                      listen: false)
                                  .deletePost(post.id);
                              Provider.of<AlertService>(context, listen: false)
                                  .addAlert("Post deleted");
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
                                          Navigator.of(ctx).pop();
                                        })
                                  ],
                                ),
                              );
                            }
                          }),
                    ),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
