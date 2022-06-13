// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoriaModel {
  String nome;
  String id;


  CategoriaModel ({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'id': id,
    };
  }

  factory CategoriaModel.fromMap(Map<String, dynamic> map) {
    return CategoriaModel(
      nome: map['nome'] ?? "",
      id: map['id'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriaModel.fromJson(String source) => CategoriaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
