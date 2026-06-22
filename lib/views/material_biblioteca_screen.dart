import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/item_biblioteca.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/components/search_bar.dart';

class MaterialBibliotecaScreen extends ConsumerStatefulWidget {
  const MaterialBibliotecaScreen({super.key});

  @override
  ConsumerState<MaterialBibliotecaScreen> createState() =>
      _MaterialBibliotecaScreenState();
}

class _MaterialBibliotecaScreenState
    extends ConsumerState<MaterialBibliotecaScreen> {
  @override
  Widget build(BuildContext context) {
    final materiaisAsync = ref.watch(materiaisProvider);
    final grupoNome = ref.watch(grupoSelecionadoProvider) ?? 'Materiais';
    final termo = ref.watch(termoBuscaMaterialProvider);
    final ordem = ref.watch(ordenacaoMaterialProvider);
    final filtroAutor = ref.watch(filtroAutorProvider);
    final filtroEnviadoPor = ref.watch(filtroEnviadoPorProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          grupoNome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<OrdenacaoMaterial>(
            icon: const Icon(Icons.sort),
            initialValue: ordem,
            onSelected: (v) =>
                ref.read(ordenacaoMaterialProvider.notifier).state = v,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: OrdenacaoMaterial.recentes,
                child: Text('Mais recentes'),
              ),
              PopupMenuItem(
                value: OrdenacaoMaterial.antigos,
                child: Text('Mais antigos'),
              ),
              PopupMenuItem(
                value: OrdenacaoMaterial.nome,
                child: Text('Nome (A–Z)'),
              ),
              PopupMenuItem(
                value: OrdenacaoMaterial.autor,
                child: Text('Autor (A–Z)'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: CustomSearchBar(
            hint: 'Buscar por nome ou autor...',
            initialValue: termo,
            onBuscar: (v) =>
                ref.read(termoBuscaMaterialProvider.notifier).state = v,
          ),
        ),
      ),
      body: materiaisAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os materiais.',
        ),
        data: (materiais) {
          var lista = filtrarPorTermo<MaterialBibliotecaModel>(
            materiais,
            termo,
            (m) => [m.nome, m.autor, m.descricao],
          );
          if (filtroAutor != null) {
            lista = lista.where((m) => m.autor == filtroAutor).toList();
          }
          if (filtroEnviadoPor != null) {
            lista = lista
                .where((m) => m.enviadoPor == filtroEnviadoPor)
                .toList();
          }
          lista = ordenarMateriais(lista, ordem);

          if (lista.isEmpty) {
            return MensagemEstado(
              icon: termo.isEmpty ? Icons.inbox_outlined : Icons.search_off,
              titulo: termo.isEmpty
                  ? 'Nada por aqui ainda'
                  : 'Nenhum resultado',
              subtitulo: termo.isEmpty
                  ? 'Este grupo não tem materiais no momento.'
                  : 'Tente outro termo de busca.',
            );
          }

          final favoritos = ref.watch(favoritosProvider).value ?? {};
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: lista.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = lista[index];
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
