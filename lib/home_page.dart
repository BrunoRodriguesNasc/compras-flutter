import 'package:commerce/add_pedido_page.dart';
import 'package:commerce/add_produto_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  String token = '';

  void getToken() async {
    final data = await storage.read(key: 'token');
    setState(() {
      token = data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ABA - COMÉRCIO LTDA',
          style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
        ),
      ),
      body: Row(
        children: [
          Column(
            children: [
              Card(
                margin: const EdgeInsets.all(50),
                color: const Color.fromARGB(255, 78, 120, 199),
                elevation: 10,
                shadowColor: Colors.blue,
                child: InkWell(
                    splashColor: Colors.black,
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProdutoPage(),
                            ),
                          )
                        },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      child: const Text(
                        'Adicionar Produto',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
              ),
              Card(
                margin: EdgeInsets.all(50),
                color: Color.fromARGB(255, 78, 120, 199),
                elevation: 10,
                shadowColor: Colors.blue,
                child: InkWell(
                  splashColor: Colors.black,
                  onTap: () => {print('Oi')},
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    child: const Text(
                      'Adicionar Cliente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(50),
                color: Color.fromARGB(255, 78, 120, 199),
                elevation: 10,
                shadowColor: Colors.blue,
                child: InkWell(
                  splashColor: Colors.black,
                  onTap: () => {print('Oi')},
                  child: Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text(
                      'Adicionar Pedido',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Card(
                margin: const EdgeInsets.all(50),
                color: const Color.fromARGB(255, 78, 120, 199),
                elevation: 10,
                shadowColor: Colors.blue,
                child: InkWell(
                    splashColor: Colors.black,
                    onTap: () => {print('Oi')},
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      child: const Text(
                        'Lista de produtos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
              ),
              Card(
                margin: EdgeInsets.all(50),
                color: Color.fromARGB(255, 78, 120, 199),
                elevation: 10,
                shadowColor: Colors.blue,
                child: InkWell(
                  splashColor: Colors.black,
                  onTap: () => {print('Oi')},
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    child: const Text(
                      'Lista de Cliente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(50),
                color: Color.fromARGB(255, 78, 120, 199),
                elevation: 10,
                shadowColor: Colors.blue,
                child: InkWell(
                  splashColor: Colors.black,
                  onTap: () => {print('Oi')},
                  child: Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text(
                      'Lista de Pedido',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
