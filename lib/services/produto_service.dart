import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_estoque_residencial/models/produto.dart'; // Importe o modelo de produto

FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<Produto>> getProdutos(String userId) async {
  List<Produto> produtos = [];
  CollectionReference collectionReferenceProduto =
      _firestore.collection('produtos');
  QuerySnapshot queryProduto =
      await collectionReferenceProduto.where('userId', isEqualTo: userId).get();
  for (var documento in queryProduto.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final produto = Produto.fromMap(data);
    produtos.add(produto);
  }
  return produtos;
}

Future<void> setProduto(Produto produto) async {
  await _firestore.collection("produtos").doc(produto.id).set(produto.toMap());
}

Future<void> updateProduto(Produto produto) async {
  await _firestore
      .collection("produtos")
      .doc(produto.id)
      .update(produto.toMap());
}

Future<void> deleteProduto(String id) async {
  await _firestore.collection("produtos").doc(id).delete();
}
