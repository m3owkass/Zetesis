import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/services/auth_service.dart';
import 'package:zetesis/services/repositories/grupo_biblioteca_repository.dart';
import 'package:zetesis/services/repositories/item_loja_repository.dart';
import 'package:zetesis/services/repositories/material_biblioteca_repository.dart';
import 'package:zetesis/services/repositories/tarefa_repository.dart';
import 'package:zetesis/services/repositories/tema_repository.dart';
import 'package:zetesis/services/repositories/usuario_repository.dart';
import 'package:zetesis/services/secure_storage_service.dart';
import 'package:zetesis/services/storage_upload_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);
final storageUploadServiceProvider = Provider<StorageUploadService>(
  (ref) => const StorageUploadService(),
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
