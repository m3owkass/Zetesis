import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zetesis/model/usuario.dart';

class CompraResult {
  final bool ok;
  final String? erro;

  const CompraResult.ok() : ok = true, erro = null;
  const CompraResult.erro(this.erro) : ok = false;
}

class UsuarioRepository {
  final _col = FirebaseFirestore.instance.collection('users');

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _col.doc(uid);

  Future<void> save(String uid, UsuarioModel user) async {
    await _doc(uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> remove(String uid) => _doc(uid).delete();

  Future<UsuarioModel?> getById(String uid) async {
    final doc = await _doc(uid).get();
    final data = doc.data();
    return (doc.exists && data != null)
        ? UsuarioModel.fromMap(data, id: doc.id)
        : null;
  }

  Future<void> update(String uid, Map<String, dynamic> fields) =>
      _doc(uid).update(fields);

  Stream<int> watchTotal() => _col.snapshots().map((s) => s.docs.length);

  Stream<UsuarioModel?> watch(String uid) {
    return _doc(uid).snapshots().map((doc) {
      final data = doc.data();
      return (doc.exists && data != null)
          ? UsuarioModel.fromMap(data, id: doc.id)
          : null;
    });
  }

  Stream<List<UsuarioModel>> watchAll() => _col.snapshots().map(
    (s) => s.docs
        .map((doc) => UsuarioModel.fromMap(doc.data(), id: doc.id))
        .toList(),
  );

  Future<bool> concluirTarefa(
    String uid, {
    required String tarefaId,
    required int pontos,
    required int acertos,
    required int questoes,
  }) async {
    final ref = _doc(uid);
    return FirebaseFirestore.instance.runTransaction<bool>((tx) async {
      final snap = await tx.get(ref);
      final concluidas = List<String>.from(
        (snap.data()?['tarefasConcluidas'] as List? ?? []).whereType<String>(),
      );
      if (concluidas.contains(tarefaId)) return false;
      tx.set(ref, {
        'pontos': FieldValue.increment(pontos),
        'xp': FieldValue.increment(pontos),
        'acertosTotais': FieldValue.increment(acertos),
        'questoesRespondidas': FieldValue.increment(questoes),
        'tarefasConcluidas': FieldValue.arrayUnion([tarefaId]),
      }, SetOptions(merge: true));
      return true;
    });
  }

  Future<CompraResult> comprarItem(
    String uid, {
    required String itemId,
    required int custo,
  }) async {
    final ref = _doc(uid);
    try {
      return await FirebaseFirestore.instance.runTransaction<CompraResult>((
        tx,
      ) async {
        final snap = await tx.get(ref);
        final data = snap.data() ?? {};
        final pontos = (data['pontos'] as num?)?.toInt() ?? 0;
        final comprados = List<String>.from(
          (data['itensComprados'] as List? ?? []).whereType<String>(),
        );

        if (comprados.contains(itemId)) {
          return const CompraResult.erro('Você já possui este item.');
        }
        if (pontos < custo) {
          return const CompraResult.erro('Phatos insuficientes.');
        }

        tx.update(ref, {
          'pontos': pontos - custo,
          'itensComprados': FieldValue.arrayUnion([itemId]),
        });
        return const CompraResult.ok();
      });
    } catch (e) {
      debugPrint('Erro ao comprar item: $e');
      return const CompraResult.erro('Erro ao processar a compra.');
    }
  }

  Stream<Set<String>> watchFavoritos(String uid) async* {
    final box = Hive.box<Map>('userBox');
    final hiveKey = 'favoritos_$uid';

    final ids = box.get(hiveKey)?['ids'];
    if (ids is List) yield Set<String>.from(ids.whereType<String>());

    yield* _doc(uid).snapshots().map((doc) {
      final raw = doc.data()?['favoritos'];
      final set = raw == null
          ? <String>{}
          : Set<String>.from((raw as List).whereType<String>());
      box.put(hiveKey, {'ids': set.toList()});
      return set;
    });
  }

  Future<void> toggleFavorito(
    String uid,
    String materialId, {
    required bool add,
  }) async {
    await _doc(uid).set({
      'favoritos': add
          ? FieldValue.arrayUnion([materialId])
          : FieldValue.arrayRemove([materialId]),
    }, SetOptions(merge: true));
  }
}
