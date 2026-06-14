import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/services/repositories/base_repository.dart';

class TarefaRepository extends BaseRepository<TarefaModel> {
  TarefaRepository() : super('tarefas');

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
}
