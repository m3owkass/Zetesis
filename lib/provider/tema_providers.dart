import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/repository_providers.dart';

final temasProvider = StreamProvider<List<TemaModel>>((ref) {
  return ref.read(temaRepositoryProvider).watchAll();
});

final temaSelecionadoProvider = StateProvider<String?>((ref) => null);

final temaAtualProvider = FutureProvider<TemaModel?>((ref) async {
  final nome = ref.watch(temaSelecionadoProvider);
  if (nome == null) return null;
  return ref.read(temaRepositoryProvider).getByName(nome);
});

final todosTemasProvider = StreamProvider<List<TemaModel>>((ref) {
  return ref.read(temaRepositoryProvider).watchAll();
});
