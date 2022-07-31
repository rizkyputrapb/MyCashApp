import 'package:another_flushbar/flushbar.dart';
import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/provider/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  static const routeName = "/expense";

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late ExpensesProvider provider;
  String locale = 'id';

  @override
  void initState() {
    initializeDateFormatting();
    provider = Provider.of<ExpensesProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _formatNumber(String s) => NumberFormat.decimalPattern(locale).format(int.parse(s));
    String _currency = NumberFormat.compactSimpleCurrency(locale: locale).currencySymbol;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: provider.dateController,
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: provider.selectedDate, // Refer step 1
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    provider.selectedDate = picked;
                    provider.dateController.text = DateFormat('dd-MM-yyyy').format(picked);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Tanggal",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: provider.nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Nominal",
                  prefixText: "${_currency}. ",
                ),
                onChanged: (string) {
                  string = '${_formatNumber(string.replaceAll('.', ''))}';
                  provider.nominalController.value = TextEditingValue(
                    text: string,
                    selection: TextSelection.collapsed(offset: string.length),
                  );
                  provider.inputtedNominal = int.parse(string.replaceAll('.', ''));
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: provider.descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Keterangan",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    provider.insertCashflow().then((value) {
                      switch (provider.state) {
                        case ResultState.Loading:
                          {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            break;
                          }
                        case ResultState.Error:
                          {
                            Flushbar(
                              title: "Error Adding Expense",
                              message: provider.message,
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red.withOpacity(0.7),
                              flushbarPosition: FlushbarPosition.TOP,
                            ).show(context);
                            break;
                          }
                        case ResultState.HasData:
                          {
                            Flushbar(
                              title: "Success!",
                              message: "Pengeluaran telah diregister kedalam sistem",
                              duration: const Duration(seconds: 3),
                              flushbarPosition: FlushbarPosition.TOP,
                            ).show(context);
                            break;
                          }
                      }
                    });
                  },
                  child: const Text("Simpan"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
