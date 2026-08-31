import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class BaseRepository<T> {
  BaseRepository(this.collectionName);

  final String collectionName;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get col =>
      db.collection(collectionName);

  T fromDoc(String id, Map<String, dynamic> data);

  Map<String, dynamic> toMap(T item);

  Future<String> add(T item) async => (await col.add(toMap(item))).id;

  Future<void> update(String id, Map<String, dynamic> fields) =>
      col.doc(id).update(fields);

  Future<void> remove(String id) => col.doc(id).delete();

  

  Future<T?> getById(String id) async {
    final doc = await col.doc(id).get();
    final data = doc.data();
    return (doc.exists && data != null) ? fromDoc(doc.id, data) : null;
  }

  Future<List<T>> getAll() async {
    try {
      final snap = await col.get();
      return snap.docs.map((d) => fromDoc(d.id, d.data())).toList();
    } catch (e) {
      debugPrint('Erro ao buscar $collectionName: $e');
      return [];
    }
  }

  Stream<List<T>> watchAll() {
    return col.snapshots().map(
      (s) => s.docs.map((d) => fromDoc(d.id, d.data())).toList(),
    );
  }
}
