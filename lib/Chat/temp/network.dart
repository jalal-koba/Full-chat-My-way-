import 'dart:io';

import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

class Network {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(headers: {
      'Authorization': "Bearer 52896|YZOgnxUHtshtcV4WlpqyrFXYuTETbb89aG8RJh7Q",
      'Content-Type': 'application/json',
      "Accept": 'application/json',
      "Accept-Charset": "application/json"
    }));

    dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        request: true,
        compact: true,
        maxWidth: 1000));

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return client;
    };
  }

  static Future<Response> getData({
    required String url,
  }) async {
    final response = await dio.get(
      url,
    );
    return response;
  }

  static Future<Response> postData(
      {required String url,
      dynamic data,
      void Function(int, int)? onSendProgress}) async {
    return await dio.post(
      url,
      data: data,
      onSendProgress: onSendProgress,
    );
  }
}
