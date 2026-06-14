import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/grupo_biblioteca.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class BibliotecaScreen extends ConsumerWidget {
  const BibliotecaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gruposAsync = ref.watch(gruposProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: gruposAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar a biblioteca.',
        ),
        data: (grupos) => grupos.isEmpty
            ? const MensagemEstado(
                icon: Icons.menu_book_outlined,
                titulo: 'Biblioteca vazia',
                subtitulo: 'Os materiais ainda não foram cadastrados.',
              )
            : CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: _Cabecalho()),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppSpacing.md,
                            mainAxisSpacing: AppSpacing.md,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            GrupoBiblioteca(item: grupos[index]),
                        childCount: grupos.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Biblioteca', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Textos, músicas e obras para ir além das tarefas.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
