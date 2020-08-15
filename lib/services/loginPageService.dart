
import 'dart:convert';

import 'package:task_scape/resources/wsAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../resources/wsAPI.dart';

final storage = new FlutterSecureStorage();

class LoginPageService{

  static final LoginPageService instance = LoginPageService._();

  LoginPageService._();


  Future<void> saveLastEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastEmail', email);
  }

  Future<String> readLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final lastEmail = prefs.getString('lastEmail') ?? '';
    return lastEmail;
  }

  Future<List> attemptLogIn(String username, String password) async {
    var res = await WsAPI().login(username, password);
    return res;
  }

  Future<String> attemptRegister(
      String username, String password, String name, String lastname, int contact) async {
    var res = await WsAPI().register(name, lastname, username, password, contact);
    if (res == '200') return "";
    return res;
  }

  Future<String> forgotPassword(String email) async{
    String res = await WsAPI().forgotPassword(email);
    return res;
  }

  Future<String> authUser(Login data) async {
    var jwt = await attemptLogIn(data.name, data.password);
    if (jwt[0] == 200) {
      await storage.write(key: "token", value: jsonDecode(jwt[1])['token']);
    }
    {
      if (jwt[0] != 200) {
        return jwt[0].toString();
      } else {
        saveLastEmail(data.name);
        readLastEmail().then((onValue) {
          print("email recebido do shared prefs" + onValue);
        });
        return null;
      }
    }
  }

  Future<Map<String, dynamic>> getLoggedUser()async{
    var response = await WsAPI().loggedUser();

    return response;
  }

}