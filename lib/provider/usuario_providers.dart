import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/auth_providers.dart';
import 'package:zetesis/provider/repository_providers.dart';

final totalUsuariosProvider = StreamProvider<int>((ref) {
  return ref.read(usuarioRepositoryProvider).watchTotal();
});

final todosUsuariosProvider = StreamProvider<List<UsuarioModel>>((ref) {
  return ref.read(usuarioRepositoryProvider).watchAll();
});

final favoritosProvider = StreamProvider<Set<String>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value({});
  return ref.read(usuarioRepositoryProvider).watchFavoritos(user.uid);
});
