import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/widgets/components/item_loja.dart';

class LojaScreen extends ConsumerWidget {
  const LojaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider); 

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: itemsAsync.when(
        data: (items) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (items.length / 2).ceil(), 
          itemBuilder: (context, index) {
            return Column(
              children: [
                ItemLoja(item: items[index * 2]),
                if (index * 2 + 1 < items.length) 
                  ItemLoja(item: items[index * 2 + 1]),
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
