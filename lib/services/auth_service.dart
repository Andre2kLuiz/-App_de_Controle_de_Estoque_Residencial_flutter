import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_estoque_residencial/models/usuario.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Usuario> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = credential.user!;
      DocumentSnapshot userDoc =
          await _firestore.collection('Usuarios').doc(user.uid).get();

      if (userDoc.exists) {
        return Usuario.fromMap(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception("Usuário não encontrado no Firestore.");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Usuario> signUpWithEmailAndPassword(
      String email, String password, String nome) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user!;
      Usuario usuario = Usuario(id: user.uid, nome: nome, email: email);
      await _firestore
          .collection('Usuarios')
          .doc(user.uid)
          .set(usuario.toMap());
      return usuario;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  String? getCurrentUserEmail() {
    return _firebaseAuth.currentUser?.email;
  }

  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
