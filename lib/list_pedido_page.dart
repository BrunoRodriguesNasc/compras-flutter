import 'dart:convert';

import 'package:commerce/pedido_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ListPedidoPage extends StatefulWidget {
  const ListPedidoPage({Key? key}) : super(key: key);

  @override
  State<ListPedidoPage> createState() => _ListPedidoPageState();
}

class _ListPedidoPageState extends State<ListPedidoPage> {
  final storage = const FlutterSecureStorage();
  var pedidos = [];
  var produto = [];
  void getPedidos() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(Uri.parse("http://10.0.2.2:8000/pedido/"),
          headers: {'Authorization': 'Token ' + token.toString()});

      List responseMap = jsonDecode(response.body);
      setState(() {
        for (var el in responseMap) {
          pedidos.add({
            'id': el['id'].toString(),
            'cliente': el['cliente'].toString(),
            'produto': el['produto'].toString()
          });
        }
      });
      for (var i = 0; i < pedidos.length; i++) {
        getProduto(pedidos[i]['produto']);
      }
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
        content: Text('Error'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void initState() {
    super.initState();
    this.getPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 192, 240),
      appBar: AppBar(
        title: const Text('Lista produtos'),
      ),
      body: ListView.builder(
        itemCount: produto.length,
        itemBuilder: (context, position) {
          return Card(
              elevation: 10,
              shadowColor: Colors.blue,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: InkWell(
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PedidoPage(
                                  idPedido: pedidos[position]['id'].toString()),
                            ),
                          )
                        },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            produto[position]['nome'].toString(),
                            style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 11, 91, 252)),
                          ),
                        ])),
              ));
        },
      ),
    );
  }
}
