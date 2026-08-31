import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

  static const _formatoPorGrupo = {
    'Textos': FormatoConteudo.texto,
    'Músicas': FormatoConteudo.link,
    'Vídeos': FormatoConteudo.link,
    'Imagens': FormatoConteudo.arquivo,
    'Livros': FormatoConteudo.arquivo,
    'Outros': FormatoConteudo.arquivo,
  };

  static const _assetLocalPorGrupo = {
    'Textos': 'assets/groups/txt.png',
    'Músicas': 'assets/groups/msc.png',
    'Vídeos': 'assets/groups/vdo.png',
    'Imagens': 'assets/groups/img.png',
    'Livros': 'assets/groups/lvr.png',
    'Outros': 'assets/groups/otr.png',
  };

  Future<void> _criarGrupos() => _run('Criar grupos', () async {
    final repo = ref.read(grupoBibliotecaRepositoryProvider);
    final uploadService = ref.read(storageUploadServiceProvider);

    for (final nome in _gruposNomes) {
      final id = await repo.add(
        GrupoBibliotecaModel(
          nome: nome,
          descricao: '',
          assetUrl: '',
          formatoConteudo: _formatoPorGrupo[nome] ?? FormatoConteudo.arquivo,
        ),
      );

      final assetLocal = _assetLocalPorGrupo[nome];
      if (assetLocal == null) continue;

      final bytes = (await rootBundle.load(assetLocal)).buffer.asUint8List();
      final path = 'grupos/$id';
      await uploadService.upload(path: path, bytes: bytes);
      await repo.update(id, {'assetUrl': path});
    }
  });

  static const _materiaisData = [
    (
      tipo: 'Textos',
      nome: 'A Alegoria da Caverna',
      autor: 'Platão',
      dataEnvio: '03/02/2025',
      descricao:
          'Um dos textos fundamentais da filosofia ocidental sobre percepção, ilusão e conhecimento.',
      conteudoTexto:
          'Imagine homens presos desde a infância no fundo de uma caverna, de costas para a entrada, vendo apenas sombras projetadas na parede à sua frente. Para eles, essas sombras são a única realidade que conhecem. Se um deles fosse libertado e conduzido para fora, à luz do sol, sofreria para enxergar — mas, aos poucos, compreenderia que o mundo das sombras era apenas um reflexo distorcido de algo maior. Ao retornar à caverna para contar o que viu, seria recebido com desconfiança pelos que ainda acreditam que as sombras são tudo o que existe.',
      assetUrl: '',
    ),
    (
      tipo: 'Textos',
      nome: 'Sobre a Brevidade da Vida',
      autor: 'Sêneca',
      dataEnvio: '10/02/2025',
      descricao:
          'Uma reflexão estoica sobre o uso do tempo e a diferença entre vida longa e vida bem vivida.',
      conteudoTexto:
          'Não é que tenhamos pouco tempo, mas que desperdiçamos muito dele. A vida é suficientemente longa, e nos foi dada em medida generosa para a realização das maiores coisas, se toda ela for bem investida. Mas quando se dissipa em luxo e negligência, quando não é empregada para nenhum bom propósito, somos finalmente forçados pela última necessidade a perceber que ela passou antes que soubéssemos que estava passando.',
      assetUrl: '',
    ),
    (
      tipo: 'Músicas',
      nome: 'Clair de Lune',
      autor: 'Claude Debussy',
      dataEnvio: '15/02/2025',
      descricao:
          'Peça para piano solo, inspirada no poema homônimo de Paul Verlaine — contemplação e melancolia.',
      conteudoTexto: '',
      assetUrl: 'https://www.youtube.com/results?search_query=Debussy+Clair+de+Lune',
    ),
    (
      tipo: 'Músicas',
      nome: 'Gymnopédie No. 1',
      autor: 'Erik Satie',
      dataEnvio: '18/02/2025',
      descricao:
          'Composição minimalista associada ao ócio contemplativo e à lentidão do tempo.',
      conteudoTexto: '',
      assetUrl:
          'https://www.youtube.com/results?search_query=Erik+Satie+Gymnopedie+No+1',
    ),
    (
      tipo: 'Vídeos',
      nome: 'O que é Filosofia?',
      autor: 'Canal Filosofia Pop',
      dataEnvio: '20/02/2025',
      descricao: 'Introdução acessível aos grandes temas e perguntas da filosofia.',
      conteudoTexto: '',
      assetUrl: 'https://www.youtube.com/results?search_query=o+que+e+filosofia',
    ),
    (
      tipo: 'Vídeos',
      nome: 'A Alegoria da Caverna Explicada',
      autor: 'Canal Filosofia Pop',
      dataEnvio: '22/02/2025',
      descricao:
          'Vídeo explicativo sobre o mito da caverna de Platão e suas interpretações modernas.',
      conteudoTexto: '',
      assetUrl:
          'https://www.youtube.com/results?search_query=alegoria+da+caverna+explicada',
    ),
    (
      tipo: 'Imagens',
      nome: 'Retrato de Sócrates',
      autor: 'Desconhecido',
      dataEnvio: '25/02/2025',
      descricao: 'Representação clássica do filósofo grego Sócrates.',
      conteudoTexto: '',
      assetUrl: 'https://placehold.co/600x400/2b2b2b/f5f5f5.png',
    ),
    (
      tipo: 'Imagens',
      nome: 'Mapa Mental: Estoicismo',
      autor: 'Prof. Exemplo',
      dataEnvio: '27/02/2025',
      descricao: 'Esquema visual com os principais conceitos da escola estoica.',
      conteudoTexto: '',
      assetUrl: 'https://placehold.co/600x400/1c3d5a/f5f5f5.png',
    ),
    (
      tipo: 'Livros',
      nome: 'Meditações',
      autor: 'Marco Aurélio',
      dataEnvio: '01/03/2025',
      descricao:
          'Reflexões pessoais do imperador filósofo sobre virtude, dever e aceitação.',
      conteudoTexto: '',
      assetUrl: 'https://placehold.co/400x600/4a3728/f5f5f5.png',
    ),
    (
      tipo: 'Livros',
      nome: 'Assim Falou Zaratustra',
      autor: 'Friedrich Nietzsche',
      dataEnvio: '03/03/2025',
      descricao:
          'Obra que apresenta conceitos como o eterno retorno e o além-do-homem.',
      conteudoTexto: '',
      assetUrl: 'https://placehold.co/400x600/6b1d1d/f5f5f5.png',
    ),
    (
      tipo: 'Outros',
      nome: 'Roteiro de Estudo — Semana 1',
      autor: 'Prof. Exemplo',
      dataEnvio: '05/03/2025',
      descricao: 'Planejamento semanal de leituras e atividades para a turma.',
      conteudoTexto: '',
      assetUrl: '',
    ),
    (
      tipo: 'Outros',
      nome: 'Infográfico — Correntes Filosóficas',
      autor: 'Prof. Exemplo',
      dataEnvio: '07/03/2025',
      descricao: 'Linha do tempo visual com as principais correntes de pensamento.',
      conteudoTexto: '',
      assetUrl: 'https://placehold.co/800x400/333333/ffffff.png',
    ),
  ];

  Future<void> _limparMateriais() => _run('Limpar materiais', () async {
    final repo = ref.read(materialBibliotecaRepositoryProvider);
    for (final m in await repo.getAll()) {
      if (m.id != null) await repo.remove(m.id!);
    }
  });

  Future<void> _criarMateriais() =>
      _run('Criar materiais placeholder', () async {
        final repo = ref.read(materialBibliotecaRepositoryProvider);
        for (final m in _materiaisData) {
          await repo.add(
            MaterialBibliotecaModel(
              nome: m.nome,
              tipo: m.tipo,
              descricao: m.descricao,
              autor: m.autor,
              dataEnvio: m.dataEnvio,
              enviadoPor: 'Admin Exemplo',
              conteudoTexto: m.conteudoTexto.isEmpty ? null : m.conteudoTexto,
              assetUrl: m.assetUrl.isEmpty ? null : m.assetUrl,
            ),
          );
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
                'Criar materiais de exemplo (com conteúdo, links e imagens)',
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
