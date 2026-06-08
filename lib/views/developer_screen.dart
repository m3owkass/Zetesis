import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/services/database_service.dart';
import 'package:zetesis/widgets/components/storage_image.dart';
import 'package:zetesis/widgets/components/storage_upload_button.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  String _status = '';
  bool _loading = false;

  final _db = DatabaseService();

  static const _gruposNomes = [
    'Textos',
    'Músicas',
    'Vídeos',
    'Imagens',
    'Livros',
    'Outros',
  ];

  static const _lojaData = [
    (nome: 'Avatar Filósofo', custo: 100),
    (nome: 'Avatar Sábio', custo: 200),
    (nome: 'Tema Escuro', custo: 150),
    (nome: 'Moldura Dourada', custo: 300),
  ];

  static const _temasData = [
    (nome: 'Existência', descricao: 'Reflexões sobre o ser e o estar no mundo'),
    (
      nome: 'Subjetividade',
      descricao: 'Exploração da identidade e do eu interior',
    ),
    (nome: 'Tempo', descricao: 'A passagem do tempo e suas percepções'),
    (nome: 'Ócio', descricao: 'O valor do descanso e da contemplação'),
  ];

  Future<void> _run(String label, Future<void> Function() fn) async {
    setState(() {
      _loading = true;
      _status = '$label...';
    });
    try {
      await fn();
      setState(() => _status = '$label — concluído ✓');
    } catch (e) {
      setState(() => _status = 'Erro em $label:\n$e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _clearGrupos() => _run('Limpar grupos', () async {
    final grupos = await _db.getAllGruposBiblioteca();
    for (final g in grupos) {
      if (g.id != null) await _db.removeGrupoBiblioteca(g.id!);
    }
  });

  Future<void> _seedGrupos() => _run('Criar grupos', () async {
    for (final nome in _gruposNomes) {
      await _db.addGrupoBiblioteca(
        GrupoBibliotecaModel(nome: nome, descricao: '', assetUrl: ''),
      );
    }
  });

  Future<void> _clearMateriais() => _run('Limpar materiais', () async {
    final materiais = await _db.getAllMateriais();
    for (final m in materiais) {
      if (m.id != null) await _db.removeMaterial(m.id!);
    }
  });

  Future<void> _seedMateriais() =>
      _run('Criar materiais placeholder', () async {
        for (final tipo in _gruposNomes) {
          for (int i = 1; i <= 2; i++) {
            await _db.addMaterial(
              MaterialBibliotecaModel(
                nome: '$tipo — exemplo $i',
                tipo: tipo,
                descricao: 'Conteúdo de exemplo para o grupo $tipo.',
                autor: 'Prof. Exemplo',
                dataEnvio: '01/01/2025',
              ),
            );
          }
        }
      });

  Future<void> _clearLoja() => _run('Limpar loja', () async {
    final items = await _db.getAllItems();
    for (final i in items) {
      if (i.id != null) await _db.removeItem(i.id!);
    }
  });

  Future<void> _seedLoja() => _run('Criar itens da loja', () async {
    for (final d in _lojaData) {
      await _db.addItem(
        ItemLojaModel(nome: d.nome, custo: d.custo, status: true),
      );
    }
  });

  Future<void> _clearTemas() => _run('Limpar temas', () async {
    final temas = await _db.getAllTemas();
    for (final t in temas) {
      if (t.id != null) await _db.removeTema(t.id!);
    }
  });

  Future<void> _seedTemas() => _run('Criar temas', () async {
    for (final t in _temasData) {
      await _db.addTema(
        TemaModel(nome: t.nome, descricao: t.descricao, assetUrl: ''),
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    final gruposAsync = ref.watch(gruposProvider);
    final temasAsync = ref.watch(temasProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Dev — Seed de dados'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_status.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Grupos
          _section('Grupos', [
            _btn('Limpar todos os grupos', Colors.red.shade700, _clearGrupos),
            _btn('Criar grupos padrão', Colors.green.shade700, _seedGrupos),
          ]),

          // Imagens dos grupos
          _section('Imagens — Grupos', [
            gruposAsync.when(
              data: (grupos) => grupos.isEmpty
                  ? const Text(
                      'Nenhum grupo cadastrado.',
                      style: TextStyle(color: Colors.black54),
                    )
                  : Column(
                      children: grupos
                          .map(
                            (g) => _imagemTile(
                              'grupos',
                              g.id ?? '',
                              g.nome,
                              g.assetUrl ?? '',
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) =>
                  Text('Erro: $e', style: const TextStyle(color: Colors.red)),
            ),
          ]),

          // Materiais
          _section('Materiais', [
            _btn(
              'Limpar todos os materiais',
              Colors.red.shade700,
              _clearMateriais,
            ),
            _btn(
              'Criar materiais placeholder (2 por grupo)',
              Colors.green.shade700,
              _seedMateriais,
            ),
          ]),

          // Loja
          _section('Loja', [
            _btn('Limpar todos os itens', Colors.red.shade700, _clearLoja),
            _btn('Criar itens placeholder', Colors.green.shade700, _seedLoja),
          ]),

          // Imagens da loja
          _section('Imagens — Loja', [
            ref
                .watch(itemsProvider)
                .when(
                  data: (items) => items.isEmpty
                      ? const Text(
                          'Nenhum item cadastrado.',
                          style: TextStyle(color: Colors.black54),
                        )
                      : Column(
                          children: items
                              .map(
                                (i) => _imagemTile(
                                  'items',
                                  i.id ?? '',
                                  i.nome,
                                  i.assetUrl ?? '',
                                ),
                              )
                              .toList(),
                        ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Text(
                    'Erro: $e',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
          ]),

          // Temas
          _section('Temas', [
            _btn('Limpar todos os temas', Colors.red.shade700, _clearTemas),
            _btn('Criar temas padrão', Colors.green.shade700, _seedTemas),
          ]),

          // Imagens dos temas
          _section('Imagens — Temas', [
            temasAsync.when(
              data: (temas) => temas.isEmpty
                  ? const Text(
                      'Nenhum tema cadastrado.',
                      style: TextStyle(color: Colors.black54),
                    )
                  : Column(
                      children: temas
                          .map(
                            (t) => _imagemTile(
                              'temas',
                              t.id ?? '',
                              t.nome,
                              t.assetUrl,
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) =>
                  Text('Erro: $e', style: const TextStyle(color: Colors.red)),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _imagemTile(String colecao, String id, String nome, String assetUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 48,
              height: 48,
              child: assetUrl.isNotEmpty
                  ? StorageImage(path: assetUrl, fit: BoxFit.cover)
                  : Container(
                      color: Colors.black12,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: Colors.black38,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(nome)),
          if (id.isNotEmpty)
            StorageUploadButton(
              storagePath: '$colecao/$id',
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
              onUploaded: (path) async {
                if (colecao == 'grupos') {
                  await _db.updateGrupoBiblioteca(id, {'assetUrl': path});
                } else if (colecao == 'temas') {
                  await _db.updateTema(id, {'assetUrl': path});
                } else if (colecao == 'items') {
                  await _db.updateItem(id, {'assetUrl': path});
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.4,
              color: Colors.black54,
            ),
          ),
        ),
        ...children,
        const Divider(height: 32),
      ],
    );
  }

  Widget _btn(String label, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _loading ? null : onPressed,
        child: Text(label),
      ),
    );
  }
}
