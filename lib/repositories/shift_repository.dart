import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shifter/models/month_shift.dart';

import '../helpers/links.dart';
import '../models/shift.dart';
import 'base_repository.dart';
import 'error_logger_repository.dart';

///is for add edit admins
class ShiftRepository implements BaseRepository<Shift> {
  final ErrorLoggerRepository errorLogger;
  final String repoName = 'ShiftRepository';

  ShiftRepository({required this.errorLogger});

  ///returns a MyResponse
  ///contains:
  ///status: = 0 is ok so meesage is empty
  ///message
  ///map :map{result: [{},{},...], message:""empty or error message }
  @override
  Future<Map<String, dynamic>> findAll(int logUserId, String token,
      {int page = 0}) async {
    Map<String, String> data = {
      'logUserId': logUserId.toString(),
      'token': token
    };
    Map<String, dynamic> result = {};
    result = await httpMapReturn(
      data: data,
      link: Links.findAllShifts,
      methodName: 'findAll',
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>> findById({
    required int entityId,
    required int logUserId,
    required String token,
  }) async {
    Map<String, dynamic> result = {};
    Map<String, dynamic> data = {
      'entityId': entityId,
      'logUserId': logUserId,
      'token': token,
    };

    result = await httpMapReturn(
      data: data,
      link: Links.findByIdShift,
      methodName: 'findById',
    );
    return result;
  }

  ///    result is a string message of server
  @override
  Future<String> update(
      {required Shift entity,
      required int logUserId,
      required String token}) async {
    String message = '';
    Map<String, dynamic> data = {
      'logUserId': logUserId,
      'token': token,
    };
    data.addAll(entity.toJson());

    message = await httpStringReturn(
        data: data, link: Links.updateShift, methodName: 'update');
//----------------------------
//     result is a string message of server
    return message;
  }

  /// result is a string message of server
  @override
  Future<String> add({
    required Shift entity,
    required int logUserId,
    required String token,
  }) async {
    String message = '';

    Map<String, dynamic> data = {
      'logUserId': logUserId,
      'token': token, //log user's token
    };
    data.addAll(entity.toJson());
    message = await httpStringReturn(
        data: data, link: Links.addShift, methodName: 'add');
//----------------------------
//     result is a string message of server
    return message;
  }

  Future<Map<String, dynamic>> getCenterEmployeesMonthShift({
    required int idCenter,
    required int idPart,
    required int page,
    required int year,
    required int idMonth,
    String searchValue = '',
    required int logUserId,
    required String token,
  }) async {
    Map<String, String> data = {
      'idCenter': idCenter.toString(),
      'idPart': idPart.toString(),
      'page': page.toString(),
      'year': year.toString(),
      'month': idMonth.toString(),
      'searchValue': searchValue,
      'logUserId': logUserId.toString(),
      'token': token
    };
    Map<String, dynamic> result = {};
    result = await httpMapReturn(
      data: data,
      link: Links.getCenterEmployeesMonthShift,
      methodName: 'getCenterEmployeesMonthShift',
    );
    return result;
  }



Future<String>  setOrUpdateEmployeeShift({
    required MonthShift entity,
    required int idCenter,
    required int idPart,
    required int year,
    required int idMonth,
    required int logUserId,
    required String token,
  }) async {
    String message = '';
    Map<String, dynamic> data = {
      'idCenter': idCenter,
      'idPart': idPart,
      'year': year,
      'idMonth': idMonth,
      'logUserId': logUserId,
      'token': token,
    };
    data.addAll(entity.toJson());

    message = await httpStringReturn(
        data: data,
        link: Links.setOrUpdateEmployeeShift,
        methodName: 'setOrUpdateEmployeeShift');
//----------------------------
//     result is a string message of server
    return message;
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
