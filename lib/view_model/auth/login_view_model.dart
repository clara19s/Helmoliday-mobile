import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  late BuildContext _context;
  late final AuthRepository _authRepository;

  LoginViewModel(BuildContext context) {
    _context = context;
    _authRepository = context.read<AuthRepository>();
  }

  Future<void> logIn({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authRepository.logIn(
        email: email,
        password: password,
      );
      if (user != null && _context.mounted) {
        _context.go('/home');
      }
    } catch (e) {
      // TODO: définir un message d'erreur que la vue devra afficher
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
