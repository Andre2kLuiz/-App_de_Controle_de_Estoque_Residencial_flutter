import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_estoque_residencial/models/usuario.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<Usuario>> getUsuarios() async {
  List<Usuario> usuarios = [];
  CollectionReference collectionReferenceUsuario =
      _firestore.collection('Usuarios');
  QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();
  for (var documento in queryUsuario.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final usuario = Usuario.fromMap(data);
    usuarios.add(usuario);
  }
  return usuarios;
}

Future<void> setUsuario(Usuario usuario) async {
  await _firestore.collection("Usuarios").doc(usuario.id).set(usuario.toMap());
}

Future<void> updateUsuario(Usuario usuario) async {
  await _firestore
      .collection("Usuarios")
      .doc(usuario.id)
      .update(usuario.toMap());
}

Future<void> deleteUsuario(String uid) async {
  await _firestore.collection("Usuarios").doc(uid).delete();
}
