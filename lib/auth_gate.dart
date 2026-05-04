import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/views/index.dart';
import 'package:zetesis/views/login_screen.dart';

import '../provider/providers.dart';


class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return auth.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Text(e.toString())),
      data: (user) {
        if (user != null) {
          return const Index();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}