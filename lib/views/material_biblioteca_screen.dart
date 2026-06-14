import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/item_biblioteca.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class MaterialBibliotecaScreen extends ConsumerWidget {
  const MaterialBibliotecaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materiaisAsync = ref.watch(materiaisProvider);
    final grupoNome = ref.watch(grupoSelecionadoProvider) ?? 'Materiais';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          grupoNome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: materiaisAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os materiais.',
        ),
        data: (materiais) {
          if (materiais.isEmpty) {
            return const MensagemEstado(
              icon: Icons.inbox_outlined,
              titulo: 'Nada por aqui ainda',
              subtitulo: 'Este grupo não tem materiais no momento.',
            );
          }
          final favoritos = ref.watch(favoritosProvider).value ?? {};
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: materiais.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = materiais[index];
              return ItemBiblioteca(
                item: item,
                isFavorito: favoritos.contains(item.id),
                onFavorite: item.id == null
                    ? null
                    : () {
                        final user = ref.read(authStateProvider).value;
                        if (user == null) return;
                        ref
                            .read(usuarioRepositoryProvider)
                            .toggleFavorito(
                              user.uid,
                              item.id!,
                              add: !favoritos.contains(item.id),
                            );
                      },
              );
            },
          );
        },
      ),
    );
  }
}
