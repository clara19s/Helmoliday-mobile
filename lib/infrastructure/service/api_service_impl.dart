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
    int? errorCode;

    print(error.response?.data);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = "Temps d'attente dépassé";
        break;
      case DioExceptionType.badResponse:
        errorMessage = "Échec lors de l'appel à l'API";
        errorCode = error.response?.statusCode;
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Certificat invalide";
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.cancel:
        errorMessage = "Erreur de connexion";
        break;
      case DioExceptionType.unknown:
        errorMessage = "Une erreur inattendue s'est produite";
        break;
    }

    return Response(
      requestOptions: error.requestOptions,
      statusCode: errorCode,
      data: ApiError(message: errorMessage, statusCode: errorCode),
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
