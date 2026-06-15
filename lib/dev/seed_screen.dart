import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/dev/seed_tarefas.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/services/repositories/base_repository.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/storage_image.dart';
import 'package:zetesis/widgets/components/storage_upload_button.dart';

class SeedScreen extends ConsumerStatefulWidget {
  const SeedScreen({super.key});

  @override
  ConsumerState<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends ConsumerState<SeedScreen> {
  String _status = '';
  bool _loading = false;

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

  Future<void> _limparGrupos() => _run('Limpar grupos', () async {
    final repo = ref.read(grupoBibliotecaRepositoryProvider);
    for (final g in await repo.getAll()) {
      if (g.id != null) await repo.remove(g.id!);
    }
  });

  Future<void> _criarGrupos() => _run('Criar grupos', () async {
    final repo = ref.read(grupoBibliotecaRepositoryProvider);
    for (final nome in _gruposNomes) {
      await repo.add(
        GrupoBibliotecaModel(nome: nome, descricao: '', assetUrl: ''),
      );
    }
  });

  Future<void> _limparMateriais() => _run('Limpar materiais', () async {
    final repo = ref.read(materialBibliotecaRepositoryProvider);
    for (final m in await repo.getAll()) {
      if (m.id != null) await repo.remove(m.id!);
    }
  });

  Future<void> _criarMateriais() =>
      _run('Criar materiais placeholder', () async {
        final repo = ref.read(materialBibliotecaRepositoryProvider);
        for (final tipo in _gruposNomes) {
          for (var i = 1; i <= 2; i++) {
            await repo.add(
              MaterialBibliotecaModel(
                nome: '$tipo — exemplo $i',
                tipo: tipo,
                descricao: 'Conteúdo de exemplo para o grupo $tipo.',
                autor: 'Prof. Exemplo',
                dataEnvio: '01/01/2025',
                enviadoPor: 'Admin Exemplo',
              ),
            );
          }
        }
      });

  Future<void> _limparLoja() => _run('Limpar loja', () async {
    final repo = ref.read(itemLojaRepositoryProvider);
    for (final i in await repo.getAll()) {
      if (i.id != null) await repo.remove(i.id!);
    }
  });

  Future<void> _criarLoja() => _run('Criar itens da loja', () async {
    final repo = ref.read(itemLojaRepositoryProvider);
    for (final d in _lojaData) {
      await repo.add(ItemLojaModel(nome: d.nome, custo: d.custo, status: true));
    }
  });

  Future<void> _limparTemas() => _run('Limpar temas', () async {
    final repo = ref.read(temaRepositoryProvider);
    for (final t in await repo.getAll()) {
      if (t.id != null) await repo.remove(t.id!);
    }
  });

  Future<void> _criarTemas() => _run('Criar temas', () async {
    final repo = ref.read(temaRepositoryProvider);
    for (final t in _temasData) {
      await repo.add(
        TemaModel(nome: t.nome, descricao: t.descricao, assetUrl: ''),
      );
    }
  });

  Future<void> _limparTarefas() => _run('Limpar tarefas', () async {
    final repo = ref.read(tarefaRepositoryProvider);
    for (final t in await repo.getAll()) {
      if (t.id != null) await repo.remove(t.id!);
    }
  });

  Future<void> _criarTarefas() => _run('Criar tarefas', () async {
    final repo = ref.read(tarefaRepositoryProvider);
    for (final t in SeedTarefas.tarefas) {
      await repo.add(t);
    }
  });

  Future<void> _salvarImagem(String colecao, String id, String path) {
    final BaseRepository repo = switch (colecao) {
      'grupos' => ref.read(grupoBibliotecaRepositoryProvider),
      'temas' => ref.read(temaRepositoryProvider),
      _ => ref.read(itemLojaRepositoryProvider),
    };
    return repo.update(id, {'assetUrl': path});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev — Seed de dados')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (_status.isNotEmpty) ...[
            _StatusPainel(status: _status),
            const SizedBox(height: AppSpacing.md),
          ],
          _Secao(
            titulo: 'Grupos',
            children: [
              _acao(
                'Limpar todos os grupos',
                AppButtonVariant.danger,
                _limparGrupos,
              ),
              _acao(
                'Criar grupos padrão',
                AppButtonVariant.success,
                _criarGrupos,
              ),
            ],
          ),
          _Secao(
            titulo: 'Imagens — Grupos',
            children: [
              _listaImagens(
                ref.watch(gruposProvider),
                'grupos',
                (GrupoBibliotecaModel g) =>
                    (id: g.id, nome: g.nome, assetUrl: g.assetUrl ?? ''),
              ),
            ],
          ),
          _Secao(
            titulo: 'Materiais',
            children: [
              _acao(
                'Limpar todos os materiais',
                AppButtonVariant.danger,
                _limparMateriais,
              ),
              _acao(
                'Criar materiais placeholder (2 por grupo)',
                AppButtonVariant.success,
                _criarMateriais,
              ),
            ],
          ),
          _Secao(
            titulo: 'Loja',
            children: [
              _acao(
                'Limpar todos os itens',
                AppButtonVariant.danger,
                _limparLoja,
              ),
              _acao(
                'Criar itens placeholder',
                AppButtonVariant.success,
                _criarLoja,
              ),
            ],
          ),
          _Secao(
            titulo: 'Imagens — Loja',
            children: [
              _listaImagens(
                ref.watch(itemsProvider),
                'items',
                (ItemLojaModel i) =>
                    (id: i.id, nome: i.nome, assetUrl: i.assetUrl ?? ''),
              ),
            ],
          ),
          _Secao(
            titulo: 'Tarefas — perguntas e respostas',
            children: [
              _acao(
                'Limpar todas as tarefas',
                AppButtonVariant.danger,
                _limparTarefas,
              ),
              _acao(
                'Criar tarefas (2 por tema, modalidades mistas)',
                AppButtonVariant.success,
                _criarTarefas,
              ),
            ],
          ),
          _Secao(
            titulo: 'Temas',
            children: [
              _acao(
                'Limpar todos os temas',
                AppButtonVariant.danger,
                _limparTemas,
              ),
              _acao(
                'Criar temas padrão',
                AppButtonVariant.success,
                _criarTemas,
              ),
            ],
          ),
          _Secao(
            titulo: 'Imagens — Temas',
            children: [
              _listaImagens(
                ref.watch(temasProvider),
                'temas',
                (TemaModel t) => (id: t.id, nome: t.nome, assetUrl: t.assetUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _acao(String label, AppButtonVariant variant, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppButton(
        label: label,
        variant: variant,
        height: 44,
        onPressed: _loading ? null : onPressed,
      ),
    );
  }

  Widget _listaImagens<T>(
    AsyncValue<List<T>> async,
    String colecao,
    ({String? id, String nome, String assetUrl}) Function(T) dados,
  ) {
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) =>
          Text('Erro: $e', style: const TextStyle(color: AppColors.danger)),
      data: (itens) => itens.isEmpty
          ? Text(
              'Nada cadastrado.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          : Column(
              children: [
                for (final item in itens.map(dados))
                  _ImagemTile(
                    nome: item.nome,
                    assetUrl: item.assetUrl,
                    storagePath: '$colecao/${item.id ?? ''}',
                    habilitado: item.id != null,
                    onUploaded: (path) =>
                        _salvarImagem(colecao, item.id!, path),
                  ),
              ],
            ),
    );
  }
}

class _StatusPainel extends StatelessWidget {
  final String status;

  const _StatusPainel({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        status,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const _Secao({required this.titulo, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            titulo.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...children,
        const Divider(height: AppSpacing.lg + AppSpacing.sm),
      ],
    );
  }
}

class _ImagemTile extends StatelessWidget {
  final String nome;
  final String assetUrl;
  final String storagePath;
  final bool habilitado;
  final Future<void> Function(String path) onUploaded;

  const _ImagemTile({
    required this.nome,
    required this.assetUrl,
    required this.storagePath,
    required this.habilitado,
    required this.onUploaded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
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
                      color: AppColors.field,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: AppColors.hint,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(child: Text(nome)),
          if (habilitado)
            StorageUploadButton(
              storagePath: storagePath,
              onUploaded: onUploaded,
            ),
        ],
      ),
    );
  }
}
