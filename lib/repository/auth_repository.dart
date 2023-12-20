import '../model/user.dart';

abstract class AuthRepository {
  Future<User?> logIn({required String email, required String password});

  Future<User?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<User?> getCurrentUser();

  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  });

  Future<bool> deleteUser();
}
