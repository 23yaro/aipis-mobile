import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aipis_calendar/constants/settings.dart';
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

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'accessTokenTTL': accessTokenTTL.toIso8601String(),
        'refreshTokenTTL': refreshTokenTTL.toIso8601String()
      };
}

class NotLoggedInException implements Exception {
  String? cause;

  NotLoggedInException({this.cause});
}

class UserAlreadyExistsException implements Exception {
  UserAlreadyExistsException();
}

class AuthController {
  static final AuthController the = AuthController._();

  AuthController._() {
    final String? tokens = preferences.getString("tokens");
    if (tokens != null) {
      _tokens = AuthTokens.fromJson(jsonDecode(tokens));
    }
  }

  factory AuthController() => the;

  AuthTokens? _tokens;

  Future<void> signUp(String email, String password) async {
    var response = await http.post(Uri.parse(urlApiAuthSignUp),
        body: jsonEncode({"email": email, "password": password}),
        headers: const {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == HttpStatus.created) {
      return;
    }

    if (response.statusCode == HttpStatus.conflict) {
      throw UserAlreadyExistsException();
    }

    if (response.statusCode == HttpStatus.badRequest) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw RangeError('Invalid email or password: ${json['message']}');
    }
    throw Exception('Unknown error: ${response.statusCode}');
  }

  Future<void> signIn(String email, String password) async {
    var response = await http.post(Uri.parse(urlApiAuthSignIn),
        body: jsonEncode({"email": email, "password": password}),
        headers: const {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      setTokens(AuthTokens.fromJson(json));
    } else if (response.statusCode == HttpStatus.badRequest) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw RangeError('Invalid email or password: ${json['message']}');
    } else {
      throw Exception('Unknown error: ${response.statusCode}');
    }
  }

  void setTokens(AuthTokens tokens) {
    _tokens = tokens;
    preferences.setString("tokens", jsonEncode(tokens.toJson()));
  }

  bool isLoggedIn() {
    validateToken();

    return _tokens != null;
  }

  void assertLoggedIn() async {
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
