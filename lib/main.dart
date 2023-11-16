import 'package:flutter/material.dart';
import 'package:helmoliday/infrastructure/repository/auth_repository_impl.dart';
import 'package:helmoliday/infrastructure/service/api_service_impl.dart';
import 'package:helmoliday/infrastructure/service/location_service_impl.dart';
import 'package:helmoliday/repository/activity_repository.dart';
import 'package:helmoliday/repository/auth_repository.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:helmoliday/service/location_service.dart';
import 'package:helmoliday/service/navigation_service.dart';
import 'package:helmoliday/service/toast_service.dart';
import 'package:helmoliday/theme.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'infrastructure/repository/activity_repository_impl.dart';
import 'infrastructure/repository/holiday_repository_impl.dart';
import 'infrastructure/service/fluttertoast_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final NavigationService navigationService = NavigationService();
  final apiService = ApiServiceImpl();
  final authRepository = AuthRepositoryImpl(apiService);
  final holidayRepository = HolidayRepositoryImpl(apiService);
  final toastService = FluttertoastService();
  final theme = HelmolidayTheme.light();

  runApp(
    MultiProvider(
      providers: [
        Provider<IToastService>(
          create: (_) => toastService,
        ),
        Provider<AuthRepository>(
          create: (_) => authRepository,
        ),
        Provider<HolidayRepository>(
          create: (_) => holidayRepository,
        ),
        Provider<LocationService>(
          create: (_) => LocationServiceImpl(),
        ),
        Provider<ActivityRepository>(
          create: (_) => ActivityRepositoryImp(apiService),
        ),
        Provider<Logger>(
          create: (_) => Logger('HELMoliday'),
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
