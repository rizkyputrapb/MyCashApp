import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/model/transaction_model.dart';
import 'package:bkn_sertifikasi/util/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeProvider with ChangeNotifier {
  late DatabaseHandler dbHelper;

  IncomeProvider({required this.dbHelper});

  DateTime _selectedDate = DateTime.now();
  int _inputtedNominal = 0;
  TextEditingController dateController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Cashflow? _cashflow;
  ResultState? _state;
  String? _message;

  ResultState? get state => _state;

  Cashflow? get user => _cashflow;

  String? get message => _message;

  set selectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  set inputtedNominal(int number) {
    print(number);
    _inputtedNominal = number;
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;

  int get inputtedNominal => _inputtedNominal;

  Future<dynamic> insertCashflow() async {
    _state = ResultState.Loading;
    notifyListeners();
    try {
      final cashflow = await dbHelper.insertTrans(Cashflow(
        date: DateFormat('dd-MM-yyyy').format(_selectedDate),
        nominal: _inputtedNominal,
        type: "income",
        description: descriptionController.text,
        timestamp: _selectedDate.millisecondsSinceEpoch
      ));
      if (cashflow != null) {
        _state = ResultState.HasData;
        notifyListeners();
        return cashflow;
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
}
