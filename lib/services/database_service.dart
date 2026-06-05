import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:zetesis/model/filme.dart';
import 'package:zetesis/model/filosofo.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/musica.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/model/texto.dart';
import 'package:zetesis/model/usuario.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  // Usuários

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

  // Temas

  Future<void> addTema(TemaModel tema) async {
    await _db.collection('temas').add(tema.toMap());
  }

  Future<void> updateTema(String tid, Map<String, dynamic> fields) async {
    await _db.collection('temas').doc(tid).update(fields);
  }

  Future<void> removeTema(String tid) async {
    await _db.collection('temas').doc(tid).delete();
  }

  Future<List<TemaModel>> getAllTemas() async {
    try {
      final snapshot = await _db.collection('temas').get();
      return snapshot.docs
          .map((doc) => TemaModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar temas: $e');
      return [];
    }
  }

  Future<TemaModel?> getTema(String tid) async {
    final doc = await _db.collection('temas').doc(tid).get();
    if (doc.exists && doc.data() != null) {
      return TemaModel.fromMap(doc.data()!, id: doc.id);
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
      final doc = query.docs.first;
      return TemaModel.fromMap(doc.data(), id: doc.id);
    } catch (e) {
      debugPrint('Erro ao buscar tema por nome: $e');
      return null;
    }
  }

  Future<List<String>> getNamesTemas() async {
    try {
      final temas = await getAllTemas();
      return temas.map((t) => t.nome).toList();
    } catch (e) {
      debugPrint('Erro ao buscar nomes dos temas: $e');
      return [];
    }
  }

  // Itens da Loja

  Future<void> addItem(ItemLojaModel item) async {
    await _db.collection('items').add(item.toMap());
  }

  Future<void> updateItem(String iid, Map<String, dynamic> fields) async {
    await _db.collection('items').doc(iid).update(fields);
  }

  Future<void> removeItem(String iid) async {
    await _db.collection('items').doc(iid).delete();
  }

  Future<List<ItemLojaModel>> getAllItems() async {
    try {
      final snapshot = await _db.collection('items').get();
      return snapshot.docs
          .map((doc) => ItemLojaModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar itens da loja: $e');
      return [];
    }
  }

  // Materiais da Biblioteca

  Future<void> addMaterial(MaterialBibliotecaModel material) async {
    await _db.collection('materiais').add(material.toMap());
  }

  Future<void> updateMaterial(String mid, Map<String, dynamic> fields) async {
    await _db.collection('materiais').doc(mid).update(fields);
  }

  Future<void> removeMaterial(String mid) async {
    await _db.collection('materiais').doc(mid).delete();
  }

  Future<List<MaterialBibliotecaModel>> getAllMateriais() async {
    try {
      final snapshot = await _db.collection('materiais').get();
      return snapshot.docs
          .map((doc) => MaterialBibliotecaModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar materiais: $e');
      return [];
    }
  }

  Future<List<MaterialBibliotecaModel>> getMaterialsByType(String type) async {
    try {
      final snapshot = await _db
          .collection('materiais')
          .where('tipo', isEqualTo: type)
          .get();
      return snapshot.docs
          .map((doc) => MaterialBibliotecaModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar materiais por tipo: $e');
      return [];
    }
  }

  Future<List<String>> getMateriaisNames() async {
    try {
      final materiais = await getAllMateriais();
      return materiais.map((m) => m.nome).toList();
    } catch (e) {
      debugPrint('Erro ao buscar nomes dos materiais: $e');
      return [];
    }
  }

  // Grupos da Biblioteca

  Future<void> addGrupoBiblioteca(GrupoBibliotecaModel grupo) async {
    await _db.collection('grupos_biblioteca').add(grupo.toMap());
  }

  Future<void> updateGrupoBiblioteca(
    String gid,
    Map<String, dynamic> fields,
  ) async {
    await _db.collection('grupos_biblioteca').doc(gid).update(fields);
  }

  Future<void> removeGrupoBiblioteca(String gid) async {
    await _db.collection('grupos_biblioteca').doc(gid).delete();
  }

  Future<List<GrupoBibliotecaModel>> getAllGruposBiblioteca() async {
    try {
      final snapshot = await _db.collection('grupos_biblioteca').get();
      return snapshot.docs
          .map((doc) => GrupoBibliotecaModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar grupos da biblioteca: $e');
      return [];
    }
  }

  // Filósofos

  Future<void> addFilosofo(FilosofoModel filosofo) async {
    await _db.collection('filosofos').add(filosofo.toMap());
  }

  Future<void> updateFilosofo(String fid, Map<String, dynamic> fields) async {
    await _db.collection('filosofos').doc(fid).update(fields);
  }

  Future<void> removeFilosofo(String fid) async {
    await _db.collection('filosofos').doc(fid).delete();
  }

  Future<List<FilosofoModel>> getAllFilosofos() async {
    try {
      final snapshot = await _db.collection('filosofos').get();
      return snapshot.docs
          .map((doc) => FilosofoModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar filósofos: $e');
      return [];
    }
  }

  Future<FilosofoModel?> getFilosofo(String fid) async {
    final doc = await _db.collection('filosofos').doc(fid).get();
    if (doc.exists && doc.data() != null) {
      return FilosofoModel.fromMap(doc.data()!, id: doc.id);
    }
    return null;
  }

  // Textos

  Future<void> addTexto(TextoModel texto) async {
    await _db.collection('textos').add(texto.toMap());
  }

  Future<void> updateTexto(String tid, Map<String, dynamic> fields) async {
    await _db.collection('textos').doc(tid).update(fields);
  }

  Future<void> removeTexto(String tid) async {
    await _db.collection('textos').doc(tid).delete();
  }

  Future<List<TextoModel>> getAllTextos() async {
    try {
      final snapshot = await _db.collection('textos').get();
      return snapshot.docs
          .map((doc) => TextoModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar textos: $e');
      return [];
    }
  }

  Future<TextoModel?> getTexto(String tid) async {
    final doc = await _db.collection('textos').doc(tid).get();
    if (doc.exists && doc.data() != null) {
      return TextoModel.fromMap(doc.data()!, id: doc.id);
    }
    return null;
  }

  // Músicas

  Future<void> addMusica(MusicaModel musica) async {
    await _db.collection('musicas').add(musica.toMap());
  }

  Future<void> updateMusica(String mid, Map<String, dynamic> fields) async {
    await _db.collection('musicas').doc(mid).update(fields);
  }

  Future<void> removeMusica(String mid) async {
    await _db.collection('musicas').doc(mid).delete();
  }

  Future<List<MusicaModel>> getAllMusicas() async {
    try {
      final snapshot = await _db.collection('musicas').get();
      return snapshot.docs
          .map((doc) => MusicaModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar músicas: $e');
      return [];
    }
  }

  Future<MusicaModel?> getMusica(String mid) async {
    final doc = await _db.collection('musicas').doc(mid).get();
    if (doc.exists && doc.data() != null) {
      return MusicaModel.fromMap(doc.data()!, id: doc.id);
    }
    return null;
  }

  // Filmes

  Future<void> addFilme(FilmeModel filme) async {
    await _db.collection('filmes').add(filme.toMap());
  }

  Future<void> updateFilme(String fid, Map<String, dynamic> fields) async {
    await _db.collection('filmes').doc(fid).update(fields);
  }

  Future<void> removeFilme(String fid) async {
    await _db.collection('filmes').doc(fid).delete();
  }

  Future<List<FilmeModel>> getAllFilmes() async {
    try {
      final snapshot = await _db.collection('filmes').get();
      return snapshot.docs
          .map((doc) => FilmeModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar filmes: $e');
      return [];
    }
  }

  Future<FilmeModel?> getFilme(String fid) async {
    final doc = await _db.collection('filmes').doc(fid).get();
    if (doc.exists && doc.data() != null) {
      return FilmeModel.fromMap(doc.data()!, id: doc.id);
    }
    return null;
  }
}
