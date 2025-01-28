import 'package:cloud_firestore/cloud_firestore.dart';

class Movimentacao {
  final String id;
  final String produtoId;
  final int quantidade;
  final Timestamp data;

  Movimentacao({
    required this.id,
    required this.produtoId,
    required this.quantidade,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produtoId': produtoId,
      'quantidade': quantidade,
      'data': data,
    };
  }

  factory Movimentacao.fromMap(Map<String, dynamic> map) {
    return Movimentacao(
      id: map['id'],
      produtoId: map['produtoId'],
      quantidade: map['quantidade'],
      data: map['data'],
    );
  }
}
