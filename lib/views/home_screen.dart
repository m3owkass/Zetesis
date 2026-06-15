import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/home/circulo_tema.dart';
import 'package:zetesis/widgets/home/convite_primeiro_tema.dart';
import 'package:zetesis/widgets/home/painel_tema.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temaAsync = ref.watch(temaAtualProvider);

    return temaAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) =>
          const Center(child: Text('Não foi possível carregar.')),
      data: (tema) {
        final tarefas = ref.watch(tarefasProvider).valueOrNull ?? [];
        final concluidas =
            ref.watch(userProvider).valueOrNull?.tarefasConcluidas.toSet() ??
            {};
        final feitas = tarefas
            .where((t) => concluidas.contains(t.id ?? t.nome))
            .length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              CirculoTema(tema: tema),
              const SizedBox(height: AppSpacing.md),
              if (tema == null)
                const ConvitePrimeiroTema()
              else
                PainelTema(tema: tema, tarefas: tarefas, feitas: feitas),
            ],
          ),
        );
      },
    );
  }
}
