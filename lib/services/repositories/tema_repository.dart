import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/services/repositories/base_repository.dart';

class TemaRepository extends BaseRepository<TemaModel> {
  TemaRepository() : super('temas');

  @override
  TemaModel fromDoc(String id, Map<String, dynamic> data) =>
      TemaModel.fromMap(data, id: id);

  @override
  Map<String, dynamic> toMap(TemaModel item) => item.toMap();

  Future<TemaModel?> getByName(String nome) async {
    try {
      final query = await col.where('nome', isEqualTo: nome).limit(1).get();
      if (query.docs.isEmpty) return null;
      final doc = query.docs.first;
      return fromDoc(doc.id, doc.data());
    } catch (e) {
      debugPrint('Erro ao buscar tema por nome: $e');
      return null;
    }
  }

  Future<void> removeCascade(String temaId, WidgetRef ref, List<TarefaModel> tarefas)async{
  
  for (var tarefa in tarefas) {
    ref.read(tarefaRepositoryProvider).remove(tarefa.id!);
    
  }
  ref.read(temaRepositoryProvider).remove(temaId);
  
}
}
