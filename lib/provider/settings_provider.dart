import 'dart:convert';

import 'package:bkn_sertifikasi/model/user_model.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../constants/resultstate_constant.dart';
import '../util/db_helper.dart';

class SettingsProvider with ChangeNotifier {
  late DatabaseHandler dbHelper;

  SettingsProvider({required this.dbHelper});

  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  ResultState? _state;
  String? _message;

  ResultState? get state => _state;

  String? get message => _message;

  Future<dynamic> changePassword() async {
    try {
      final user = await dbHelper.retrieveUser();
      if (user != null) {
        print(user.password);
        print(md5.convert(utf8.encode(currentPassController.text)).toString());
        if (user.password == md5.convert(utf8.encode(currentPassController.text)).toString()) {
          final result =
              await dbHelper.updateUser(User(id: 1, username: "user", password: md5.convert(utf8.encode(newPassController.text)).toString()));
          if (result != null) {
            _state = ResultState.HasData;
            notifyListeners();
            return result;
          } else {
            _state = ResultState.Error;
            notifyListeners();
            return _message = "Error dalam mengganti password";
          }
        } else {
          _state = ResultState.Error;
          notifyListeners();
          return _message = "Password salah";
        }
      } else {
        _state = ResultState.Error;
        notifyListeners();
        return _message = "Error dalam mengganti password";
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      _state = ResultState.Error;
      notifyListeners();
      return _message = "Error dalam mengganti password";
    }
  }
}
