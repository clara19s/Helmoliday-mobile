import 'package:go_router/go_router.dart';
import 'package:helmoliday/view/holiday/holidays_screen.dart';

import '../view/auth/login_screen.dart';
import '../view/auth/register_screen.dart';
import '../view/auth_gate.dart';
import '../view/holiday/add_holiday_screen.dart';
import '../view/holiday/holiday_detail_screen.dart';
import '../view/splash_screen.dart';

class NavigationService {
  static NavigationService? _instance;

  NavigationService._internal();

  factory NavigationService() {
    _instance ??= NavigationService._internal();
    return _instance!;
  }

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
          path: '/holidays',
          builder: (context, state) => const HolidayScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddHolidayScreen(),
            ),
            GoRoute(
              path: 'details/:id',
              builder: (context, state) =>
                  HolidayDetailScreen(id: state.pathParameters['id']!),
            ),
          ]),
    ],
  );
}
