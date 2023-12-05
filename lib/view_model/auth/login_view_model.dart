import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  late BuildContext _context;
  late final AuthRepository _authRepository;
  late final Logger _logger;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  LoginViewModel(BuildContext context) {
    _context = context;
    _authRepository = context.read<AuthRepository>();
    _logger = context.read<Logger>();
  }

  Future<void> logIn({required String email, required String password}) async {

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _logger.info('Tentative de connexion avec $email');
      final user = await _authRepository.logIn(
        email: email,
        password: password,
      );
      if (user != null && _context.mounted) {
        _context.go('/home');
      }
    } catch (e) {
      _errorMessage = 'Erreur lors de la connexion. Veuillez réessayer.';
      _logger.severe('Erreur lors de la connexion', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
