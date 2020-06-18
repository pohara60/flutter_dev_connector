import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/config/config.dart';
import 'package:flutter_dev_connector/models/profile.dart';
import 'package:http/http.dart' as http;

class ProfileService with ChangeNotifier {
  Profile _profile;
  List<Profile> _profiles;
  List<String> _repos;
  bool _isLoading;
  Map _error;

  List<Profile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  Map get error => _error;

  Future<Profile> getCurrentProfile() async {
    try {
      _isLoading = true;
      final res = await http.get("$BASE_URL/api/profile/me");
      if (res.statusCode == 200) {
        _profile = Profile.fromJson(jsonDecode(res.body));
      } else {
        _error = jsonDecode(res.body);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.response.statusText,
        'status': err.response.status,
      };
      _isLoading = false;
    }
    notifyListeners();
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
      _isLoading = false;
    }
    notifyListeners();
    return profiles;
  }
}
