import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zetesis/model/usuario.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser(String uid, UsuarioModel user) async {
    await _db.collection('users').doc(uid).set(
      user.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<UsuarioModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UsuarioModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> fields) async {
    await _db.collection('users').doc(uid).update(fields);
  }
}