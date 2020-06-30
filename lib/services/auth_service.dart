import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_dev_connector/config/config.dart';
import 'package:flutter_dev_connector/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  User _user;
  bool _isLoading = false;
  Map _error;
  Timer _authTimer;

  User get user => _user;
  bool get isLoading => _isLoading;
  Map get error => _error;

  bool get isAuth {
    //print('isAuth: ${token != null}');
    return token != null;
  }

  bool get hasError {
    return error != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Future<void> _authenticate(String email, String password,
      [String name]) async {
    http.Response res;
    try {
      _isLoading = true;
      if (name != null) {
        // Register
        res = await http.post(
          "$BASE_URL/api/users",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': name,
            'email': email,
            'password': password,
          }),
        );
      } else {
        // Login
        res = await http.post(
          "$BASE_URL/api/auth",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
          }),
        );
      }

      if (res.statusCode == 200) {
        _token = jsonDecode(res.body)['token'];
        await loadUser();
        notifyListeners();

        if (_token != null) {
          final claims = _parseJwt(_token);
          _expiryDate =
              DateTime.fromMillisecondsSinceEpoch(claims['exp'] * 1000);
          _autoLogout();

          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              'token': _token,
              'user': jsonEncode(_user.toJson()),
              'expiryDate': _expiryDate.toIso8601String(),
            },
          );
          prefs.setString('userData', userData);
          print('authenticate: saved $userData');

          return;
        }
      } else {
        _error = jsonDecode(res.body);
      }
    } catch (err) {
      _error = {
        'msg': err.toString(),
        // 'msg': err.response.statusText,
        // 'status': err.response.status,
      };
    }

    // Failed - cleanup
    logout();
  }

  Future<void> register(String name, String email, String password) async {
    return _authenticate(email, password, name);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Map<String, String> getAuthHeader() {
    return {
      'x-auth-token': _token,
    };
  }

  Future<void> loadUser() async {
    try {
      _isLoading = true;
      final res = await http.get(
        "$BASE_URL/api/auth",
        headers: getAuthHeader(),
      );
      if (res.statusCode == 200) {
        _user = User.fromJson(jsonDecode(res.body));
      } else {
        _user = null;
        _error = jsonDecode(res.body);
      }
      _isLoading = false;
    } catch (err) {
      _error = {
        'msg': err.toString(),
        // 'msg': err.response.statusText,
        // 'status': err.response.status,
      };
      _token = null;
      _user = null;
      _isLoading = false;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //print(prefs);
    if (!prefs.containsKey('userData')) return false;

    //print('tryAutoLogin: read ${prefs.getString('userData')}');
    final userData = json.decode(prefs.getString('userData'));
    //print('tryAutoLogin: decoded $userData');
    final expiryDate = DateTime.parse(userData['expiryDate']);
    //print('tryAutoLogin: $expiryDate');
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = userData['token'];
    _user = User.fromJson(jsonDecode(userData['user']));
    _expiryDate = expiryDate;
    _error = null;

    //print('auto login!');
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _expiryDate = null;
    _error = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      prefs.remove('userData');
      //print('logout: removed userData');
    }

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpiry), // 10 for debugging auto-logout
      logout,
    );
  }
}
