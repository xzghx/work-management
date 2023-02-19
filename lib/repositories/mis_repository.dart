import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/links.dart';
import 'error_logger_repository.dart';

class MisRepo {
  final ErrorLoggerRepository errorLogger;
  final String repoName = 'MisRepo';

  MisRepo({required this.errorLogger});

  Future<Map<String, dynamic>> getMonths(
      {required int logUserId, required String token}) async {
    Map<String, String> data = {
      'logUserId': logUserId.toString(),
      'token': token,
    };
    Map<String, dynamic> result = {};
    String message = "";

    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.getMonths,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      // print(result);
    } catch (error) {
      debugPrint("Error getMonths(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: "getMonths", className: repoName);
      message = error.toString();
      result['message'] = message;
    }
    return result;
  }

  Future<Map<String, dynamic>> getTimeTypes(
      {required int logUserId, required String token}) async {
    Map<String, String> data = {
      'logUserId': logUserId.toString(),
      'token': token,
    };

    Map<String, dynamic> result = await httpMapReturn(
        link: Links.findAllTimeTypes, methodName: 'getTimeTypes', data: data);
    return result;
  }

  Future<Map<String, dynamic>> httpMapReturn(
      {required Map<String, dynamic> data,
      required String link,
      required String methodName}) async {
    Map<String, dynamic> result = {};
    String message = "";
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          link,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      // print(result);
    } catch (error) {
      debugPrint("Error $methodName: ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: methodName, className: repoName);
      message = error.toString();
      result['message'] = message;
    }
    return result;
  }

  Future<String> httpStringReturn(
      {required Map<String, dynamic> data,
      required String link,
      required String methodName}) async {
    String message = '';
    Map<String, dynamic> result = {};

//----------------------------
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          link,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      message = result['message'];
    } catch (error) {
      debugPrint("Error $methodName: ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: methodName, className: repoName);
      message = error.toString();
    }
//----------------------------
//     result is a string message of server
    return message;
  }
}
