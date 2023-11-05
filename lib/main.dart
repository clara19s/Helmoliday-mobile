import 'package:flutter/material.dart';
import 'package:helmoliday/infrastructure/repository/auth_repository_impl.dart';
import 'package:helmoliday/infrastructure/service/api_service_impl.dart';
import 'package:helmoliday/infrastructure/service/location_service_impl.dart';
import 'package:helmoliday/repository/auth_repository.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:helmoliday/service/location_service.dart';
import 'package:helmoliday/service/navigation_service.dart';
import 'package:helmoliday/theme.dart';
import 'package:provider/provider.dart';

import 'infrastructure/repository/holiday_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final NavigationService navigationService = NavigationService();
  final apiService = ApiServiceImpl();
  final authRepository = AuthRepositoryImpl(apiService);
  final holidayRepository = HolidayRepositoryImpl(apiService);
  final theme = HelmolidayTheme.light();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => authRepository,
        ),
        Provider<HolidayRepository>(
          create: (_) => holidayRepository,
        ),
        Provider<LocationService>(
          create: (_) => LocationServiceImpl(),
        ),
      ],
      child: MaterialApp.router(
        title: 'HELMoliday',
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: navigationService.router,
      ),
    ),
  );
}
