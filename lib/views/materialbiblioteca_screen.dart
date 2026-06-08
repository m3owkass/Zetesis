import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/widgets/components/item_biblioteca.dart';

class MaterialBibliotecaScreen extends ConsumerWidget {
  const MaterialBibliotecaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materiaisAsync = ref.watch(materiaisProvider);
    final grupoNome = ref.watch(grupoSelecionadoProvider) ?? 'Materiais';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(grupoNome),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: materiaisAsync.when(
        data: (materiais) {
          final favoritos = ref.watch(favoritosProvider).value ?? {};
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: materiais.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = materiais[index];
              return ItemBiblioteca(
                item: item,
                isFavorito: favoritos.contains(item.id),
                onFavorite: item.id == null
                    ? null
                    : () {
                        final user =
                            ref.read(authStateProvider).value;
                        if (user == null) return;
                        ref.read(databaseServiceProvider).toggleFavorito(
                              user.uid,
                              item.id!,
                              add: !favoritos.contains(item.id),
                            );
                      },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}
