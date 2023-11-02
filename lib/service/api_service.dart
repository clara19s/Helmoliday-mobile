import 'dart:async';

import 'package:dio/dio.dart';

abstract class ApiService {
  void setAuthorizationHeader(String token);

  void removeAuthorizationHeader();

  Future<Response> get(String path);

  Future<Response> post(String s, {required Map<String, dynamic> data});

  Future<Response> put(String s, {required Map<String, dynamic> data});

  Future<Response> delete(String path);
}

class ApiError {
  final String message;
  final int? statusCode;

  ApiError({required this.message, required this.statusCode});
}
