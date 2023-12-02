import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  late BuildContext _context;

  bool get isLoading => _isLoading;
  late final AuthRepository _authRepository;
  late final Logger _logger;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RegisterViewModel(BuildContext context) {
    _context = context;
    _authRepository = context.read<AuthRepository>();
    _logger = context.read<Logger>();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      _logger.info('Tentative d\'inscription avec $email');
      final user = await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      if (user != null && _context.mounted) {
        _context.go('/home');
      }
      else {
        _errorMessage = 'Erreur lors de l\'inscription. Veuillez réessayer.';
      }
    } catch (e) {
      _logger.severe('Erreur lors de l\'inscription', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
