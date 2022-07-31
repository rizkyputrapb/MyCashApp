import 'package:another_flushbar/flushbar.dart';
import 'package:bkn_sertifikasi/constants/resultstate_constant.dart';
import 'package:bkn_sertifikasi/provider/login_provider.dart';
import 'package:bkn_sertifikasi/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginProvider provider;

  @override
  void initState() {
    provider = Provider.of<LoginProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider.fetchUser();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/img_cashflow.webp',
                  height: MediaQuery.of(context).size.height / 4,
                  fit: BoxFit.fill,
                ),
                const Text(
                  "MyCashBook v1.0",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: provider.usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: provider.passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF00A3FF)),
                  ),
                  onPressed: () {
                    provider.login();
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
                            title: "Error Logging In",
                            message: provider.message,
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.red.withOpacity(0.7),
                            flushbarPosition: FlushbarPosition.TOP,
                          ).show(context);
                          break;
                        }
                      case ResultState.HasData:
                        {
                          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                          break;
                        }
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
