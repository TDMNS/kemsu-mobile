import 'package:dio/dio.dart';
import 'token_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio.interceptors.add(TokenInterceptor(dio));
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> delete<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.delete<T>(path, queryParameters: queryParameters, options: options);
  }
}
