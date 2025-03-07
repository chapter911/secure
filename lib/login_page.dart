import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/helper/prefs.dart';
import 'package:secure/page/dashboard.dart';
import 'package:secure/page/register_page.dart';
import 'package:secure/style/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isLoading = true;
  String _fbToken = "";

  @override
  void initState() {
    super.initState();
    getToken();
    Future.delayed(Duration(seconds: 2), () {
      if (Prefs.checkData('username') == true) {
        Get.offAll(() => DashboardPage());
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void getToken() async {
    _fbToken = (await FirebaseMessaging.instance.getToken())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/app_logo.png'),
                SizedBox(height: 20),
                Text("SECURE", style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                _isLoading
                    ? const LinearProgressIndicator()
                    : Column(
                      children: [
                        TextField(
                          controller: _username,
                          decoration: dekorasiInput(
                            hint: 'Username',
                            icon: Icons.person,
                          ),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: dekorasiInput(
                            hint: 'Password',
                            icon: Icons.lock,
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            Api.postData(context, "users/login", {
                              "username": _username.text,
                              "password": _password.text,
                              "fb_token": _fbToken,
                            }).then((val) {
                              Get.snackbar(
                                val!.status!,
                                val.message!,
                                colorText: Colors.white,
                                backgroundColor:
                                    val.status == "success"
                                        ? Colors.green[900]
                                        : Colors.red[900],
                              );
                              if (val.status == "success") {
                                Prefs().saveString('username', _username.text);
                                Get.offAll(() => DashboardPage());
                              }
                            });
                          },
                          child: const Text('Login'),
                        ),
                        SizedBox(height: 30),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const RegisterPage());
                          },
                          child: const Text('register'),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
