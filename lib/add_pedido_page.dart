import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddPedidoPage extends StatefulWidget {
  const AddPedidoPage({Key? key}) : super(key: key);

  @override
  State<AddPedidoPage> createState() => _AddPedidoPageState();
}

class _AddPedidoPageState extends State<AddPedidoPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey();
  final storage = const FlutterSecureStorage();
  var clientesDropDown = '';
  var clientes = [];
  var produtoDropDown = '';
  var produtos = [];
  DateTime now = new DateTime.now();
  void getClientes() async {
    final data = await storage.read(key: 'token');
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/cliente/"),
        headers: {'Authorization': 'Token ' + data.toString()});

    List responseMap = jsonDecode(response.body);

    setState(() {
      clientesDropDown = responseMap[0]['id'].toString();
      for (var el in responseMap) {
        clientes
            .add({'id': el['id'].toString(), 'nome': el['nome'].toString()});
      }
    });
  }

  void getProdutos() async {
    final data = await storage.read(key: 'token');
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/produto/"),
        headers: {'Authorization': 'Token ' + data.toString()});

    List responseMap = jsonDecode(response.body);

    setState(() {
      produtoDropDown = responseMap[0]['id'].toString();
      for (var el in responseMap) {
        produtos
            .add({'id': el['id'].toString(), 'nome': el['nome'].toString()});
      }
    });
  }

  void savePedido() async {
    final data = await storage.read(key: 'token');
    var body = {
      'instante': now.toString(),
      'cliente': clientesDropDown,
      'produto': produtoDropDown
    };

    try {
       final response = await http.post(Uri.parse("http://10.0.2.2:8000/pedido/"),
        body: body,
        headers: {'Authorization': 'Token ' + data.toString()});
        var responseJson = jsonDecode(response.body);
        print(responseJson);
    } catch (e) {
      print(e);
    }
   
        
  }

  void initState() {
    super.initState();
    this.getClientes();
    this.getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar pedido'),
      ),
      body: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            DropdownButtonFormField(
              hint: Text('Selecione o cliente'),
              isExpanded: false,
              decoration: InputDecoration(
                  label: Text('Cliente'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              items: clientes.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nome']),
                  value: item['id'],
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  clientesDropDown = newVal.toString();
                });
              },
              value: clientesDropDown.isEmpty ? null : clientesDropDown,
            ),
            DropdownButtonFormField(
              hint: Text('Selecione o produto'),
              isExpanded: false,
              decoration: InputDecoration(
                  label: Text('Produto'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              items: produtos.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nome']),
                  value: item['id'],
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  produtoDropDown = newVal.toString();
                });
              },
              value: produtoDropDown.isEmpty ? null : produtoDropDown,
            ),
            ElevatedButton(
                onPressed: () => {_formKey.currentState?.save(), savePedido()},
                child: const Text('Salvar pedido'),
              ),
          ],
        ),
      ),
    );
  }
}
