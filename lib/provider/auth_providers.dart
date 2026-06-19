import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/repository_providers.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authState;
});

final userProvider = StreamProvider<UsuarioModel?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.read(usuarioRepositoryProvider).watch(user.uid);
});
