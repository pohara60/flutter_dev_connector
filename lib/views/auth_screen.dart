import 'package:flutter/material.dart';
import 'package:flutter_dev_connector/locator.dart';
import 'package:flutter_dev_connector/routing/routing_constants.dart';
import 'package:flutter_dev_connector/services/alert_service.dart';
import 'package:flutter_dev_connector/models/alert.dart';
import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:flutter_dev_connector/services/navigation_service.dart';
import 'package:flutter_dev_connector/utils/logger.dart';
import 'package:flutter_dev_connector/widgets/alert_widget.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  final bool isSignup;
  AuthScreen([this.isSignup = false]);

  final log = getLogger('AuthScreen');

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final deviceSize = mediaQueryData.size;
    final bottomInset = mediaQueryData.viewInsets.bottom;
    log.v('build called');

    return AuthContainer(
      deviceSize: deviceSize,
      bottomInset: bottomInset,
      isSignup: isSignup,
    );
  }
}

class AuthContainer extends StatelessWidget {
  const AuthContainer({
    Key key,
    @required this.deviceSize,
    @required this.bottomInset,
    @required this.isSignup,
  }) : super(key: key);

  final Size deviceSize;
  final double bottomInset;
  final bool isSignup;

  @override
  Widget build(BuildContext context) {
    double topInset = 80; // Navigation Bar height
    return SingleChildScrollView(
      child: Container(
        height: deviceSize.height - topInset,
        padding: EdgeInsets.only(bottom: bottomInset),
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertWidget(),
            Center(
              child: AuthCard(isSignup),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  final bool isSignup;
  AuthCard([this.isSignup = false]);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _authMode = widget.isSignup ? AuthMode.Signup : AuthMode.Login;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    locator<NavigationService>().goBack();
                  },
                )
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await authService.login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await authService.register(
          _authData['name'],
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed - ${error.toString()}';
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Authentication failed - ${error.toString()}';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });

    if (authService.token != null) {
      locator<NavigationService>().navigateReplace(DashboardViewRoute);
    } else {
      final alertService = Provider.of<AlertService>(context, listen: false);
      if (authService.hasError) {
        for (var msg in authService.errorMsgs) {
          alertService.addAlert(msg, AlertType.Danger);
        }
      } else {
        alertService.addAlert(
            _authMode == AuthMode.Login ? 'Login failed!' : 'Signup failed!',
            AlertType.Danger);
      }
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final deviceSize = mediaQueryData.size;
    final bottomInset = mediaQueryData.viewInsets.bottom;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: bottomInset + 16,
        ),
        height: _authMode == AuthMode.Signup ? 380 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 380 : 260),
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value.isEmpty) {
                              return 'Invalid name!';
                            }
                            return null;
                          }
                        : null,
                    onSaved: (value) {
                      _authData['name'] = value;
                    },
                  ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
