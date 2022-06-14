import 'dart:convert';

import 'package:commerce/produto_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ListProdutoPage extends StatefulWidget {
  const ListProdutoPage({Key? key}) : super(key: key);

  @override
  State<ListProdutoPage> createState() => _ListProdutoPageState();
}

class _ListProdutoPageState extends State<ListProdutoPage> {
  final storage = const FlutterSecureStorage();
  var produtos = [];

  void getProdutos() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
          Uri.parse("http://10.0.2.2:8000/produto/"),
          headers: {'Authorization': 'Token ' + token.toString()});

      List responseMap = jsonDecode(response.body);
      setState(() {
        for (var el in responseMap) {
          produtos.add({
            'id': el['id'].toString(),
            'nome': el['nome'].toString(),
            'preco': el['preco'].toString()
          });
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
    this.getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 192, 240),
      appBar: AppBar(
        title: const Text('Lista produtos'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, position) {
            return Card(
                elevation: 10,
                shadowColor: Colors.blue,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: InkWell(
                      onTap: ()=> {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdutoPage(idProduto: produtos[position]['id'].toString()),
                            ),
                          )
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Text(
                          produtos[position]['nome'].toString(),
                          style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 11, 91, 252)),
                        ),
                        Text(
                          "Preço:" + produtos[position]['preco'].toString(),
                          style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 11, 91, 252)),
                        )
                      ])),
                ));
          },
        ),
      ),
    );
  }
}
