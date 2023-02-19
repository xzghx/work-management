import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/links.dart';
import '../models/admin_users.dart';
import '../models/my_response.dart';
import 'base_repository.dart';
import 'error_logger_repository.dart';

///is for add edit admins
class AdminRepository implements BaseRepository<AdminUser> {
  final ErrorLoggerRepository errorLogger;

  AdminRepository({required this.errorLogger});

  ///returns a map{result: , error: }
  ///
  ///result:MAp {  result:[{a user},{a user},{a user}]  , message:'' , status:int }
  ///
  ///if message is empty, no error

  @override
  Future<Map<String, dynamic>> findAll(int logUserId, String token,
      {int page = 0}) async {
    Map<String, String> data = {
      'logUserId': logUserId.toString(),
      'token': token
    };
    Map<String, dynamic> result = {};

    String message = "";

    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.getAllAdmins,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      // print(result);
    } catch (error) {
      debugPrint("Error findAll(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(),
          method: "findAll",
          className: "AdminRepository");
      message = error.toString();
      result['message'] = message;
    }

    return result;
  }

  ///if message is empty, no error
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
          Links.getUser,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
    } catch (error) {
      debugPrint("Error findById(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(),
          method: "findById",
          className: "AdminRepository");
      message = error.toString();
      result['message'] = message;
    }
//----------------------------
    return result;
  }

  ///returns map
  ///
  /// {
  ///   status: int
  ///   message: ""
  ///   result:[{},{},{}]
  /// }
  Future<MyResponse> getAccessTypes(int logUserId, String token) async {
    Map<String, dynamic> data = {'logUserId': logUserId, 'token': token};
    Map<String, dynamic> result = {};
    int status = -100;
    String message = "";

    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.getAccessTypes,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      message = result['message'];
      status = result['status'];
    } catch (error) {
      debugPrint("Error getAccessTypes(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(),
          method: "getAccessTypes",
          className: "AdminRepository");
      message = error.toString();
    }
    MyResponse res = MyResponse(status, message, result);
    return res;
  }

  ///    result is a string message of server
  @override
  Future<String> update(
      {required AdminUser entity,
      required int logUserId,
      required String token}) async {
    String message = 'خالی';
    // int status = 0;
    Map<String, dynamic> result = {};
    Map<String, dynamic> data = {
      'logUserId': logUserId,
      'token': token,
    };
    data.addAll(entity.toJson());
//----------------------------
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.updateUser,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      // status = result['status'];
      message = result['message'];
    } catch (error) {
      debugPrint("Error update(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(),
          method: "update",
          className: "AdminRepository");
      message = error.toString();
      // status = -3;
    }
//----------------------------
//     result is a string message of server

    return message;
  }

  /// result is a string message of server
  @override
  Future<String> add({
    required AdminUser entity,
    required int logUserId,
    required String token,
  }) async {
    String message = 'خالی';
    // int status = 0;
    Map<String, dynamic> result = {};
    Map<String, dynamic> data = {
      'logUserId': logUserId, //l
      'token': token, // og user's token
    };
    data.addAll(entity.toJson());
//----------------------------
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.addUser,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      result = json.decode(response.body);
      // status = result['status'];
      message = result['message'];
    } catch (error) {
      debugPrint("Error add(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(), method: "add", className: "AdminRepository");
      message = error.toString();
      // status = -3;
    }
//----------------------------
//     result is a string message of server
    return message;
  }
}
