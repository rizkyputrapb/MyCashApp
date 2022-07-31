import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/provider/cashflowdetail_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailCashflowScreen extends StatefulWidget {
  const DetailCashflowScreen({Key? key}) : super(key: key);

  static const routeName = "/detail";

  @override
  State<DetailCashflowScreen> createState() => _DetailCashflowScreenState();
}

class _DetailCashflowScreenState extends State<DetailCashflowScreen> {
  String locale = 'id';

  @override
  Widget build(BuildContext context) {
    String _formatNumber(String s) => NumberFormat.decimalPattern(locale).format(int.parse(s));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Cashflow"),
      ),
      body: SafeArea(
        child: Consumer<CashflowDetailProvider>(
          builder: (build, provider, _) {
            provider.getCashflowList();
            switch (provider.state) {
              case ResultState.Loading:
                {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              case ResultState.HasData:
                {
                  var cashflowList = provider.cashflowList;
                  return ListView.builder(
                    itemBuilder: (build, idx) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 1,
                                color: cashflowList![idx]!.type == 'income' ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rp. ${_formatNumber(cashflowList[idx]!.nominal.toString())}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: cashflowList[idx]!.type == 'income' ? Colors.green : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      cashflowList[idx]?.description ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      cashflowList[idx]?.date ?? "",
                                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                                cashflowList[idx]!.type == 'income'
                                    ? const Icon(
                                        Icons.arrow_upward,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.arrow_downward,
                                        color: Colors.red,
                                      )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: cashflowList?.length ?? 0,
                  );
                }
              case ResultState.NoData:
                {
                  return const Center(
                    child: Text("No Data"),
                  );
                }
              case ResultState.Error:
                {
                  return Center(
                    child: Text("Error -> ${provider.message}"),
                  );
                }
              default:
                {
                  return Container();
                }
            }
          },
        ),
      ),
    );
  }
}
