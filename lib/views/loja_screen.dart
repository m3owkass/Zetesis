import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/provider/providers.dart';

class LojaScreen extends ConsumerWidget {
  const LojaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: itemsAsync.when(
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _AvatarCard(item: items[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  final ItemLojaModel item;

  const _AvatarCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff8175c8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xffe8ddd8),
            backgroundImage: (item.assetUrl != null && item.assetUrl!.isNotEmpty)
                ? NetworkImage(item.assetUrl!)
                : null,
            child: (item.assetUrl == null || item.assetUrl!.isEmpty)
                ? Text(
                    item.nome.isNotEmpty ? item.nome[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 28, color: Colors.black54),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xff6055a2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xfff0915a),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.diamond, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${item.custo}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
