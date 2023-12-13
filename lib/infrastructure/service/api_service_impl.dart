import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../service/api_service.dart';

class ApiServiceImpl implements ApiService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: dotenv.env['API_URL']!));

  static final ApiServiceImpl _instance = ApiServiceImpl._internal();

  factory ApiServiceImpl() {
    return _instance;
  }

  ApiServiceImpl._internal() {
    _dio.options.connectTimeout = const Duration(hours: 1);
    _dio.options.receiveTimeout = const Duration(hours: 1);

    _dio.options.headers["Content-Type"] = "application/json";

    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) => handler.next(options),
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) => handler.resolve(_handleError(error))));
  }

  Response _handleError(DioException error) {
    String errorMessage = "Une erreur est survenue";
    int? errorCode = error.response?.statusCode;

    print(error.response?.data);

    try {
      if (error.response?.data is Map<String, dynamic>) {
        var responseData = error.response?.data as Map<String, dynamic>;
        if (responseData.containsKey('detail')) {
          errorMessage = responseData['detail'];
        }
      }
    } catch (e) {
      print("Erreur lors de l'analyse du message d'erreur : $e");
    }

    return Response(
      requestOptions: error.requestOptions,
      data: {
        "message": errorMessage,
        "statusCode": errorCode,
      },
      statusCode: errorCode,
    );
  }

  @override
  setAuthorizationHeader(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  @override
  removeAuthorizationHeader() {
    _dio.options.headers.remove("Authorization");
  }

  // Méthodes ajustées pour gérer JSON, FormData, et fichiers
  @override
  Future<Response> post(String path, {dynamic data}) async {
    return _sendRequest(() => _dio.post(path, data: data));
  }

  @override
  Future<Response> put(String path, {dynamic data}) async {
    return _sendRequest(() => _dio.put(path, data: data));
  }

  @override
  Future<Response> get(String path) async {
    return _sendRequest(() => _dio.get(path));
  }

  @override
  Future<Response> delete(String path) async {
    return _sendRequest(() => _dio.delete(path));
  }

  Future<Response> _sendRequest(Future<Response> Function() requestMethod) async {
    try {
      var response = await requestMethod();
      return response;
    } on DioException catch (error) {
      return _handleError(error);
    }
  }
}
