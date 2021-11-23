import 'dart:collection';
import 'dart:convert';

import 'package:frontend_flutter/models/login_request.dart';
import 'package:frontend_flutter/models/login_response.dart';
import 'package:frontend_flutter/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const API = 'https://backend-dam-p2.herokuapp.com/api/auth';
  static const headers = {
    'Content-Type': 'application/json',
  };
  static var cliente = http.Client();
  static Future<bool> login(LoginRequest model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonReponse, data;
    var response = await cliente.post(Uri.parse(API),
        headers: headers, body: jsonEncode(model.toJson()));
    if (response.statusCode == 200) {
      jsonReponse = json.decode(response.body);
      data = parseJwt(jsonReponse['accessToken']);
      if (jsonReponse != null) {
        sharedPreferences.setString('token', jsonReponse['accessToken']);
        sharedPreferences.setString('user', json.encode(data['usuario']));
        print(json.encode(data['usuario']));
      }
      return true;
    } else {
      return false;
    }
  }

  static logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = 'empty';
    userModel.username = 'empty';
    await sharedPreferences.clear();
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static User userModel =
      User(idusuario: 0, idrol: 0, username: 'empty', nomrol: '');
  static String _token = 'empty';

  static Future<User> currentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (userModel.username != 'empty') {
      return userModel;
    } else if (userModel.username == 'empty' &&
        sharedPreferences.getString('user') != null) {
      var userJson = sharedPreferences.getString('user');
      var _json = User.fromJson(json.decode(userJson!));
      userModel = _json;
      return userModel;
    }
    return userModel;
  }

  static Future<String> currentToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_token != 'empty') {
      return _token;
    } else if (_token == 'empty' &&
        sharedPreferences.getString('token') != null) {
      var tkn = sharedPreferences.getString('token');
      _token = tkn!;
      return _token;
    }
    return _token;
  }

 

}
