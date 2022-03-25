import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import 'network_response.dart';
import 'network_route.dart';

class ApiProvider {
  ApiProvider() : _dio = Dio();

  final Dio _dio;

  Future<NetworkResponse> request(NetworkRoute route) async {
    Response response;
    try {
      switch (route.method) {
        case HttpMethod.post:
          _dio.options.headers = route.headers();
          response = await _dio.post(
            route.url(),
            queryParameters: {},
            data: route.parameters(),
          );
          break;

        case HttpMethod.get:
          _dio.options.headers = route.headers();
          response = await _dio.get(
            route.url(),
            queryParameters: route.parameters(),
          );
          break;
      }
    } on DioError catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final data = e.response?.data.toString() ?? "";
      log(route.url() + ": " + statusCode.toString());
      log("errorResponse>" + data);
      return NetworkResponse(statusCode, false, "error_http_request");
    }

    if (response == null) {
      log(route.url() + "  error_http_method>");
      return NetworkResponse(0, false, "error_http_method");
    }

    final statusCode = response.statusCode ?? 0;
    bool soccess = false;
    String error = "";
    if (statusCode == 200) soccess = true;

    NetworkResponse networkResponse =
        NetworkResponse(statusCode, soccess, error);

    if (response.data is String) {
      networkResponse.dataString = response.data;
      try {
        Map<String, dynamic> decodedJSON = json.decode(response.data);
        networkResponse.data = decodedJSON;
      } on FormatException catch (e) {
        log('url>' + route.url());
        log('The provided string is not valid JSON');
      }
    }

    if (response.data is Map<String, dynamic>) {
      networkResponse.data = response.data;
    } else {
      networkResponse.data["data"] = response.data;
    }

    return networkResponse;
  }
}
