import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/Configurations/config.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  static const storage = FlutterSecureStorage();
  bool _refreshing = false;
  final List<Function> _retryQueue = [];

  TokenInterceptor(this.dio);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await storage.read(key: "tokenKey");
    if (token != null) {
      options.headers['x-access-token'] = token;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && err.response?.data['message'] == 'jwt expired') {
      RequestOptions options = err.response!.requestOptions;

      if (_refreshing) {
        _retryQueue.add(() async {
          String? newToken = await storage.read(key: "tokenKey");
          if (newToken != null) {
            options.headers['x-access-token'] = newToken;
          }
          final response = await dio.request(
            options.path,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );
          handler.resolve(response);
        });
        return;
      }

      _refreshing = true;

      try {
        await _refreshToken();
        _refreshing = false;
        String? newToken = await storage.read(key: "tokenKey");
        if (newToken != null) {
          options.headers['x-access-token'] = newToken;
        }
        final response = await dio.request(
          options.path,
          options: Options(
            method: options.method,
            headers: options.headers,
          ),
          data: options.data,
          queryParameters: options.queryParameters,
        );
        handler.resolve(response);

        for (var callback in _retryQueue) {
          await callback();
        }
        _retryQueue.clear();
      } catch (e) {
        _refreshing = false;
        handler.reject(DioException(requestOptions: options, error: e));
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refreshToken() async {
    print("Refresh token");
    String? accessToken = await storage.read(key: "tokenKey");
    String? refreshToken = await storage.read(key: "refreshToken");
    final response = await dio.post(
        Config.refreshToken,
        data: {"accessToken": accessToken, "refreshToken": refreshToken},
    );
    print("response = $response");
    var newToken = response.data['accessToken'];
    var newRefreshToken = response.data['refreshToken'];
    await storage.write(key: "tokenKey", value: newToken);
    await storage.write(key: "refreshToken", value: newRefreshToken);
  }
}