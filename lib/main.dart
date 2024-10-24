import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helmoliday/infrastructure/repository/auth_repository_impl.dart';
import 'package:helmoliday/infrastructure/service/api_service_impl.dart';
import 'package:helmoliday/infrastructure/service/location_service_impl.dart';
import 'package:helmoliday/repository/activity_repository.dart';
import 'package:helmoliday/repository/auth_repository.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:helmoliday/service/api_service.dart';
import 'package:helmoliday/service/location_service.dart';
import 'package:helmoliday/service/navigation_service.dart';
import 'package:helmoliday/service/toast_service.dart';
import 'package:helmoliday/theme.dart';
import 'package:provider/provider.dart';

import 'infrastructure/repository/activity_repository_impl.dart';
import 'infrastructure/repository/holiday_repository_impl.dart';
import 'infrastructure/service/fluttertoast_service.dart';

future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
 
  final NavigationService navigationService = NavigationService();
  final apiService = ApiServiceImpl();
  final authRepository = AuthRepositoryImpl(apiService);
  final holidayRepository = HolidayRepositoryImpl(apiService);
  final toastService = FluttertoastService();
  final theme = HelmolidayTheme.light();
  

  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => apiService,
        ),
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


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
