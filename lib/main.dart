import 'package:bkn_sertifikasi/provider/cashflowdetail_provider.dart';
import 'package:bkn_sertifikasi/provider/expenses_provider.dart';
import 'package:bkn_sertifikasi/provider/home_provider.dart';
import 'package:bkn_sertifikasi/provider/income_provider.dart';
import 'package:bkn_sertifikasi/provider/login_provider.dart';
import 'package:bkn_sertifikasi/screen/detail/cashflowdetail_screen.dart';
import 'package:bkn_sertifikasi/screen/expenses/expenses_screen.dart';
import 'package:bkn_sertifikasi/screen/home/home_screen.dart';
import 'package:bkn_sertifikasi/screen/income/income_screen.dart';
import 'package:bkn_sertifikasi/screen/login/login_screen.dart';
import 'package:bkn_sertifikasi/util/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseHandler dbHandler = DatabaseHandler();

  @override
  initState() {
    initDb();
    super.initState();
  }

  void initDb() async {
    await dbHandler.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider(dbHelper: dbHandler)),
        ChangeNotifierProvider(create: (_) => IncomeProvider(dbHelper: dbHandler)),
        ChangeNotifierProvider(create: (_) => HomeProvider(dbHelper: dbHandler)),
        ChangeNotifierProvider(create: (_) => ExpensesProvider(dbHelper: dbHandler)),
        ChangeNotifierProvider(create: (_) => CashflowDetailProvider(dbHelper: dbHandler)),
      ],
      child: MaterialApp(
        title: 'MyCashApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          IncomeScreen.routeName: (context) => const IncomeScreen(),
          ExpensesScreen.routeName: (context) => const ExpensesScreen(),
          DetailCashflowScreen.routeName: (context) => const DetailCashflowScreen(),
        },
      ),
    );
  }
}
