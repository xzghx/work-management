import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/links.dart';

  enum MyLevel {
  userMessage,
  app
}

class ErrorLoggerRepository {
  Future<void> logError({
    required String error,
    required String method,
    required String className,
    MyLevel? level =   MyLevel.app ,
  }) async {
    //TODO Log errors to file
    Map<String, dynamic> data = {
      'error': error,
      'method': method,
      'className': className,
      'level': level.toString(),
    };
    http.post(
      Uri.http(Links.baseUrl, Links.logErrors),
      headers: Links.headers,
      body: jsonEncode(data),
    );
  }
}
