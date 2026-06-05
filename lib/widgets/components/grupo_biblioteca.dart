import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/views/materialbiblioteca_screen.dart';
import 'package:zetesis/widgets/components/item_card.dart';

class GrupoBiblioteca extends ConsumerWidget {
  final GrupoBibliotecaModel item;

  const GrupoBiblioteca({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemCard(
      imageUrl: item.assetUrl,
      title: item.nome,
      footer: (item.descricao != null && item.descricao!.isNotEmpty)
          ? Text(
              item.descricao!,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () {
        ref.read(grupoSelecionadoProvider.notifier).state = item.nome;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MaterialBibliotecaScreen()),
        );
      },
    );
  }
}
