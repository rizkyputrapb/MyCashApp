import 'dart:convert';

import 'package:bkn_sertifikasi/model/transaction_model.dart';
import 'package:bkn_sertifikasi/model/user_model.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Database? db;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'mycashapp.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL, password TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE cashflow(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, nominal INT NOT NULL, description TEXT, type TEXT NOT NULL, timestamp LONGINT NOT NULL)",
        );
        await database.insert('user', User(username: "user", password: md5.convert(utf8.encode("user")).toString()).toMap());
      },
      version: 1,
    );
    return db!;
  }

  Future<int?> updateUser(User user) async {
    int id = 1;
    if (db != null) {
      int result = 0;
      result = await db!.update(
        'user',
        user.toMap(),
        where: "id = ?",
        whereArgs: [id]
      );
      return result;
    } else {
      return null;
    }
  }

  Future<int?> insertTrans(Cashflow cashflow) async {
    if (db != null) {
      int? result;
      result = await db!.insert('cashflow', cashflow.toMap());
      return result;
    } else {
      return null;
    }
  }

  Future<User?> retrieveUser() async {
    if (db != null) {
      final List<Map<String, Object?>> queryResult = await db!.query('user');
      return queryResult.map((e) => User.fromMap(e)).toList()[0];
    } else {
      return null;
    }
  }

  Future<List<Cashflow>?> getIncomeList() async {
    if (db != null) {
      final List<Map<String, Object?>> queryResult = await db!.query(
        'cashflow',
        where: "type = 'income'",
        orderBy: "timestamp ASC",
      );
      return queryResult.map((e) => Cashflow.fromMap(e)).toList();
    } else {
      return null;
    }
  }

  Future<List<Cashflow>?> getExpenseList() async {
    if (db != null) {
      final List<Map<String, Object?>> queryResult = await db!.query(
        'cashflow',
        where: "type = 'expense'",
        orderBy: "timestamp ASC",
      );
      return queryResult.map((e) => Cashflow.fromMap(e)).toList();
    } else {
      return null;
    }
  }

  Future<List<Cashflow>?> getCashflowList() async {
    if (db != null) {
      final List<Map<String, Object?>> queryResult = await db!.query(
        'cashflow',
        orderBy: "timestamp DESC",
      );
      return queryResult.map((e) => Cashflow.fromMap(e)).toList();
    } else {
      return null;
    }
  }

  Future getSumIncome() async {
    if (db != null) {
      var result = await db!.rawQuery(" SELECT SUM(nominal) as sum FROM cashflow where type = 'income'");
      return result[0]['sum'];
    } else {
      return null;
    }
  }

  Future getSumExpense() async {
    if (db != null) {
      var result = await db!.rawQuery(" SELECT SUM(nominal) as sum FROM cashflow where type = 'expense'");
      return result[0]['sum'];
    } else {
      return null;
    }
  }
}
