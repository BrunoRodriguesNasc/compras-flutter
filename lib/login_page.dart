import 'dart:convert';
import 'package:commerce/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey();
  final storage = new FlutterSecureStorage();
  bool _validate = false;
  String username = '', password = '', token = '';

  void sendForm() async {
    if (_formKey.currentState!.validate()) {
      print('chegou');
      try {
        final response = await http
            .post(Uri.parse("http://10.0.2.2:8000/api/token/"), body: {
          'username': username,
          'password': password,
        });
        final responseMap = jsonDecode(response.body);

        await storage.write(key: 'token', value: responseMap['token']);

        if (responseMap['token'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          const snackBar = SnackBar(
            content: Text('Email ou senha inválidos'),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ABA - COMÉRCIO"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 40,
                      onSaved: (String? value) {
                        username = value.toString();
                      },
                      decoration:
                          const InputDecoration(hintText: 'Digite seu usuário'),
                    ),
                    TextFormField(
                      maxLength: 40,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      onSaved: (String? value) {
                        password = value.toString();
                      },
                      decoration:
                          const InputDecoration(hintText: 'Digite sua senha'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            {_formKey.currentState?.save(), sendForm()},
                        child: const Text('Entrar'),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
