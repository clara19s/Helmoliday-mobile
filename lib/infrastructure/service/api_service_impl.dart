import 'dart:async';

import 'package:dio/dio.dart';

import '../../service/api_service.dart';

class ApiServiceImpl implements ApiService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: "https://porthos-intra.cg.helmo.be/Q210266"));

  static final ApiServiceImpl _instance = ApiServiceImpl._internal();

  factory ApiServiceImpl() {
    return _instance;
  }

  ApiServiceImpl._internal() {
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

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

  @override
  Future<Response> post(String s, {required Map<String, dynamic> data}) async {
    var response = await _dio.post(s, data: data);
    if (response.statusCode == 200) {
      return response;
    }
    return response;
  }

  @override
  Future<Response> get(String s) async {
    var response = await _dio.get(s);
    return response;
  }

  @override
  Future<Response> put(String s, {required Map<String, dynamic> data}) async {
    var response = await _dio.put(s, data: data);
    return response;
  }

  @override
  Future<Response> delete(String s) => _dio.delete(s);
}
