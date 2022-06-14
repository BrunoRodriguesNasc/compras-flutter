import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddClientePage extends StatefulWidget {
  const AddClientePage({Key? key}) : super(key: key);

  @override
  State<AddClientePage> createState() => _AddClientePageState();
}

class _AddClientePageState extends State<AddClientePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey();
  final storage = const FlutterSecureStorage();
  var nome = '';
  var email = '';
  var cpfOuCnpj = '';
  var logradouro = '';
  var numero = '';
  var complemento = '';
  var bairro = '';
  var cep = '';
  var cepInput = '';
  var cidade = '';
  var estado = '';
  var idEndereco = '';

  var tipo = [
    {'type': 'PESSOA_FISICA', 'nome': 'Pessoa fisica'},
    {'type': 'PESSOA_JURIDICA', 'nome': 'Pessoa juridica'}
  ];
  var tipoDropDown = '';

  void salvaEndereco(String cep) async {
    final token = await storage.read(key: 'token');
    final response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));

    var responseMap = jsonDecode(response.body);

    var body = {
      "logradouro": responseMap['logradouro'],
      "complemento": responseMap['complemento'],
      "bairro": responseMap['bairro'],
      "cidade": responseMap['localidade'],
      "estado": responseMap['uf'],
      "cep": responseMap['cep'],
      'numero': responseMap['numero'] ?? "999",
    };

    try {
      final enderecoResponse = await http.post(
          Uri.parse("http://10.0.2.2:8000/endereco/"),
          body: body,
          headers: {'Authorization': 'Token ' + token.toString()});

      var enderecoResponseMap = jsonDecode(enderecoResponse.body);

      setState(() {
        idEndereco = enderecoResponseMap['id'].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  void saveCliente() async {
    salvaEndereco(cepInput);
   
    try {
      final token = await storage.read(key: 'token');
      var body = {
      "nome": nome,
      "email": email,
      "cpf_ou_cnpj": cpfOuCnpj,
      "tipo": tipoDropDown,
      "endereco":idEndereco,
    };

      var response = await http.post(Uri.parse("http://10.0.2.2:8000/cliente/"),
          body: body, headers: {'Authorization': 'Token ' + token.toString()});
    print(response.body);
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar cliente'),
      ),
      body: Container(
        height: double.maxFinite,
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
                    labelText: 'Nome',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 52, 123, 228)),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (String? value) {
                  email = value.toString();
                },
                decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 52, 123, 228)),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (String? value) {
                  cpfOuCnpj = value.toString();
                },
                decoration: InputDecoration(
                    labelText: 'CPF/CNPJ',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 52, 123, 228)),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              // ignore: unnecessary_new
              DropdownButtonFormField(
                hint: const Text('Tipo de pessoa'),
                isExpanded: true,
                decoration: InputDecoration(
                    label: Text('Tipo'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6))),
                items: tipo.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['nome'].toString()),
                    value: item['type'],
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    tipoDropDown = newVal.toString();
                  });
                },
                value: tipoDropDown.isEmpty ? null : tipoDropDown,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (String? value) => {cepInput = value.toString()},
                decoration: InputDecoration(
                    labelText: 'CEP',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 52, 123, 228)),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),

              ElevatedButton(
                onPressed: () => {_formKey.currentState?.save(), saveCliente()},
                child: const Text('Salvar cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
