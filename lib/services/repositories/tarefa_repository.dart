import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/services/repositories/base_repository.dart';

class TarefaRepository extends BaseRepository<TarefaModel> {
  TarefaRepository() : super('tarefas');
  final _col = FirebaseFirestore.instance.collection('tarefas');

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _col.doc(uid);

  @override
  TarefaModel fromDoc(String id, Map<String, dynamic> data) =>
      TarefaModel.fromMap(data, id: id);

  @override
  Map<String, dynamic> toMap(TarefaModel item) => item.toMap();

  Stream<List<TarefaModel>> watchByTema(String tema) {
    return col
        .where('tema', isEqualTo: tema)
        .snapshots()
        .map((s) => s.docs.map((d) => fromDoc(d.id, d.data())).toList());
  }

  Future<TarefaModel?> getById(String uid) async {
    final doc = await _doc(uid).get();
    final data = doc.data();
    return (doc.exists && data != null)
        ? TarefaModel.fromMap(data, id: doc.id)
        : null;
  }
}
