import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/config/config.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:flutter_dev_connector/models/user.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:http/http.dart' as http;

class ProfileService with ChangeNotifier {
  static final _log = getLogger('ProfileService');

  Profile _profile;
  List<Profile> _profiles;
  List<Repo> _repos;
  bool _isLoading;
  Map _error;
  AuthService _authService;

  Profile get profile => _profile;
  List<Profile> get profiles => _profiles;
  List<Repo> get repos => _repos;
  bool get isLoading => _isLoading;
  Map get error => _error;

  Future<Profile> getCurrentProfile() async {
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final res = await http.get("$BASE_URL/api/profile/me", headers: headers);
      if (res.statusCode == 200) {
        _profile = Profile.fromJson(jsonDecode(res.body));
      } else {
        _error = jsonDecode(res.body);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
        // 'msg': err.response.statusText,
        // 'status': err.response.status,
      };
      _profile = null;
      _isLoading = false;
    }
    // Do not notifyListeners because not required
    //notifyListeners();
    return profile;
  }

  Future<List<Profile>> getProfiles() async {
    try {
      _isLoading = true;
      final url = BASE_URL + '/api/profile';
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var listMap = jsonDecode(res.body);
        _profiles =
            listMap.map<Profile>((prof) => Profile.fromJson(prof)).toList();
      } else {
        _error = jsonDecode(res.body);
      }
      _isLoading = false;
    } on SocketException catch (err) {
      _error = {'msg': err.osError.message};
    } catch (err) {
      _error = {
        'msg': err.toString(),
        // 'msg': err.response.statusText,
        // 'status': err.response.status,
      };
      _profiles = null;
      _isLoading = false;
    }
    // Do not notifyListeners because not required
    //notifyListeners();
    return profiles;
  }

  Future<Profile> getProfileById(String userId) async {
    try {
      _isLoading = true;
      final res = await http.get("$BASE_URL/api/profile/user/$userId");
      if (res.statusCode == 200) {
        _profile = Profile.fromJson(jsonDecode(res.body));
      } else {
        _error = jsonDecode(res.body);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
        // 'msg': err.response.statusText,
        // 'status': err.response.status,
      };
      _profile = null;
      _isLoading = false;
    }
    // Do not notifyListeners because not required
    //notifyListeners();
    return profile;
  }

  Future<List<Repo>> getGithubRepos(String username) async {
    try {
      _isLoading = true;
      if (FAKE_GITHUB) {
        const response = '''
[{"id":272963775,"node_id":"MDEwOlJlcG9zaXRvcnkyNzI5NjM3NzU=","name":"flutter_dev_connector","full_name":"pohara60/flutter_dev_connector","private":false,"owner":{"login":"pohara60","id":32934801,"node_id":"MDQ6VXNlcjMyOTM0ODAx","avatar_url":"https://avatars3.githubusercontent.com/u/32934801?v=4","gravatar_id":"","url":"https://api.github.com/users/pohara60","html_url":"https://github.com/pohara60","followers_url":"https://api.github.com/users/pohara60/followers","following_url":"https://api.github.com/users/pohara60/following{/other_user}","gists_url":"https://api.github.com/users/pohara60/gists{/gist_id}","starred_url":"https://api.github.com/users/pohara60/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/pohara60/subscriptions","organizations_url":"https://api.github.com/users/pohara60/orgs","repos_url":"https://api.github.com/users/pohara60/repos","events_url":"https://api.github.com/users/pohara60/events{/privacy}","received_events_url":"https://api.github.com/users/pohara60/received_events","type":"User","site_admin":false},"html_url":"https://github.com/pohara60/flutter_dev_connector","description":"Flutter version of dev_connector from MERN course","fork":false,"url":"https://api.github.com/repos/pohara60/flutter_dev_connector","forks_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/forks","keys_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/keys{/key_id}","collaborators_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/collaborators{/collaborator}","teams_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/teams","hooks_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/hooks","issue_events_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/issues/events{/number}","events_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/events","assignees_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/assignees{/user}","branches_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/branches{/branch}","tags_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/tags","blobs_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/git/blobs{/sha}","git_tags_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/git/tags{/sha}","git_refs_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/git/refs{/sha}","trees_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/git/trees{/sha}","statuses_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/statuses/{sha}","languages_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/languages","stargazers_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/stargazers","contributors_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/contributors","subscribers_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/subscribers","subscription_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/subscription","commits_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/commits{/sha}","git_commits_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/git/commits{/sha}","comments_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/comments{/number}","issue_comment_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/issues/comments{/number}","contents_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/contents/{+path}","compare_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/compare/{base}...{head}","merges_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/merges","archive_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/{archive_format}{/ref}","downloads_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/downloads","issues_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/issues{/number}","pulls_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/pulls{/number}","milestones_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/milestones{/number}","notifications_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/notifications{?since,all,participating}","labels_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/labels{/name}","releases_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/releases{/id}","deployments_url":"https://api.github.com/repos/pohara60/flutter_dev_connector/deployments","created_at":"2020-06-17T12:06:01Z","updated_at":"2020-06-17T12:07:51Z","pushed_at":"2020-06-17T12:07:47Z","git_url":"git://github.com/pohara60/flutter_dev_connector.git","ssh_url":"git@github.com:pohara60/flutter_dev_connector.git","clone_url":"https://github.com/pohara60/flutter_dev_connector.git","svn_url":"https://github.com/pohara60/flutter_dev_connector","homepage":null,"size":67,"stargazers_count":0,"watchers_count":0,"language":"Dart","has_issues":true,"has_projects":true,"has_downloads":true,"has_wiki":true,"has_pages":false,"forks_count":0,"mirror_url":null,"archived":false,"disabled":false,"open_issues_count":0,"license":null,"forks":0,"open_issues":0,"watchers":0,"default_branch":"master"},{"id":171319062,"node_id":"MDEwOlJlcG9zaXRvcnkxNzEzMTkwNjI=","name":"web-queens","full_name":"pohara60/web-queens","private":false,"owner":{"login":"pohara60","id":32934801,"node_id":"MDQ6VXNlcjMyOTM0ODAx","avatar_url":"https://avatars3.githubusercontent.com/u/32934801?v=4","gravatar_id":"","url":"https://api.github.com/users/pohara60","html_url":"https://github.com/pohara60","followers_url":"https://api.github.com/users/pohara60/followers","following_url":"https://api.github.com/users/pohara60/following{/other_user}","gists_url":"https://api.github.com/users/pohara60/gists{/gist_id}","starred_url":"https://api.github.com/users/pohara60/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/pohara60/subscriptions","organizations_url":"https://api.github.com/users/pohara60/orgs","repos_url":"https://api.github.com/users/pohara60/repos","events_url":"https://api.github.com/users/pohara60/events{/privacy}","received_events_url":"https://api.github.com/users/pohara60/received_events","type":"User","site_admin":false},"html_url":"https://github.com/pohara60/web-queens","description":"Web Queens in Python","fork":false,"url":"https://api.github.com/repos/pohara60/web-queens","forks_url":"https://api.github.com/repos/pohara60/web-queens/forks","keys_url":"https://api.github.com/repos/pohara60/web-queens/keys{/key_id}","collaborators_url":"https://api.github.com/repos/pohara60/web-queens/collaborators{/collaborator}","teams_url":"https://api.github.com/repos/pohara60/web-queens/teams","hooks_url":"https://api.github.com/repos/pohara60/web-queens/hooks","issue_events_url":"https://api.github.com/repos/pohara60/web-queens/issues/events{/number}","events_url":"https://api.github.com/repos/pohara60/web-queens/events","assignees_url":"https://api.github.com/repos/pohara60/web-queens/assignees{/user}","branches_url":"https://api.github.com/repos/pohara60/web-queens/branches{/branch}","tags_url":"https://api.github.com/repos/pohara60/web-queens/tags","blobs_url":"https://api.github.com/repos/pohara60/web-queens/git/blobs{/sha}","git_tags_url":"https://api.github.com/repos/pohara60/web-queens/git/tags{/sha}","git_refs_url":"https://api.github.com/repos/pohara60/web-queens/git/refs{/sha}","trees_url":"https://api.github.com/repos/pohara60/web-queens/git/trees{/sha}","statuses_url":"https://api.github.com/repos/pohara60/web-queens/statuses/{sha}","languages_url":"https://api.github.com/repos/pohara60/web-queens/languages","stargazers_url":"https://api.github.com/repos/pohara60/web-queens/stargazers","contributors_url":"https://api.github.com/repos/pohara60/web-queens/contributors","subscribers_url":"https://api.github.com/repos/pohara60/web-queens/subscribers","subscription_url":"https://api.github.com/repos/pohara60/web-queens/subscription","commits_url":"https://api.github.com/repos/pohara60/web-queens/commits{/sha}","git_commits_url":"https://api.github.com/repos/pohara60/web-queens/git/commits{/sha}","comments_url":"https://api.github.com/repos/pohara60/web-queens/comments{/number}","issue_comment_url":"https://api.github.com/repos/pohara60/web-queens/issues/comments{/number}","contents_url":"https://api.github.com/repos/pohara60/web-queens/contents/{+path}","compare_url":"https://api.github.com/repos/pohara60/web-queens/compare/{base}...{head}","merges_url":"https://api.github.com/repos/pohara60/web-queens/merges","archive_url":"https://api.github.com/repos/pohara60/web-queens/{archive_format}{/ref}","downloads_url":"https://api.github.com/repos/pohara60/web-queens/downloads","issues_url":"https://api.github.com/repos/pohara60/web-queens/issues{/number}","pulls_url":"https://api.github.com/repos/pohara60/web-queens/pulls{/number}","milestones_url":"https://api.github.com/repos/pohara60/web-queens/milestones{/number}","notifications_url":"https://api.github.com/repos/pohara60/web-queens/notifications{?since,all,participating}","labels_url":"https://api.github.com/repos/pohara60/web-queens/labels{/name}","releases_url":"https://api.github.com/repos/pohara60/web-queens/releases{/id}","deployments_url":"https://api.github.com/repos/pohara60/web-queens/deployments","created_at":"2019-02-18T16:36:33Z","updated_at":"2019-02-18T17:47:20Z","pushed_at":"2019-02-18T17:47:19Z","git_url":"git://github.com/pohara60/web-queens.git","ssh_url":"git@github.com:pohara60/web-queens.git","clone_url":"https://github.com/pohara60/web-queens.git","svn_url":"https://github.com/pohara60/web-queens","homepage":null,"size":2,"stargazers_count":0,"watchers_count":0,"language":"HTML","has_issues":true,"has_projects":true,"has_downloads":true,"has_wiki":true,"has_pages":false,"forks_count":0,"mirror_url":null,"archived":false,"disabled":false,"open_issues_count":0,"license":null,"forks":0,"open_issues":0,"watchers":0,"default_branch":"master"},{"id":112924082,"node_id":"MDEwOlJlcG9zaXRvcnkxMTI5MjQwODI=","name":"web-sudoku-solver","full_name":"pohara60/web-sudoku-solver","private":false,"owner":{"login":"pohara60","id":32934801,"node_id":"MDQ6VXNlcjMyOTM0ODAx","avatar_url":"https://avatars3.githubusercontent.com/u/32934801?v=4","gravatar_id":"","url":"https://api.github.com/users/pohara60","html_url":"https://github.com/pohara60","followers_url":"https://api.github.com/users/pohara60/followers","following_url":"https://api.github.com/users/pohara60/following{/other_user}","gists_url":"https://api.github.com/users/pohara60/gists{/gist_id}","starred_url":"https://api.github.com/users/pohara60/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/pohara60/subscriptions","organizations_url":"https://api.github.com/users/pohara60/orgs","repos_url":"https://api.github.com/users/pohara60/repos","events_url":"https://api.github.com/users/pohara60/events{/privacy}","received_events_url":"https://api.github.com/users/pohara60/received_events","type":"User","site_admin":false},"html_url":"https://github.com/pohara60/web-sudoku-solver","description":null,"fork":false,"url":"https://api.github.com/repos/pohara60/web-sudoku-solver","forks_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/forks","keys_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/keys{/key_id}","collaborators_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/collaborators{/collaborator}","teams_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/teams","hooks_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/hooks","issue_events_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/issues/events{/number}","events_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/events","assignees_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/assignees{/user}","branches_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/branches{/branch}","tags_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/tags","blobs_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/git/blobs{/sha}","git_tags_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/git/tags{/sha}","git_refs_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/git/refs{/sha}","trees_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/git/trees{/sha}","statuses_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/statuses/{sha}","languages_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/languages","stargazers_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/stargazers","contributors_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/contributors","subscribers_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/subscribers","subscription_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/subscription","commits_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/commits{/sha}","git_commits_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/git/commits{/sha}","comments_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/comments{/number}","issue_comment_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/issues/comments{/number}","contents_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/contents/{+path}","compare_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/compare/{base}...{head}","merges_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/merges","archive_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/{archive_format}{/ref}","downloads_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/downloads","issues_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/issues{/number}","pulls_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/pulls{/number}","milestones_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/milestones{/number}","notifications_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/notifications{?since,all,participating}","labels_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/labels{/name}","releases_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/releases{/id}","deployments_url":"https://api.github.com/repos/pohara60/web-sudoku-solver/deployments","created_at":"2017-12-03T11:58:43Z","updated_at":"2020-01-14T17:53:57Z","pushed_at":"2020-04-30T13:58:06Z","git_url":"git://github.com/pohara60/web-sudoku-solver.git","ssh_url":"git@github.com:pohara60/web-sudoku-solver.git","clone_url":"https://github.com/pohara60/web-sudoku-solver.git","svn_url":"https://github.com/pohara60/web-sudoku-solver","homepage":null,"size":70,"stargazers_count":0,"watchers_count":0,"language":"JavaScript","has_issues":true,"has_projects":true,"has_downloads":true,"has_wiki":true,"has_pages":false,"forks_count":0,"mirror_url":null,"archived":false,"disabled":false,"open_issues_count":1,"license":null,"forks":0,"open_issues":1,"watchers":0,"default_branch":"master"},{"id":107561063,"node_id":"MDEwOlJlcG9zaXRvcnkxMDc1NjEwNjM=","name":"quiz-exercise","full_name":"pohara60/quiz-exercise","private":false,"owner":{"login":"pohara60","id":32934801,"node_id":"MDQ6VXNlcjMyOTM0ODAx","avatar_url":"https://avatars3.githubusercontent.com/u/32934801?v=4","gravatar_id":"","url":"https://api.github.com/users/pohara60","html_url":"https://github.com/pohara60","followers_url":"https://api.github.com/users/pohara60/followers","following_url":"https://api.github.com/users/pohara60/following{/other_user}","gists_url":"https://api.github.com/users/pohara60/gists{/gist_id}","starred_url":"https://api.github.com/users/pohara60/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/pohara60/subscriptions","organizations_url":"https://api.github.com/users/pohara60/orgs","repos_url":"https://api.github.com/users/pohara60/repos","events_url":"https://api.github.com/users/pohara60/events{/privacy}","received_events_url":"https://api.github.com/users/pohara60/received_events","type":"User","site_admin":false},"html_url":"https://github.com/pohara60/quiz-exercise","description":null,"fork":false,"url":"https://api.github.com/repos/pohara60/quiz-exercise","forks_url":"https://api.github.com/repos/pohara60/quiz-exercise/forks","keys_url":"https://api.github.com/repos/pohara60/quiz-exercise/keys{/key_id}","collaborators_url":"https://api.github.com/repos/pohara60/quiz-exercise/collaborators{/collaborator}","teams_url":"https://api.github.com/repos/pohara60/quiz-exercise/teams","hooks_url":"https://api.github.com/repos/pohara60/quiz-exercise/hooks","issue_events_url":"https://api.github.com/repos/pohara60/quiz-exercise/issues/events{/number}","events_url":"https://api.github.com/repos/pohara60/quiz-exercise/events","assignees_url":"https://api.github.com/repos/pohara60/quiz-exercise/assignees{/user}","branches_url":"https://api.github.com/repos/pohara60/quiz-exercise/branches{/branch}","tags_url":"https://api.github.com/repos/pohara60/quiz-exercise/tags","blobs_url":"https://api.github.com/repos/pohara60/quiz-exercise/git/blobs{/sha}","git_tags_url":"https://api.github.com/repos/pohara60/quiz-exercise/git/tags{/sha}","git_refs_url":"https://api.github.com/repos/pohara60/quiz-exercise/git/refs{/sha}","trees_url":"https://api.github.com/repos/pohara60/quiz-exercise/git/trees{/sha}","statuses_url":"https://api.github.com/repos/pohara60/quiz-exercise/statuses/{sha}","languages_url":"https://api.github.com/repos/pohara60/quiz-exercise/languages","stargazers_url":"https://api.github.com/repos/pohara60/quiz-exercise/stargazers","contributors_url":"https://api.github.com/repos/pohara60/quiz-exercise/contributors","subscribers_url":"https://api.github.com/repos/pohara60/quiz-exercise/subscribers","subscription_url":"https://api.github.com/repos/pohara60/quiz-exercise/subscription","commits_url":"https://api.github.com/repos/pohara60/quiz-exercise/commits{/sha}","git_commits_url":"https://api.github.com/repos/pohara60/quiz-exercise/git/commits{/sha}","comments_url":"https://api.github.com/repos/pohara60/quiz-exercise/comments{/number}","issue_comment_url":"https://api.github.com/repos/pohara60/quiz-exercise/issues/comments{/number}","contents_url":"https://api.github.com/repos/pohara60/quiz-exercise/contents/{+path}","compare_url":"https://api.github.com/repos/pohara60/quiz-exercise/compare/{base}...{head}","merges_url":"https://api.github.com/repos/pohara60/quiz-exercise/merges","archive_url":"https://api.github.com/repos/pohara60/quiz-exercise/{archive_format}{/ref}","downloads_url":"https://api.github.com/repos/pohara60/quiz-exercise/downloads","issues_url":"https://api.github.com/repos/pohara60/quiz-exercise/issues{/number}","pulls_url":"https://api.github.com/repos/pohara60/quiz-exercise/pulls{/number}","milestones_url":"https://api.github.com/repos/pohara60/quiz-exercise/milestones{/number}","notifications_url":"https://api.github.com/repos/pohara60/quiz-exercise/notifications{?since,all,participating}","labels_url":"https://api.github.com/repos/pohara60/quiz-exercise/labels{/name}","releases_url":"https://api.github.com/repos/pohara60/quiz-exercise/releases{/id}","deployments_url":"https://api.github.com/repos/pohara60/quiz-exercise/deployments","created_at":"2017-10-19T14:58:23Z","updated_at":"2017-10-19T15:33:09Z","pushed_at":"2017-10-19T15:33:08Z","git_url":"git://github.com/pohara60/quiz-exercise.git","ssh_url":"git@github.com:pohara60/quiz-exercise.git","clone_url":"https://github.com/pohara60/quiz-exercise.git","svn_url":"https://github.com/pohara60/quiz-exercise","homepage":null,"size":3,"stargazers_count":0,"watchers_count":0,"language":"JavaScript","has_issues":true,"has_projects":true,"has_downloads":true,"has_wiki":true,"has_pages":false,"forks_count":0,"mirror_url":null,"archived":false,"disabled":false,"open_issues_count":0,"license":null,"forks":0,"open_issues":0,"watchers":0,"default_branch":"master"}]
''';
        var listMap = jsonDecode(response);
        _repos = listMap.map<Repo>((prof) => Repo.fromJson(prof)).toList();
      } else {
        final url = BASE_URL + '/api/profile/github/$username';
        final res = await http.get(url);
        if (res.statusCode == 200) {
          var listMap = jsonDecode(res.body);
          _repos = listMap.map<Repo>((prof) => Repo.fromJson(prof)).toList();
        } else {
          _error = jsonDecode(res.body);
        }
        _isLoading = false;
      }
    } catch (err) {
      _error = {
        'msg': err.toString(),
        // 'msg': err.response.statusText,
        // 'status': err.response.status,
      };
      _repos = null;
      _isLoading = false;
    }
    // Do not notifyListeners because not required, also causes loop
    //notifyListeners();
    return repos;
  }

  void updateAuth(AuthService authService) {
    _authService = authService;
    User user = authService.user;

    if (_profile != null && user?.id != _profile.user.id) {
      // Clear current user profile
      _profile = null;
      notifyListeners();
    }
  }

  addProfile(Profile profile) {
    _log.v('addProfile');
  }

  updateProfile(String id, Profile profile) {
    _log.v('updateProfile');
  }
}
