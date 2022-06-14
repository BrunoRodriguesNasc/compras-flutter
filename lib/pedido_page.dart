import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PedidoPage extends StatefulWidget {
  var idPedido = '';
  PedidoPage({Key? key, required this.idPedido}) : super(key: key);

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final storage = const FlutterSecureStorage();
  var pedido = [];
  var produto = [];
  var cliente = [];

  void getPedido() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(Uri.parse("http://10.0.2.2:8000/pedido/"),
          headers: {'Authorization': 'Token ' + token.toString()});

      List responseMap = jsonDecode(response.body);
      setState(() {
        for (var el in responseMap) {
          if (el['id'].toString() == widget.idPedido) {
            pedido.add({
              'id': el['id'].toString(),
              'cliente': el['cliente'].toString(),
              'produto': el['produto'].toString()
            });
          }
        }
      });

      getProduto(pedido[0]['produto'].toString());
      getCliente(pedido[0]['cliente'].toString());
    } catch (e) {
      print(e);
      const snackBar = SnackBar(
        content: Text('Error'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void getProduto(String idPedido) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
          Uri.parse("http://10.0.2.2:8000/produto/"),
          headers: {'Authorization': 'Token ' + token.toString()});

      List responseMap = jsonDecode(response.body);
      setState(() {
        for (var el in responseMap) {
          if (el['id'].toString() == idPedido[1]) {
            produto.add({
              'id': el['id'].toString(),
              'nome': el['nome'].toString(),
              'preco': el['preco'].toString()
            });
          }
        }
      });

      
    } catch (e) {
      print(e);
      const snackBar = SnackBar(
        content: Text('Error Snack abaixo'),
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
    this.getPedido();
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
                    Text(produto[0]['nome'].toString().isNotEmpty ? produto[0]['nome'].toString() : 'N/A',
                        style: TextStyle(fontSize: 48)),
                    Text(produto[0]['preco'].toString().isNotEmpty ? produto[0]['preco'].toString() : 'N/A',
                        style: TextStyle(fontSize: 48)),
                   Text(cliente[0]['nome'].toString().isNotEmpty ? 'Solicitante :' + cliente[0]['nome'].toString() : 'N/A',
                        style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
            )));
  }
}
