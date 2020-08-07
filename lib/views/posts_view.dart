import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/models/post.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
import 'package:flutter_dev_connector/services/post_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/alert_widget.dart';
import 'package:flutter_dev_connector/widgets/post_item_widget.dart';
import 'package:provider/provider.dart';

class PostsView extends StatelessWidget {
  final log = getLogger('PostsView');

  @override
  Widget build(BuildContext context) {
    log.v('build called');
    var _post = Post();
    final authService = Provider.of<AuthService>(context);
    final postService = Provider.of<PostService>(context);
    return FutureBuilder(
      future: postService.getPosts(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        final List<Post> posts = snapshot.data;
        final themeData = Theme.of(context);
        return Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AlertWidget(),
                Text('Posts', style: themeData.textTheme.headline3),
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
                Container(
                  color: themeData.accentColor,
                  width: double.infinity,
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Say Something...',
                    style: themeData.textTheme.headline6.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Create a post',
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  onChanged: (value) => _post.text = value,
                ),
                RaisedButton(
                  child: Text('Submit'),
                  color: themeData.primaryColor,
                  onPressed: () async {
                    if (_post.text.trim() != '') {
                      try {
                        _post = await postService.addPost(_post);
                        Provider.of<AlertService>(context, listen: false)
                            .addAlert("Post added");
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
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => PostItemWidget(
                      post: posts[index], key: ValueKey(posts[index].id)),
                  itemCount: posts.length,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
