import 'dart:convert';

import 'package:commerce/model/categoria.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddProdutoPage extends StatefulWidget {
  const AddProdutoPage({Key? key}) : super(key: key);

  @override
  State<AddProdutoPage> createState() => _AddProdutoPageState();
}

class _AddProdutoPageState extends State<AddProdutoPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey();
  String _mySelection = '';
  final storage = const FlutterSecureStorage();
  String nome = '';
  String preco = '';
  var categoriasDropDown = '';
  var categorias = [];
  var clientesDropDown = '';
  var clientes = [];

  void getCategorias() async {
    final data = await storage.read(key: 'token');
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/categoria/"),
        headers: {'Authorization': 'Token ' + data.toString()});

    List responseMap = jsonDecode(response.body);

    setState(() {
      categoriasDropDown = responseMap[0]['id'].toString();
      for (var el in responseMap) {
        categorias.add({'id' : el['id'].toString(), 'nome': el['nome'].toString()});
      }
    });
  }

  void getClientes() async {
    final data = await storage.read(key: 'token');
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/cliente/"),
        headers: {'Authorization': 'Token ' + data.toString()});

    List responseMap = jsonDecode(response.body);

    setState(() {
      clientesDropDown = responseMap[0]['id'].toString();
      for (var el in responseMap) {
        clientes.add({'id': el['id'].toString() ,'nome': el['nome'].toString()});
      }
    });
  }

  void saveProduto() async {
    final data = await storage.read(key: 'token');
    var body = {
      'nome': nome,
      'preco': preco,
      'cliente_proprietario': clientesDropDown,
      'categoria': categoriasDropDown
    };
    try {
      final response = await http.post(Uri.parse("http://10.0.2.2:8000/produto/"),
      body: body,
      headers: {'Authorization': 'Token ' + data.toString()});

      print(response.body);

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
    this.getCategorias();
    this.getClientes();
  }

  @override
  Widget build(BuildContext context) {
    // getCategorias();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar produto'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                onSaved: (String? value) {
                  nome = value.toString();
                },
                decoration: InputDecoration(
                    labelText: 'Nome produto',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (String? value) {
                  preco = value.toString();
                },
                decoration: InputDecoration(
                    labelText: 'Preco',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              // ignore: unnecessary_new
              DropdownButtonFormField(
                hint: const Text('Selecione uma categoria'),
                isExpanded: true,
                decoration: InputDecoration(
                    label: Text('Categoria'),
                    border: OutlineInputBorder(
               
                        borderRadius: BorderRadius.circular(6))),
                items: categorias.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['nome']),
                    value: item['id'],
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    categoriasDropDown = newVal.toString();
                  });
                },
                value: categoriasDropDown.isEmpty ? null : categoriasDropDown,
              ),
              DropdownButtonFormField(
                hint: Text('Selecione o cliente'),
                isExpanded: true,
                decoration: InputDecoration(
                    label: Text('Cliente'),
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.blue),
                        borderRadius: BorderRadius.circular(6))),
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
              ElevatedButton(
                onPressed: () => {_formKey.currentState?.save(), saveProduto()},
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
