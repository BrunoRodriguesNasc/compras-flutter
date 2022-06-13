import 'package:flutter/material.dart';

class AddPedidoPage extends StatefulWidget {

  const AddPedidoPage({ Key? key }) : super(key: key);

  @override
  State<AddPedidoPage> createState() => _AddPedidoPageState();
}

class _AddPedidoPageState extends State<AddPedidoPage> {

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Adicionar pedido'),),
           body: Container(),
       );
  }
}