import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ListClientePage extends StatefulWidget {
  const ListClientePage({Key? key}) : super(key: key);

  @override
  State<ListClientePage> createState() => _ListClientePageState();
}

class _ListClientePageState extends State<ListClientePage> {
  var clientes = [];
  final storage = const FlutterSecureStorage();

  void getCliente() async {
    final token = await storage.read(key: 'token');
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/cliente/"),
        headers: {'Authorization': 'Token ' + token.toString()});
    List responseMap = jsonDecode(response.body);

    setState(() {
      for (var el in responseMap) {
        clientes.add({
          'id': el['id'].toString(),
          'nome': el['nome'].toString(),
        });
      }
    });
  }

  void deleteCliente(String id) async {
     final token = await storage.read(key: 'token');
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/cliente/"),
        headers: {'Authorization': 'Token ' + token.toString()});
    List responseMap = jsonDecode(response.body);

    setState(() {
      for (var el in responseMap) {
        clientes.add({
          'id': el['id'].toString(),
          'nome': el['nome'].toString(),
        });
      }
    });
  }

  void initState() {
    super.initState();
    getCliente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, position) {
                // ignore: prefer_const_constructors
                return Card(
                    elevation: 10,
                    shadowColor: Colors.blue,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              clientes[position]['nome'].toString(),
                              style: TextStyle(fontSize: 22),
                            ),
                            InkWell(
                              onTap: ()=> deleteCliente( clientes[position]['id'].toString()),
                              
                                child: Icon(Icons.delete,
                                    size: 24.0, color: Colors.red))
                          ],
                        )));
              }),
        ));
  }
}
