import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/services/auth_service.dart';
import 'package:zetesis/services/database_service.dart';
import 'package:zetesis/services/secure_storage_service.dart';

// ─── Serviços ────────────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final databaseServiceProvider = Provider<DatabaseService>(
  (ref) => DatabaseService(),
);
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

// ─── Autenticação ────────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authState;
});

// ─── Usuário ─────────────────────────────────────────────────────────────────

final userProvider = FutureProvider<UsuarioModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return ref.read(databaseServiceProvider).getUser(user.uid);
});

// ─── Temas ───────────────────────────────────────────────────────────────────

final temasProvider = FutureProvider<List<TemaModel>>((ref) {
  return ref.read(databaseServiceProvider).getAllTemas();
});

final temaSelecionadoProvider = StateProvider<String?>((ref) => null);

final temaAtualProvider = FutureProvider<TemaModel?>((ref) async {
  final nome = ref.watch(temaSelecionadoProvider);
  if (nome == null) return null;
  return ref.read(databaseServiceProvider).getTemaByName(nome);
});

// ─── Biblioteca ──────────────────────────────────────────────────────────────

final gruposProvider = FutureProvider<List<GrupoBibliotecaModel>>((ref) {
  return ref.read(databaseServiceProvider).getAllGruposBiblioteca();
});

final grupoSelecionadoProvider = StateProvider<String?>((ref) => null);

final materiaisProvider = FutureProvider<List<MaterialBibliotecaModel>>((
  ref,
) async {
  final tipo = ref.watch(grupoSelecionadoProvider);
  if (tipo == null) return [];
  return ref.read(databaseServiceProvider).getMaterialsByType(tipo);
});

// ─── Loja ─────────────────────────────────────────────────────────────────────

final itemsProvider = FutureProvider<List<ItemLojaModel>>((ref) {
  return ref.read(databaseServiceProvider).getAllItems();
});
