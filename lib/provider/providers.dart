import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/services/auth_service.dart';
import 'package:zetesis/services/database_service.dart';
import 'package:zetesis/services/secure_storage_service.dart';

// Serviços

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final databaseServiceProvider = Provider<DatabaseService>(
  (ref) => DatabaseService(),
);
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

// Autenticação

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authState;
});

// Usuário

final userProvider = FutureProvider<UsuarioModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return ref.read(databaseServiceProvider).getUser(user.uid);
});

// Temas

final temasProvider = StreamProvider<List<TemaModel>>((ref) {
  return ref.read(databaseServiceProvider).watchAllTemas();
});

final temaSelecionadoProvider = StateProvider<String?>((ref) => null);

final temaAtualProvider = FutureProvider<TemaModel?>((ref) async {
  final nome = ref.watch(temaSelecionadoProvider);
  if (nome == null) return null;
  return ref.read(databaseServiceProvider).getTemaByName(nome);
});

// Tarefas
final todasTarefasProvider = StreamProvider<List<TarefaModel>>((ref) {
  return ref.read(databaseServiceProvider).watchAllTarefas();
});

final tarefaSelecionadoProvider = StateProvider<String?>((ref) => null);

final tarefaAtualProvider = FutureProvider<TarefaModel?>((ref) async {
  final nome = ref.watch(tarefaSelecionadoProvider);
  if (nome == null) return null;
  return ref.read(databaseServiceProvider).getTarefaByName(nome);
});

final tarefasProvider = StreamProvider<List<TarefaModel>>((ref) {
  final tema = ref.watch(temaSelecionadoProvider);
  if (tema == null) return Stream.value([]);
  return ref.read(databaseServiceProvider).watchTarefasByTema(tema);
});

// Biblioteca

final gruposProvider = StreamProvider<List<GrupoBibliotecaModel>>((ref) {
  return ref.read(databaseServiceProvider).watchAllGruposBiblioteca();
});

final grupoSelecionadoProvider = StateProvider<String?>((ref) => null);

final materiaisProvider = StreamProvider<List<MaterialBibliotecaModel>>((ref) {
  final tipo = ref.watch(grupoSelecionadoProvider);
  if (tipo == null) return Stream.value([]);
  return ref.read(databaseServiceProvider).watchMaterialsByType(tipo);
});

final favoritosProvider = StreamProvider<Set<String>>((ref) async* {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    yield {};
    return;
  }

  final box = Hive.box<Map>('userBox');
  final hiveKey = 'favoritos_${user.uid}';
  final cached = box.get(hiveKey);
  if (cached != null) {
    final ids = cached['ids'];
    if (ids is List) yield Set<String>.from(ids.whereType<String>());
  }

  yield* ref.read(databaseServiceProvider).watchFavoritos(user.uid).map((set) {
    box.put(hiveKey, {'ids': set.toList()});
    return set;
  });
});

// Loja

final itemsProvider = StreamProvider<List<ItemLojaModel>>((ref) {
  return ref.read(databaseServiceProvider).watchAllItems();
});
