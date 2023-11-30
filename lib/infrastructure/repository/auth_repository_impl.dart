import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/user.dart';
import '../../repository/auth_repository.dart';
import '../../service/api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  User? _user;

  AuthRepositoryImpl(this._apiService) {
    setup();
  }

  void setup() async {
    var token = await _secureStorage.read(key: "jwt_token");
    if (token != null) {
      _apiService.setAuthorizationHeader(token);
    }
  }

  @override
  Future<User?> logIn({required String email, required String password}) async {
    try {
      final response = await _apiService.post("/auth/login", data: {
        "email": email,
        "password": password,
      });

      var token = response.data["token"];
      _apiService.setAuthorizationHeader(token);
      _secureStorage.write(key: "jwt_token", value: token);
      print("response.data: ${response.data}");

      return User.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<User?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post("/auth/register", data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      });

      var token = response.data["token"];
      _apiService.setAuthorizationHeader(token);
      _secureStorage.write(key: "jwt_token", value: token);

      return User.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<void> logOut() async {
    try {
      _apiService.removeAuthorizationHeader();
      await _secureStorage.delete(key: "jwt_token");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_user != null) return Future.value(_user);
    try {
      var response = await _apiService.get("/account/profile");
      return User.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      var response = await _apiService.put("/account/profile", data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      });
      _user = User.fromJson(response.data);
      return response.statusCode == 200;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
