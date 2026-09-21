import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class RankingScreen extends ConsumerWidget {
  const RankingScreen({super.key});

  Color _corRanking(BuildContext context, String ranking) => switch (ranking) {
    'Ouro' => context.colors.star,
    'Prata' => context.colors.textSecondary,
    _ => context.colors.accent,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranking = ref.watch(rankingProvider);
    final uidAtual = ref.watch(authServiceProvider).currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: ranking.isEmpty
          ? const MensagemEstado(
              icon: Icons.military_tech_outlined,
              titulo: 'Ninguém no ranking ainda',
              subtitulo: 'Complete tarefas para aparecer aqui.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: ranking.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final usuario = ranking[index];
                final posicao = index + 1;
                final voceEh = usuario.uid == uidAtual;

                return _LinhaRanking(
                  posicao: posicao,
                  usuario: usuario,
                  destacado: voceEh,
                  cor: _corRanking(context, usuario.ranking),
                );
              },
            ),
    );
  }
}

class _LinhaRanking extends StatelessWidget {
  final int posicao;
  final UsuarioModel usuario;
  final bool destacado;
  final Color cor;

  const _LinhaRanking({
    required this.posicao,
    required this.usuario,
    required this.destacado,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: destacado
            ? context.colors.primary.withValues(alpha: 0.08)
            : context.colors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: destacado ? context.colors.primary : context.colors.border,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$posicao',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.field,
              border: Border.all(color: context.colors.border),
            ),
            child: StorageImage(
              path: usuario.avatarUrl,
              fit: BoxFit.cover,
              placeholder: Text(
                usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : '?',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.primaryDark),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              usuario.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              usuario.ranking,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cor, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${usuario.tarefasConcluidas.length} tarefas',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
