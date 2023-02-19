import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/links.dart';
import '../models/employee.dart';
import 'base_repository.dart';
import 'error_logger_repository.dart';

class EmployeeRepository implements BaseRepository<Employee> {
  final ErrorLoggerRepository errorLogger;
  final String repoName = 'EmployeeRepo';

  EmployeeRepository({required this.errorLogger});

  @override
  Future<Map<String, dynamic>> findAll(int logUserId, String token,
      {int page = 0}) async {
/*    Map<String, String> data = {
      'logUserId': logUserId.toString(),
      'token': token
    };*/
    Map<String, dynamic> result = {};
    /*  String message = "";

    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.findAllEmployees,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      // print(result);
    } catch (error) {
      debugPrint("Error findAll(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: "findAll", className: repoName);
      message = error.toString();
      result['message'] = message;
    }*/
    return result;
  }

  Future<Map<String, dynamic>> findAllFiltered(
      {required int idCenter,
      required int idPart,
      required String search,
      required int logUserId,
      required String token,
      int page = 0}) async {
    Map<String, String> data = {
      'logUserId': logUserId.toString(),
      'token': token,
      'idCenter': idCenter.toString(),
      'idPart': idPart.toString(),
      'search': search,
    };
    Map<String, dynamic> result = {};
    String message = "";

    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.findAllEmployeesFiltered,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      // print(result);
    } catch (error) {
      debugPrint("Error findAllFiltered(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: "findAllFiltered", className: repoName);
      message = error.toString();
      result['message'] = message;
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> findById({
    required int entityId,
    required int logUserId,
    required String token,
  }) async {
    String message = '';
    Map<String, dynamic> result = {};
    Map<String, dynamic> data = {
      'entityId': entityId,
      'logUserId': logUserId,
      'token': token,
    };
//----------------------------
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.findByIdEmployee,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body); //has message and list
    } catch (error) {
      debugPrint("Error findById(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: "findById", className: repoName);
      message = error.toString();
      result['message'] = message;
    }
//----------------------------
    return result;
  }

  ///    result is a string message of server
  @override
  Future<String> update(
      {required Employee entity,
      required int logUserId,
      required String token}) async {
    String message = '';

    Map<String, dynamic> result = {};
    Map<String, dynamic> data = {
      'logUserId': entity.id,
      'token': token,
    };
    data.addAll(entity.toJson());
//----------------------------
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.updateEmployee,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      message = result['message'];
    } catch (error) {
      debugPrint("Error part update(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: "update", className: repoName);
      message = error.toString();
    }
//----------------------------
//     result is a string message of server
    return message;
  }

  /// result is a string message of server
  @override
  Future<String> add({
    required Employee entity,
    required int logUserId,
    required String token,
  }) async {
    String message = '';

    Map<String, dynamic> result = {};
    Map<String, dynamic> data = {
      'logUserId': logUserId,
      'token': token, //log user's token
    };
    data.addAll(entity.toJson());

//----------------------------
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.addEmployee,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      message = result['message'];
    } catch (error) {
      debugPrint("Error add(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: "add", className: repoName);
      message = error.toString();
    }
//----------------------------
//     result is a string message of server
    return message;
  }
}
