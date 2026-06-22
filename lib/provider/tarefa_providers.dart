import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/repository_providers.dart';
import 'package:zetesis/provider/tema_providers.dart';

final todasTarefasProvider = StreamProvider.autoDispose<List<TarefaModel>>((
  ref,
) {
  return ref.read(tarefaRepositoryProvider).watchAll();
});

final tarefasProvider = StreamProvider.autoDispose<List<TarefaModel>>((ref) {
  final tema = ref.watch(temaSelecionadoProvider);
  if (tema == null) return Stream.value([]);
  return ref.read(tarefaRepositoryProvider).watchByTema(tema);
});
