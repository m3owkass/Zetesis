import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/widgets/components/item_tema.dart';

class SelecaoTema extends ConsumerWidget {
  const SelecaoTema({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temasAsync = ref.watch(temasProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: temasAsync.when(
        data: (temas) => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: (temas.length / 2).ceil(),
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ItemTema(tema: temas[index * 2]),
                if (index * 2 + 1 < temas.length)
                  ItemTema(tema: temas[index * 2 + 1]),
              ],
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
