import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationResult {
  final AuthenticationStatus status;
  final User? user;

  AuthenticationResult({required this.status, this.user});
}

const BASE_URL = 'https://10.0.2.2:44305';

class AuthenticationRepository {
  User? _user = null;
  final _controller = StreamController<AuthenticationResult>();

  Stream<AuthenticationResult> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationResult(status: AuthenticationStatus.unauthenticated);
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$BASE_URL/auth/login');
    var response = await http.post(url, headers: {
      'Content-Type': 'application/json'
    }, body: jsonEncode(<String, String>{
      'email': email,
      'password': password
    }));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      _user = User.fromJson(json);
      _controller.add(AuthenticationResult(
          status: AuthenticationStatus.authenticated, user: _user));
    } else {
      throw Exception("Login failed");
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$BASE_URL/auth/register');
    var response = await http.post(url, headers: {
      'Content-Type': 'application/json'
    }, body: jsonEncode(<String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password
    }));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      _user = User.fromJson(json);
      _controller.add(AuthenticationResult(
          status: AuthenticationStatus.authenticated, user: _user));
    } else {
      throw Exception('Failed to register');
    }
  }

  void logOut() {
    _controller.add(
        AuthenticationResult(status: AuthenticationStatus.unauthenticated));
  }

  User? getUser() {
    return _user;
  }

  void dispose() => _controller.close();
}

class User extends Equatable {
  const User(this.id, this.firstName, this.lastName, this.email, this.token);

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['firstName'],
      json['lastName'],
      json['email'],
      json['token'],
    );
  }

  @override
  List<Object> get props => [id];
}
