import 'package:another_flushbar/flushbar.dart';
import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isHideCurrentPass = true;
  bool isHideNewPass = true;
  late SettingsProvider provider;

  @override
  void initState() {
    provider = Provider.of<SettingsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "Ganti Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextFormField(
                      controller: provider.currentPassController,
                      obscureText: isHideCurrentPass,
                      decoration: InputDecoration(
                          labelText: "Password Saat Ini",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isHideCurrentPass = !isHideCurrentPass;
                                });
                              },
                              icon: isHideCurrentPass == true ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextFormField(
                      controller: provider.newPassController,
                      obscureText: isHideNewPass,
                      decoration: InputDecoration(
                          labelText: "Password Baru",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isHideNewPass = !isHideNewPass;
                                });
                              },
                              icon: isHideNewPass == true ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        provider.changePassword().then((value) {
                          if (provider.state == ResultState.HasData) {
                            Flushbar(
                              title: "Success!",
                              message: "Password telah diganti",
                              duration: const Duration(seconds: 3),
                            ).show(context);
                          } else {
                            Flushbar(
                              title: "Error",
                              message: provider.message,
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red.withOpacity(0.5),
                            ).show(context);
                          }
                        });
                      },
                      child: const Text("Ganti Password"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
