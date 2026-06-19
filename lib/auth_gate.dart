import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/home_shell.dart';
import 'package:zetesis/views/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    ref.listen<AsyncValue<UsuarioModel?>>(userProvider, (prev, next) {
      final user = next.valueOrNull;
      if (user == null) return;
      if (ref.read(temaSelecionadoProvider) == null) {
        ref.read(temaSelecionadoProvider.notifier).state = user.temaAtual;
      }
    });

    return auth.when(
      loading: () => const _Carregando(),
      error: (_, _) => _Erro(onRetry: () => ref.invalidate(authStateProvider)),
      data: (fbUser) {
        if (fbUser == null) return const LoginScreen();
        final usuario = ref.watch(userProvider);
        return usuario.isLoading ? const _Carregando() : const HomeShell();
      },
    );
  }
}

class _Carregando extends StatelessWidget {
  const _Carregando();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _Erro extends StatelessWidget {
  const _Erro({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Não foi possível conectar. Verifique sua conexão.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onRetry,
                child: const Text('Tentar de novo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
