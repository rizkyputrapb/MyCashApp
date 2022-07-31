import 'dart:convert';

import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/util/db_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class LoginProvider with ChangeNotifier {
  late DatabaseHandler dbHelper;

  LoginProvider({required this.dbHelper});

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? _user;
  ResultState? _state;
  String? _message;

  ResultState? get state => _state;

  User? get user => _user;

  String? get message => _message;

  Future<dynamic> fetchUser() async {
    try {
      final user = await dbHelper.retrieveUser();
      print(user?.toMap().toString());
      if (user != null) {
        _user = user;
        notifyListeners();
        return user;
      } else {
        return _message = "Error fetching user";
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      _state = ResultState.Error;
      notifyListeners();
      return _message = "Error fetching user";
    }
  }

  void login() {
    _state = ResultState.Loading;
    if (usernameController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      final username = usernameController.text;
      final password = md5.convert(utf8.encode(passwordController.text)).toString();
      if (_user != null) {
        print(_user?.toMap().toString());
        if (_user!.username == username && _user!.password == password) {
          print("user logged in");
          _state = ResultState.HasData;
          notifyListeners();
        } else {
          _state = ResultState.Error;
          _message = "Invalid credentials registered in the system";
          notifyListeners();
        }
      }
    } else {
      _state = ResultState.Error;
      _message = "Fill all of the required forms!";
    }
    notifyListeners();
  }
}
