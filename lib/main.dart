import 'dart:io';

import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // TODO: me supprimer
  runApp(const App());
}

// TODO: me supprimer
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
