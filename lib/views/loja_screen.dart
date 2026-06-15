import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/loja/item_loja_card.dart';
import 'package:zetesis/widgets/loja/saldo_pontos_header.dart';

class LojaScreen extends ConsumerWidget {
  const LojaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    final user = ref.watch(userProvider).valueOrNull;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar a loja.',
        ),
        data: (items) {
          if (items.isEmpty) {
            return const MensagemEstado(
              icon: Icons.storefront,
              titulo: 'A loja está vazia',
              subtitulo: 'Novos itens chegam em breve. Volte mais tarde!',
            );
          }
          return Column(
            children: [
              SaldoPontosHeader(pontos: user?.pontos ?? 0),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) =>
                      ItemLojaCard(item: items[index], user: user),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
