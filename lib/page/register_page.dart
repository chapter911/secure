import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secure/helper/api.dart';
import 'package:secure/login_page.dart';
import 'package:secure/style/style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _konfirmasi = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _username,
                decoration: dekorasiInput(hint: 'Username', icon: Icons.person),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: dekorasiInput(hint: 'Password', icon: Icons.lock),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _konfirmasi,
                obscureText: true,
                decoration: dekorasiInput(hint: 'Konfirmasi', icon: Icons.lock),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _nama,
                decoration: dekorasiInput(hint: 'Nama', icon: Icons.person),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: dekorasiInput(hint: 'Phone', icon: Icons.phone),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _email,
                decoration: dekorasiInput(hint: 'Email', icon: Icons.mail),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  if (_username.text.isEmpty ||
                      _password.text.isEmpty ||
                      _konfirmasi.text.isEmpty ||
                      _nama.text.isEmpty ||
                      _phone.text.isEmpty ||
                      !_email.text.isEmail) {
                    Get.snackbar(
                      'Peringatan',
                      'Semua data harus diisi',
                      colorText: Colors.white,
                      backgroundColor: Colors.red[900],
                    );
                  } else if (_password.text != _konfirmasi.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password dan Konfirmasi harus sama'),
                      ),
                    );
                  } else {
                    Api.postData(context, "users/register", {
                      "username": _username.text,
                      "password": _password.text,
                      "nama": _nama.text,
                      "phone": _phone.text,
                      "email": _email.text,
                    }).then((val) {
                      Get.snackbar(
                        val!.status!,
                        val.message!,
                        colorText: Colors.white,
                        backgroundColor: Colors.red[900],
                      );
                      if (val.status == "success") {
                        Get.offAll(() => const LoginPage());
                      }
                    });
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
