import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';

enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({this.status = AuthStatus.idle, this.errorMessage});
  const AuthState.idle() : this(status: AuthStatus.idle);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.success() : this(status: AuthStatus.success);
  const AuthState.error(String msg) : this(status: AuthStatus.error, errorMessage: msg);

  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthController(this._ref) : super(const AuthState.idle());

  get _auth => _ref.read(authServiceProvider);
  get _db => _ref.read(databaseServiceProvider);
  get _storage => _ref.read(secureStorageProvider);

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
        await _afterLogin(user);
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
      state = const AuthState.success();
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapError(e.code));
    } catch (e) {
      state = AuthState.error('Erro no login com Google');
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    await _storage.clear();
    state = const AuthState.idle();
  }

  void resetState() => state = const AuthState.idle();

  Future<void> _afterLogin(User user) async {
    final existing = await _db.getUser(user.uid);

    if (existing == null) {
      final novoUsuario = UsuarioModel(
        email: user.email,
        nome: user.displayName ?? 'Usuário',
        ranking: 'Bronze',
        pontos: 0,
        avatarUrl: user.photoURL ?? '',
        admin: false,
      );
      await _db.saveUser(user.uid, novoUsuario);
      await _storage.saveUser(novoUsuario.toMap());
    } else {
      await _storage.saveUser(existing.toMap());
    }

    _ref.invalidate(userProvider);
  }

  String _mapError(String code) => switch (code) {
    'user-not-found'         => 'Usuário não encontrado',
    'wrong-password'         => 'Senha incorreta',
    'invalid-credential'     => 'Email ou senha incorretos',
    'email-already-in-use'   => 'Este email já está cadastrado',
    'weak-password'          => 'Senha muito fraca',
    'invalid-email'          => 'Email inválido',
    'user-disabled'          => 'Conta desativada',
    'network-request-failed' => 'Sem conexão com a internet',
    'too-many-requests'      => 'Muitas tentativas. Tente novamente mais tarde',
    _                        => 'Erro de autenticação ($code)',
  };
}