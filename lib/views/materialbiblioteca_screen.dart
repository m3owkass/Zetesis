import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/widgets/components/item_biblioteca.dart';

class MaterialBibliotecaScreen extends ConsumerWidget {

  const MaterialBibliotecaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materiaisAsync = ref.watch(materiaisProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: materiaisAsync.when(
        data: (materiais) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: materiais.length,
          itemBuilder: (context, index) => ItemBiblioteca(item: materiais[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}
