import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/views/materialbiblioteca_screen.dart';

class GrupoBiblioteca extends ConsumerStatefulWidget {
  final GrupoBibliotecaModel item;

  const GrupoBiblioteca({super.key, required this.item});

  @override
  ConsumerState<GrupoBiblioteca> createState() => _GrupoBibliotecaState();
}

class _GrupoBibliotecaState extends ConsumerState<GrupoBiblioteca> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final nome = widget.item.nome;
        ref.read(grupoSelecionadoProvider.notifier).state = nome;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MaterialBibliotecaScreen()),
        );
      },
      child: Container(
        width: 160.0,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffddd6d2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.item.assetUrl != null &&
                widget.item.assetUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.item.assetUrl!,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              widget.item.nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.item.descricao ?? '?',
              style: const TextStyle(fontSize: 36, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
