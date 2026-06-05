import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/views/index.dart';
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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Text(e.toString())),
      data: (user) => user != null ? const Index() : const LoginScreen(),
    );
  }
}
