import 'dart:convert';
import 'dart:io';

import 'package:aipis_calendar/constants/urls.dart';
import 'package:http/http.dart' as http;

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenTTL;
  final DateTime refreshTokenTTL;

  const AuthTokens(
      {required this.accessToken,
      required this.accessTokenTTL,
      required this.refreshToken,
      required this.refreshTokenTTL});

  AuthTokens.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'] as String,
        refreshToken = json['refreshToken'] as String,
        accessTokenTTL = DateTime.parse(json['accessTokenTTL'] as String),
        refreshTokenTTL = DateTime.parse(json['refreshTokenTTL'] as String);
}

class NotLoggedInException implements Exception {
  String? cause;

  NotLoggedInException({this.cause});
}

class AuthController {
  static final AuthController the = AuthController._();

  AuthController._() {
    // TODO: восстановить токен из локального хранилища и проверить его
    validateToken();
  }

  factory AuthController() => the;

  AuthTokens? _tokens;

  Future<void> login(String email, String password) async {
    var response = await http.post(Uri.parse(urlApiAuthSignIn),
        body: jsonEncode({"email": email, "password": password}),
        headers: const {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _tokens = AuthTokens.fromJson(json);
    } else if (response.statusCode == HttpStatus.badRequest) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw RangeError('Invalid email or password: ${json['message']}');
    } else {
      throw Exception('Unknown error: ${response.statusCode}');
    }
  }

  bool isLoggedIn() {
    validateToken();

    return _tokens != null;
  }

  void assertLoggedIn() {
    if (!isLoggedIn()) {
      throw NotLoggedInException();
    }
  }

  void validateToken() {
    if (_tokens == null) {
      return;
    }

    // Обнуляем токены, если они уже дохлые
    if (DateTime.now().isAfter(_tokens!.accessTokenTTL)) {
      _tokens = null;
    }
  }

  String? getAccessToken() {
    validateToken();

    return _tokens?.accessToken;
  }
}
