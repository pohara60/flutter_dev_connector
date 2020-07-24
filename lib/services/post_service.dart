import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/config/config.dart';
import 'package:flutter_dev_connector/models/post.dart';
import 'package:flutter_dev_connector/models/user.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:http/http.dart' as http;

class PostService with ChangeNotifier {
  static final _log = getLogger('PostService');

  Post _post;
  List<Post> _posts;
  bool _isLoading;
  Map _error;
  AuthService _authService;

  Post get post => _post;
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  Map get error => _error;

  Future<List<Post>> getPosts() async {
    try {
      _isLoading = true;
      final url = BASE_URL + '/api/posts';
      final headers = _authService?.getAuthHeader();
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        var listMap = jsonDecode(res.body);
        _posts = listMap.map<Post>((post) => Post.fromJson(post)).toList();
      } else {
        _error = jsonDecode(res.body);
      }
      _isLoading = false;
    } on SocketException catch (err) {
      _error = {'msg': err.osError.message};
    } catch (err) {
      _error = {
        'msg': err.toString(),
      };
      _posts = null;
      _isLoading = false;
    }
    // Do not notifyListeners because not required
    //notifyListeners();
    return posts;
  }

  Future<Post> getPost(String postId) async {
    _log.v("getPost");
    try {
      _isLoading = true;
      final url = "$BASE_URL/api/posts/$postId";
      final headers = _authService?.getAuthHeader();
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        _post = Post.fromJson(jsonDecode(res.body));
      } else {
        _error = jsonDecode(res.body);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
      };
      _post = null;
      _isLoading = false;
    }
    // Do not notifyListeners because not required
    //notifyListeners();
    return post;
  }

  void updateAuth(AuthService authService) {
    _authService = authService;
    User user = authService.user;

    if (_post != null && user?.id != _post.userId) {
      // Clear current user post
      _post = null;
      notifyListeners();
    }
  }

  Future<Post> addPost(Post post) async {
    _log.v('addPost');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final body = jsonEncode(post.toJson());
      final res = await http.post(
        "$BASE_URL/api/posts",
        body: body,
        headers: {...headers, "Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        _post = Post.fromJson(jsonDecode(res.body));
      } else {
        throw HttpException(jsonDecode(res.body)['msg']);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
      };
      _post = null;
      _isLoading = false;
      rethrow;
    }
    // Do not notifyListeners because not required
    notifyListeners();
    return post;
  }

  Future<void> _addRemoveLike(String type, String postId) async {
    _log.v('_addRemoveLike');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final res = await http.put(
        "$BASE_URL/api/post/$type/$postId",
        headers: {...headers, "Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        if (_post?.id != postId) {
          await getPost(postId);
          assert(_post?.id == postId, "Post not found");
        }
        _post.likes = (jsonDecode(res.body) as List)
            ?.map((e) =>
                e == null ? null : Like.fromJson(e as Map<String, dynamic>))
            ?.toList();
      } else {
        final response = jsonDecode(res.body) as Map<String, dynamic>;
        String msg = 'Unknown error!';
        if (response.containsKey('errors')) {
          final errors = response['errors'] as List<dynamic>;
          msg = errors.map((err) => err['msg']).join('\n');
        } else if (response.containsKey('msg')) {
          msg = response['msg'];
        }
        throw HttpException(msg);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
      };
      _post = null;
      _isLoading = false;
      rethrow;
    }
    notifyListeners();
    return;
  }

  Future<void> addLike(String postId) async {
    return _addRemoveLike('like', postId);
  }

  Future<void> removeLike(String postId) async {
    return _addRemoveLike('unlike', postId);
  }

  Future<void> _addRemoveComment(
      String type, String postId, Comment comment) async {
    _log.v('_addRemoveComment');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      var res;
      if (type == 'add') {
        final body = jsonEncode(comment.toJson());
        res = await http.post(
          "$BASE_URL/api/posts/comment/$postId",
          headers: {...headers, "Content-Type": "application/json"},
          body: body,
        );
      } else {
        res = await http.delete(
          "$BASE_URL/api/posts/comment/$postId/${comment.id}",
          headers: headers,
        );
      }
      if (res.statusCode == 200) {
        if (_post?.id != postId) {
          await getPost(postId);
          assert(_post?.id == postId, "Post not found");
        }
        _post.comments = (jsonDecode(res.body) as List)
            ?.map((e) =>
                e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
            ?.toList();
      } else {
        final response = jsonDecode(res.body) as Map<String, dynamic>;
        String msg = 'Unknown error!';
        if (response.containsKey('errors')) {
          final errors = response['errors'] as List<dynamic>;
          msg = errors.map((err) => err['msg']).join('\n');
        } else if (response.containsKey('msg')) {
          msg = response['msg'];
        }
        throw HttpException(msg);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
      };
      _post = null;
      _isLoading = false;
      rethrow;
    }
    notifyListeners();
    return;
  }

  Future<void> addComment(String postId, Comment comment) async {
    return _addRemoveComment('add', postId, comment);
  }

  Future<void> removeComment(String postId, Comment comment) async {
    return _addRemoveComment('remove', postId, comment);
  }

  Future<void> deletePost(String postId) async {
    _log.v('deletePost');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final res = await http.delete(
        "$BASE_URL/api/posts/$postId",
        headers: headers,
      );
      if (res.statusCode != 200) {
        final response = jsonDecode(res.body) as Map<String, dynamic>;
        String msg = 'Unknown error!';
        if (response.containsKey('errors')) {
          final errors = response['errors'] as List<dynamic>;
          msg = errors.map((err) => err['msg']).join('\n');
        } else if (response.containsKey('msg')) {
          msg = response['msg'];
        }
        throw HttpException(msg);
      }
      _post = null;
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
      };
      _isLoading = false;
      rethrow;
    }
    //notifyListeners();
  }
}
