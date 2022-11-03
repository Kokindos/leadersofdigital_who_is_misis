import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/data/api/api_routes/api_routes.dart';
import 'package:frontend/data/interceptors/error_interceptor.dart';

class Api {
  late Dio _client;

  Api() {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://89.108.102.188:5000',
      connectTimeout: 10000,
    ));
    dio.interceptors.add(ErrorInterceptor());
    _client = dio;
  }

  Future<String> getPolygons() async {
    final response = await _client.get(ApiRoutes.getPolygons);
    final json = jsonDecode(response.data);
    return json;
  }
}
