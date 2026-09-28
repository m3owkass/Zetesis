import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/admin/card_estatistica.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/home/circulo_tema.dart';
import 'package:zetesis/widgets/home/convite_primeiro_tema.dart';
import 'package:zetesis/widgets/home/painel_tema.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final lastTarefa = ref.watch(lastTarefaProvider);

    return userAsync.when(
      data: (user) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  CardEstatistica(
                    icon: Icons.emoji_events_rounded,
                    cor: context.colors.accent,
                    valor: user?.ranking,
                    label: 'Seu Ranking',
                  ),
                  lastTarefa.when(
                    data: (tarefa) => CardEstatistica(
                      icon: Icons.emoji_events_rounded,
                      cor: context.colors.accent,
                      valor: tarefa?.nome,
                      label: 'Última Tarefa Concluída',
                    ),
                    error: (err, _) => Text('oi'),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PainelTema(),
          ],
        ),
      ),
      error: (err, _) => const MensagemEstado.erro(
        subtitulo: 'Não foi possível carregar os temas.',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
