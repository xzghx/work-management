import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shifter/UI/container/pages/profile/view/bloc/profile_cubit.dart';

import '../helpers/links.dart';
import '../models/admin_users.dart';
import 'error_logger_repository.dart';

///is for login and logouts
class UserRepository {
  final ErrorLoggerRepository errorLogger;

  final String repoName = 'UserRepository';

  UserRepository({required this.errorLogger});

  ///returns a map{user: , message: }
  ///user: would be a User or User.empty
  ///message: an informational text
  Future<Map<String, dynamic>> logIn(String userName, String password) async {
    AdminUser user = AdminUser.empty;
    String message = 'متاسفانه خطایی رخ داده.لطفا بعدا تلاش کنید. ';

    Map<String, String> data = {'userName': userName, 'password': password};

    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.login,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      Map<String, dynamic> result = json.decode(response.body);

// String token= result['user']['token'];
//       print('UESR TOKEN: ${token}');
//       token=token.replaceAll("\n", '');
//       print('AGFTER UESR TOKEN: ${token}');

      //.replaceAll(RegExp(r'\s+',multiLine: true), '')
      // here
      user = result['user'] != null
          ? AdminUser.fromJson(result['user'])
          : AdminUser.empty;

      // print('TOKEN: ${user.token}');

      message = result['message'] ?? '';
      // debugPrint('User name: ${user.name}');
    } catch (error) {
      debugPrint("Error login(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(),
          method: "login",
          className: "UserRepository");
      message += error.toString();
    }
    return {'user': user, 'message': message};
  }

  Future<String> logOut({required int userId, required String token}) async {
    Map<String, dynamic> data = {'userId': userId, 'token': token};
    String message = '';
    try {
      http.Response response = await http.post(
        Uri.http(
          Links.baseUrl,
          Links.logOut,
        ),
        headers: Links.headers,
        body: json.encode(data),
      );

      Map<String, dynamic> result = json.decode(response.body);
      message = result['message'] ?? '';
    } catch (error) {
      debugPrint("Error logOut(): ${error.toString()}");
      errorLogger.logError(
          error: error.toString(),
          method: "logOut",
          className: "UserRepository");
      message += error.toString();
    }
    return message;
  }

  Future<String> updateProfile(ProfileUser entity, String token) async {
    String message = '';
    Map<String, dynamic> data = {
      'token': token,
    };
    data.addAll(entity.toJson());

    message = await httpStringReturn(
        data: data, link: Links.updateProfile, methodName: 'updateProfile');
//----------------------------
//     result is a string message of server
    return message;
  }

  Future<String> updatePassword(
      {required int id,
      required String userName,
      required String mobile,
      required String newPassword,
      required String token,}) async {
    String message = '';
    Map<String, dynamic> data = {
      'id':id,
      'userName':userName,
      'mobile':mobile,
      'password':newPassword,
      'token':token,
    };

    message = await httpStringReturn(
        data: data, link: Links.updatePassword, methodName: 'updatePassword');
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
