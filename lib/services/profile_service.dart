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
      final url = BASE_URL + '/api/profile/github/$username';
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var listMap = jsonDecode(res.body);
        _repos = listMap.map<Repo>((prof) => Repo.fromJson(prof)).toList();
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

    if (_profile != null && user?.id != _profile.user?.id) {
      // Clear current user profile
      _profile = null;
      notifyListeners();
    }
  }

  Future<Profile> updateProfile(Profile profile) async {
    _log.v('updateProfile');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final body = jsonEncode(profile.toJson());
      final res = await http.post(
        "$BASE_URL/api/profile",
        body: body,
        headers: {...headers, "Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        _profile = Profile.fromJson(jsonDecode(res.body));
      } else {
        throw HttpException(jsonDecode(res.body)['msg']);
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
      rethrow;
    }
    // Do not notifyListeners because not required
    notifyListeners();
    return profile;
  }

  Future<void> _addExperienceEducation(String type, String body) async {
    _log.v('_addExperienceEducation');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final res = await http.put(
        "$BASE_URL/api/profile/$type",
        body: body,
        headers: {...headers, "Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        _profile = Profile.fromJson(jsonDecode(res.body));
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
        // 'msg': err.response.statusText,
        // 'status': err.response.status,
      };
      _profile = null;
      _isLoading = false;
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addExperience(Experience experience) {
    _log.v('addExperience');
    return _addExperienceEducation(
        'experience', jsonEncode(experience.toJson()));
  }

  Future<void> addEducation(Education education) {
    _log.v('addEducation');
    return _addExperienceEducation('education', jsonEncode(education.toJson()));
  }

  Future<void> _deleteExperienceEducation(String type, String id) async {
    _log.v('_deleteExperienceEducation');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final res = await http.delete(
        "$BASE_URL/api/profile/$type/$id",
        headers: headers,
      );
      if (res.statusCode == 200) {
        _profile = Profile.fromJson(jsonDecode(res.body));
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
      _profile = null;
      _isLoading = false;
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteExperience(Experience experience) {
    _log.v('deleteExperience');
    return _deleteExperienceEducation('experience', experience.id);
  }

  Future<void> deleteEducation(Education education) {
    _log.v('deleteEducation');
    return _deleteExperienceEducation('education', education.id);
  }

  Future<void> deleteAccount() async {
    _log.v('deleteAccount');
    try {
      _isLoading = true;
      final headers = _authService?.getAuthHeader();
      final res = await http.delete(
        "$BASE_URL/api/profile",
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
      await _authService.logout();
      _profile = null;
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
      };
      _isLoading = false;
      rethrow;
    }
    notifyListeners();
  }
}
