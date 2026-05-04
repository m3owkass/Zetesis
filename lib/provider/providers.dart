import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/services/auth_service.dart';
import 'package:zetesis/services/database_service.dart';
import 'package:zetesis/services/secure_storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());
final secureStorageProvider = Provider<SecureStorageService>((ref) => SecureStorageService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authState;
});

final userProvider = FutureProvider<UsuarioModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return ref.read(databaseServiceProvider).getUser(user.uid);
});