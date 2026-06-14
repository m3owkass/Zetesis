import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/services/auth_service.dart';
import 'package:zetesis/services/repositories/grupo_biblioteca_repository.dart';
import 'package:zetesis/services/repositories/item_loja_repository.dart';
import 'package:zetesis/services/repositories/material_biblioteca_repository.dart';
import 'package:zetesis/services/repositories/tarefa_repository.dart';
import 'package:zetesis/services/repositories/tema_repository.dart';
import 'package:zetesis/services/repositories/usuario_repository.dart';
import 'package:zetesis/services/secure_storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final usuarioRepositoryProvider = Provider<UsuarioRepository>(
  (ref) => UsuarioRepository(),
);
final temaRepositoryProvider = Provider<TemaRepository>(
  (ref) => TemaRepository(),
);
final tarefaRepositoryProvider = Provider<TarefaRepository>(
  (ref) => TarefaRepository(),
);
final itemLojaRepositoryProvider = Provider<ItemLojaRepository>(
  (ref) => ItemLojaRepository(),
);
final materialBibliotecaRepositoryProvider =
    Provider<MaterialBibliotecaRepository>(
      (ref) => MaterialBibliotecaRepository(),
    );
final grupoBibliotecaRepositoryProvider = Provider<GrupoBibliotecaRepository>(
  (ref) => GrupoBibliotecaRepository(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authState;
});

final userProvider = StreamProvider<UsuarioModel?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.read(usuarioRepositoryProvider).watch(user.uid);
});

final temasProvider = StreamProvider<List<TemaModel>>((ref) {
  return ref.read(temaRepositoryProvider).watchAll();
});

final temaSelecionadoProvider = StateProvider<String?>((ref) => null);

final temaAtualProvider = FutureProvider<TemaModel?>((ref) async {
  final nome = ref.watch(temaSelecionadoProvider);
  if (nome == null) return null;
  return ref.read(temaRepositoryProvider).getByName(nome);
});

final todasTarefasProvider = StreamProvider<List<TarefaModel>>((ref) {
  return ref.read(tarefaRepositoryProvider).watchAll();
});

final tarefasProvider = StreamProvider<List<TarefaModel>>((ref) {
  final tema = ref.watch(temaSelecionadoProvider);
  if (tema == null) return Stream.value([]);
  return ref.read(tarefaRepositoryProvider).watchByTema(tema);
});

final gruposProvider = StreamProvider<List<GrupoBibliotecaModel>>((ref) {
  return ref.read(grupoBibliotecaRepositoryProvider).watchAll();
});

final grupoSelecionadoProvider = StateProvider<String?>((ref) => null);

final todosMateriaisProvider = StreamProvider<List<MaterialBibliotecaModel>>((
  ref,
) {
  return ref.read(materialBibliotecaRepositoryProvider).watchAll();
});

final totalUsuariosProvider = StreamProvider<int>((ref) {
  return ref.read(usuarioRepositoryProvider).watchTotal();
});

final todosUsuariosProvider = StreamProvider<List<UsuarioModel>>((ref) {
  return ref.read(usuarioRepositoryProvider).watchAll();
});

final materiaisProvider = StreamProvider<List<MaterialBibliotecaModel>>((ref) {
  final tipo = ref.watch(grupoSelecionadoProvider);
  if (tipo == null) return Stream.value([]);
  return ref.read(materialBibliotecaRepositoryProvider).watchByType(tipo);
});

final favoritosProvider = StreamProvider<Set<String>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value({});
  return ref.read(usuarioRepositoryProvider).watchFavoritos(user.uid);
});

final itemsProvider = StreamProvider<List<ItemLojaModel>>((ref) {
  return ref.read(itemLojaRepositoryProvider).watchAll();
});
