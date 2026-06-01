import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/services/auth_service.dart';
import 'package:zetesis/services/database_service.dart';
import 'package:zetesis/services/secure_storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final databaseServiceProvider = Provider<DatabaseService>(
  (ref) => DatabaseService(),
);
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authState;
});

final userProvider = FutureProvider<UsuarioModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return ref.read(databaseServiceProvider).getUser(user.uid);
});

final itemsProvider = FutureProvider((ref) {
  return ref.watch(databaseServiceProvider).getAllItems();
});

final temasProvider = FutureProvider((ref) {
  return ref.watch(databaseServiceProvider).getAllTemas();
});

final temaSelecionadoProvider = StateProvider<String?>((ref) {
  return ref.watch(userProvider).value?.temaAtual;
});

final temaAtualProvider = FutureProvider<TemaModel?>((ref) async {
  final nome = ref.watch(temaSelecionadoProvider);
  if (nome == null) return null;
  return ref.read(databaseServiceProvider).getTemaByName(nome);
});

final gruposProviders = FutureProvider((ref) {
  return ref.watch(databaseServiceProvider).getAllGruposBiblioteca();
});

final grupoSelecionadoProvider = StateProvider<String?>((ref) {
  return null;
});

final materiaisProvider = FutureProvider<List<MaterialBibliotecaModel>>((ref) async {
  final type = ref.watch(grupoSelecionadoProvider);
  if (type == null) return [];
  return ref.read(databaseServiceProvider).getMaterialsByType(type);
});
