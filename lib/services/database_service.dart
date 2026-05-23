import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/model/usuario.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser(String uid, UsuarioModel user) async {
    await _db
        .collection('users')
        .doc(uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> removeUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
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

  Future<void> addItem(ItemLojaModel item) async {
    await _db.collection('items').add(item.toMap());
  }

  Future<List<ItemLojaModel>> getAllItems() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('items').get();

      return querySnapshot.docs.map((doc) {
        return ItemLojaModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    }
  }

  Future<void> addTema(TemaModel tema) async {
    await _db.collection('temas').add(tema.toMap());
  }

  Future<void> removeTema(String tid) async {
    await _db.collection('temas').doc(tid).delete();
    
  }

  Future<List<TemaModel>> getAllTemas() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('temas').get();

      return querySnapshot.docs.map((doc) {
        return TemaModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    }
  }
  Future<TemaModel?> getTema(String tid) async {
    final doc = await _db.collection('temas').doc(tid).get();
    if (doc.exists && doc.data() != null) {
      return TemaModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<TemaModel?> getTemaByName(String name) async {
    try {
      final query = await _db
          .collection('temas')
          .where('nome', isEqualTo: name)
          .limit(1)
          .get();
      if (query.docs.isEmpty) return null;
      return TemaModel.fromMap(query.docs.first.data());
    } catch (e) {
      print("Error fetching tema by name: $e");
      return null;
    }
  }

  Future<List<String>> getNamesTemas() async {
    try {
      final temas = await getAllTemas();
      return temas.map((t) => t.nome).toList();
    } catch (e) {
      print("Error fetching tema names: $e");
      return [];
    }
  }
}
