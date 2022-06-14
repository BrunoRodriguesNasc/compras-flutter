import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProdutoPage extends StatefulWidget {
  final String idProduto;
  ProdutoPage({Key? key, required this.idProduto}) : super(key: key);
  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  final storage = const FlutterSecureStorage();
  var produto = [];
  var idCliente = '';
  var cliente = [];
  void getProduto() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
          Uri.parse("http://10.0.2.2:8000/produto/"),
          headers: {'Authorization': 'Token ' + token.toString()});

      List responseMap = jsonDecode(response.body);
      setState(() {
        for (var el in responseMap) {
          if (el['id'].toString() == widget.idProduto) {
            produto.add({
              'id': el['id'].toString(),
              'nome': el['nome'].toString(),
              'preco': el['preco'].toString()
            });
            idCliente = el['cliente_proprietario'].toString();
          }
        }
      });

      getCliente(idCliente);
    } catch (e) {
      print(e);
      const snackBar = SnackBar(
        content: Text('Error'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void getCliente(String idCliente) async {
    final token = await storage.read(key: 'token');
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/cliente/"),
        headers: {'Authorization': 'Token ' + token.toString()});
    List responseMap = jsonDecode(response.body);

    setState(() {
      for (var el in responseMap) {
        if (el['id'].toString() == idCliente) {
          cliente.add({
            'id': el['id'].toString(),
            'nome': el['nome'].toString(),
          });
        }
      }
    });
  }

  void initState() {
    super.initState();
    getProduto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Produto'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 500,
              height: 500,
              child: Card(
                margin: EdgeInsets.all(10),
                color: Colors.green[100],
                shadowColor: Colors.blueGrey,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(produto[0]['nome'].toString(),
                        style: TextStyle(fontSize: 48)),
                    Text(produto[0]['preco'].toString(),
                        style: TextStyle(fontSize: 48)),
                    Text('Proprietário: '+ cliente[0]['nome'].toString(),style: TextStyle(fontSize: 24))
                  ],
                ),
              ),
            )
            )
            );
  }
}
