import 'package:bkn_sertifikasi/model/transaction_model.dart';
import 'package:bkn_sertifikasi/util/db_helper.dart';
import 'package:flutter/material.dart';

import '../constants/resultstate_constant.dart';

class HomeProvider with ChangeNotifier {
  late DatabaseHandler dbHelper;

  HomeProvider({required this.dbHelper});

  List<Cashflow?>? _incomeList;
  List<Cashflow?>? _expenseList;
  int _incomeSum = 0;
  int _expenseSum = 0;
  ResultState? _state;
  String? _message;

  ResultState? get state => _state;

  List<Cashflow?>? get incomeList => _incomeList;

  List<Cashflow?>? get expenseList => _expenseList;

  int get incomeSum => _incomeSum;

  int get expenseSum => _expenseSum;

  String? get message => _message;

  Future<dynamic> getSumIncome() async {
    try {
      int? results = await dbHelper.getSumIncome();
      if (results != null || results != "null") {
        _state = ResultState.HasData;
        notifyListeners();
        return _incomeSum = results ?? 0;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      _state = ResultState.Error;
      notifyListeners();
    }
  }

  Future<dynamic> getSumExpense() async {
    try {
      int? results = await dbHelper.getSumExpense();
      if (results != null || results != "null") {
        _state = ResultState.HasData;
        notifyListeners();
        return _expenseSum = results ?? 0;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      _state = ResultState.Error;
      notifyListeners();
    }
  }

  Future<dynamic> getIncomeList() async {
    try {
      var results = await dbHelper.getIncomeList();
      if (results != null) {
        if (results.isNotEmpty) {
          _state = ResultState.HasData;
          notifyListeners();
          return _incomeList = results;
        } else {
          _state = ResultState.NoData;
          notifyListeners();
        }
      } else {
        _state = ResultState.NoData;
        notifyListeners();
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      _state = ResultState.Error;
      notifyListeners();
    }
  }

  Future<dynamic> getExpenseList() async {
    try {
      var results = await dbHelper.getExpenseList();
      if (results!.isNotEmpty) {
        _state = ResultState.HasData;
        notifyListeners();
        return _expenseList = results;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      _state = ResultState.Error;
      notifyListeners();
    }
  }
}
