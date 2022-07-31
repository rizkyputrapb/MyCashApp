import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/model/transaction_model.dart';
import 'package:bkn_sertifikasi/util/db_helper.dart';
import 'package:flutter/material.dart';

class CashflowDetailProvider with ChangeNotifier {
  late DatabaseHandler dbHelper;

  CashflowDetailProvider({required this.dbHelper});

  List<Cashflow?>? _cashflowList;
  ResultState? _state = ResultState.Loading;
  String? _message;

  ResultState? get state => _state;

  List<Cashflow?>? get cashflowList => _cashflowList;

  String? get message => _message;

  Future<dynamic> getCashflowList() async {
    try {
      var results = await dbHelper.getCashflowList();
      if (results!.isNotEmpty) {
        _state = ResultState.HasData;
        notifyListeners();
        return _cashflowList = results;
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
