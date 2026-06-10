import 'package:flutter/material.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/tarefa.dart';

class ItemTarefa extends StatelessWidget {
  final TarefaModel tarefa;
  final bool isSelected;
  final void Function(TarefaModel) onSelect;

  const ItemTarefa({
    super.key,
    required this.tarefa,
    required this.isSelected,
    required this.onSelect    
  });

  @override
  Widget build(BuildContext context) {
    if (tarefa == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: ()=>onSelect(tarefa),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? 
           Color(0xff5f54a0)
           :Color(0xffddd6d2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 56, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [if (tarefa!.nome != null && tarefa!.nome!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      tarefa!.nome!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                  if (tarefa!.descricao != null && tarefa!.descricao!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      tarefa!.descricao!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
