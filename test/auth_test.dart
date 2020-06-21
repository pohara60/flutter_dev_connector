import 'package:flutter_dev_connector/services/auth_service.dart';
import 'package:test/test.dart';

void main() {
  final authService = AuthService();
  test('login', () async {
    await authService.login('test@test.com', 'testtest');
    expect(authService.token, isNotNull);
  });
}
