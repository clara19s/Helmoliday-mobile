import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  String _firstName = '';

  String get firstName => _firstName;

  String _lastName = '';

  String get lastName => _lastName;

  String _email = '';

  String get email => _email;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  late final AuthRepository _authRepository;
  late final BuildContext _context;

  ProfileViewModel(BuildContext context) {
    _context = context;
    _authRepository = context.read<AuthRepository>();
    _isLoading = true;
    init();
  }

  init() async {
    var user = await _authRepository.getCurrentUser();
    if (user != null) {
      _firstName = user.firstName;
      _lastName = user.lastName;
      _email = user.email;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    var result = false;
    _isLoading = true;
    try {
      final changeResult = await _authRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      result = changeResult;
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> logOut() async {
    await _authRepository.logOut();
    if (_context.mounted) {
      _context.go('/login');
    }
  }
}
