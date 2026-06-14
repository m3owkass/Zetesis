import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/services/auth_service.dart';
import 'package:zetesis/services/repositories/usuario_repository.dart';
import 'package:zetesis/services/secure_storage_service.dart';

enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({this.status = AuthStatus.idle, this.errorMessage});
  const AuthState.idle() : this(status: AuthStatus.idle);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.success() : this(status: AuthStatus.success);
  const AuthState.error(String msg)
    : this(status: AuthStatus.error, errorMessage: msg);

  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref);
  },
);

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthController(this._ref) : super(const AuthState.idle());

  AuthService get _auth => _ref.read(authServiceProvider);
  UsuarioRepository get _usuarios => _ref.read(usuarioRepositoryProvider);
  SecureStorageService get _storage => _ref.read(secureStorageProvider);

  Future<void> login(String email, String senha) async {
    state = const AuthState.loading();
    try {
      final user = await _auth.login(email, senha);
      if (user != null) await _afterLogin(user);

      state = const AuthState.success();
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapError(e.code));
    } catch (e) {
      state = AuthState.error('Erro inesperado: $e');
    }
  }

  Future<void> register(String nome, String email, String senha) async {
    state = const AuthState.loading();
    try {
      final user = await _auth.register(email, senha);
      if (user != null) {
        await _afterLogin(user, nome: nome);
      }
      state = const AuthState.success();
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapError(e.code));
    } catch (e) {
      state = AuthState.error('Erro ao criar conta: $e');
    }
  }

  Future<void> loginGoogle() async {
    state = const AuthState.loading();
    try {
      final user = await _auth.loginGoogle();
      if (user == null) {
        state = const AuthState.idle();
        return;
      }
      await _afterLogin(user);
      debugPrint('After login concluído');
      state = const AuthState.success();
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      state = AuthState.error(
        '${_mapError(e.code)}: ${e.message ?? e.toString()}',
      );
    } on PlatformException catch (e) {
      debugPrint('PlatformException Google Sign-In: ${e.code} - ${e.message}');
      if (e.code == '10') {
        state = const AuthState.error(
          'Erro de configuração do Google Sign-In. Adicione o SHA-1 deste dispositivo no Firebase.',
        );
      } else {
        state = AuthState.error(
          'Erro no login com Google: ${e.message ?? e.code}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Erro no login com Google: $e');
      debugPrintStack(stackTrace: stackTrace);
      state = AuthState.error('Erro no login com Google: $e');
    }
  }

  Future<bool> recoverPassword(String email) async {
    state = const AuthState.loading();
    try {
      await _auth.sendPasswordResetEmail(email);
      state = const AuthState.idle();
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapError(e.code));
      return false;
    } catch (_) {
      state = const AuthState.error('Erro ao enviar email de recuperação');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    await _storage.clear();
    _ref.read(temaSelecionadoProvider.notifier).state = null;
    state = const AuthState.idle();
  }

  void resetState() => state = const AuthState.idle();

  Future<void> _afterLogin(User user, {String? nome}) async {
    final existing = await _usuarios.getById(user.uid);

    final UsuarioModel usuario;
    if (existing == null) {
      usuario = UsuarioModel(
        email: user.email,
        nome: nome ?? user.displayName ?? 'Usuário',
        ranking: 'Bronze',
        pontos: 0,
        avatarUrl: user.photoURL ?? '',
        admin: false,
      );
      await _usuarios.save(user.uid, usuario);
    } else {
      usuario = existing;
    }

    await _storage.saveUser(usuario.toMap());
    _ref.read(temaSelecionadoProvider.notifier).state = usuario.temaAtual;
    _ref.invalidate(userProvider);
  }

  Future<void> deleteAccount() async {
    state = const AuthState.loading();
    try {
      final uid = _ref.read(authServiceProvider).currentUser?.uid;
      if (uid != null) await _usuarios.remove(uid);
      await _auth.deleteAccount();
      await _storage.clear();
      state = const AuthState.idle();
    } catch (e) {
      state = AuthState.error('Erro ao deletar conta: $e');
    }
  }

  Future<bool> updateNome(String nome) async {
    try {
      final uid = _ref.read(authServiceProvider).currentUser?.uid;
      if (uid == null) return false;
      await _usuarios.update(uid, {'nome': nome});
      return true;
    } catch (e) {
      state = AuthState.error('Erro ao atualizar nome: $e');
      return false;
    }
  }

  String _mapError(String code) => switch (code) {
    'user-not-found' => 'Usuário não encontrado',
    'wrong-password' => 'Senha incorreta',
    'invalid-credential' => 'Email ou senha incorretos',
    'email-already-in-use' => 'Este email já está cadastrado',
    'weak-password' => 'Senha muito fraca',
    'invalid-email' => 'Email inválido',
    'missing-email' => 'Informe um email',
    'user-disabled' => 'Conta desativada',
    'network-request-failed' => 'Sem conexão com a internet',
    'too-many-requests' => 'Muitas tentativas. Tente novamente mais tarde',
    _ => 'Erro de autenticação ($code)',
  };

  Future<void> registerItem(
    String nome,
    int custo,
    String assetUrl,
    bool status,
  ) async {
    final item = ItemLojaModel(
      nome: nome,
      custo: custo,
      assetUrl: assetUrl,
      status: status,
    );
    await _ref.read(itemLojaRepositoryProvider).add(item);
  }
}
