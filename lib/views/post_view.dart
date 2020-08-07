import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/models/post.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
import 'package:flutter_dev_connector/services/post_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/alert_widget.dart';
import 'package:flutter_dev_connector/widgets/comment_item_widget.dart';
import 'package:flutter_dev_connector/widgets/post_item_widget.dart';
import 'package:provider/provider.dart';

class PostView extends StatelessWidget {
  final log = getLogger('PostView');
  final String _postId;

  PostView(this._postId);

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    var _comment = Comment();
    final postService = Provider.of<PostService>(context);
    return FutureBuilder(
      future: postService.getPost(_postId),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        final post = snapshot.data;
        final themeData = Theme.of(context);
        return Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AlertWidget(),
                PostItemWidget(post: post, update: false),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: themeData.accentColor,
                  width: double.infinity,
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Make a Comment...',
                    style: themeData.textTheme.headline6.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Make a Comment',
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  onChanged: (value) => _comment.text = value,
                ),
                RaisedButton(
                  child: Text('Submit'),
                  color: themeData.primaryColor,
                  onPressed: () async {
                    if (_comment.text.trim() != '') {
                      try {
                        await postService.addComment(post.id, _comment);
                        Provider.of<AlertService>(context, listen: false)
                            .addAlert("Comment added");
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
                    }
                  },
                ),
                if (post.comments != null)
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => CommentItemWidget(
                      postId: post.id,
                      comment: post.comments[index],
                      key: ValueKey(post.comments[index].id),
                    ),
                    itemCount: post.comments.length,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
