import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  late BuildContext _context;

  bool get isLoading => _isLoading;
  late final AuthRepository _authRepository;

  RegisterViewModel(BuildContext context) {
    _context = context;
    _authRepository = context.read<AuthRepository>();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    try {
      final user = await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      if (user != null && _context.mounted) {
        _context.go('/home');
      }
    } catch (e) {
      // TODO: Transmettre un message d'erreur à la vue
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
