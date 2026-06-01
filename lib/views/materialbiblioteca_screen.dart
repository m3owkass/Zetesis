import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';

class MaterialBibliotecaScreen extends ConsumerWidget {
  final String destino;

  const MaterialBibliotecaScreen({super.key, required this.destino});

  String get _titulo => switch (destino) {
    'texto' => 'Textos',
    'musica' => 'Músicas',
    'video' => 'Vídeos',
    'imagem' => 'Imagens',
    'livro' => 'Livros',
    _ => 'Outros',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materiaisAsync = ref.watch(materiaisProvider(destino));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_titulo),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: materiaisAsync.when(
        data: (materiais) => materiais.isEmpty
            ? const Center(child: Text('Nenhum material disponível'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: materiais.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final m = materiais[index];
                  return ListTile(
                    title: Text(m.nome),
                    subtitle: m.descricao != null ? Text(m.descricao!) : null,
                    trailing: m.url != null
                        ? const Icon(Icons.open_in_new)
                        : null,
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}
