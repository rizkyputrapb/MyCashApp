import 'package:auto_size_text/auto_size_text.dart';
import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/model/cashflow_data.dart';
import 'package:bkn_sertifikasi/provider/home_provider.dart';
import 'package:bkn_sertifikasi/screen/detail/cashflowdetail_screen.dart';
import 'package:bkn_sertifikasi/screen/expenses/expenses_screen.dart';
import 'package:bkn_sertifikasi/screen/income/income_screen.dart';
import 'package:bkn_sertifikasi/screen/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CashflowData> incomeSpots = <CashflowData>[];
  List<CashflowData> expenseSpots = <CashflowData>[];

  @override
  Widget build(BuildContext context) {
    String _formatNumber(String? s) {
      s ??= "0";
      return NumberFormat.decimalPattern('id').format(int.parse(s));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("MyCashBook"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Consumer<HomeProvider>(
                builder: (build, provider, _) {
                  provider.getSumIncome();
                  provider.getSumExpense();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Rangkuman Bulan Ini",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Pemasukan: Rp. ${_formatNumber(provider.incomeSum.toString())}",
                        style: const TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      Text(
                        "Pengeluaran: Rp. ${_formatNumber(provider.expenseSum.toString())}",
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<HomeProvider>(
                  builder: (build, provider, _) {
                    provider.getIncomeList().then((value) {
                      if (provider.state == ResultState.HasData) {
                        incomeSpots = provider.incomeList!.map((e) {
                          return CashflowData(
                              date: DateTime(
                                DateTime.fromMillisecondsSinceEpoch(e!.timestamp).year,
                                DateTime.fromMillisecondsSinceEpoch(e.timestamp).month,
                                DateTime.fromMillisecondsSinceEpoch(e.timestamp).day,
                              ),
                              nominal: e.nominal);
                        }).toList();
                      }
                    });
                    provider.getExpenseList().then((value) {
                      if (provider.state == ResultState.HasData) {
                        expenseSpots = provider.expenseList!.map((e) {
                          return CashflowData(
                              date: DateTime(
                                DateTime.fromMillisecondsSinceEpoch(e!.timestamp).year,
                                DateTime.fromMillisecondsSinceEpoch(e.timestamp).month,
                                DateTime.fromMillisecondsSinceEpoch(e.timestamp).day,
                              ),
                              nominal: e.nominal);
                        }).toList();
                      }
                    });
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          intervalType: DateTimeIntervalType.days,
                          interval: 1,
                          axisLine: const AxisLine(width: 1),
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          numberFormat: NumberFormat.compactSimpleCurrency(locale: 'id'),
                          axisLine: const AxisLine(width: 1),
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        series: <SplineSeries<CashflowData, DateTime>>[
                          SplineSeries<CashflowData, DateTime>(
                              color: Colors.green,
                              dataSource: incomeSpots,
                              xValueMapper: (CashflowData cashflow, _) => cashflow.date,
                              yValueMapper: (CashflowData cashflow, _) => cashflow.nominal),
                          SplineSeries<CashflowData, DateTime>(
                              color: Colors.red,
                              dataSource: expenseSpots,
                              xValueMapper: (CashflowData cashflow, _) => cashflow.date,
                              yValueMapper: (CashflowData cashflow, _) => cashflow.nominal)
                        ],
                        plotAreaBorderColor: Colors.transparent,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuButton(
                      context,
                      "Tambah Pemasukan",
                      "assets/img/img_income.webp",
                      () {
                        Navigator.pushNamed(context, IncomeScreen.routeName);
                      },
                    ),
                    _buildMenuButton(
                      context,
                      "Tambah Pengeluaran",
                      "assets/img/img_expense.webp",
                      () {
                        Navigator.pushNamed(context, ExpensesScreen.routeName);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuButton(
                      context,
                      "Detail Cashflow",
                      "assets/img/img_detail.webp",
                      () {
                        Navigator.pushNamed(context, DetailCashflowScreen.routeName);
                      },
                    ),
                    _buildMenuButton(
                      context,
                      "Pengaturan",
                      "assets/img/img_settings.webp",
                      () {
                        Navigator.pushNamed(context, SettingsScreen.routeName);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildMenuButton(
    BuildContext context,
    String label,
    String imgButton,
    Function() onClick,
  ) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: MediaQuery.of(context).size.height / 4.5,
        width: MediaQuery.of(context).size.width / 2.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(spreadRadius: 1, blurRadius: 10, blurStyle: BlurStyle.outer, color: Colors.grey.withOpacity(0.7)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 4,
                  right: 16,
                  bottom: 4,
                ),
                child: Image.asset(
                  imgButton,
                ),
              ),
              AutoSizeText(
                label,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                maxLines: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
