import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/admin/detalhes_dialog.dart';
import 'package:zetesis/widgets/admin/item_lista_admin.dart';
import 'package:zetesis/widgets/admin/usuario_cabecalho.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/confirmar_acao.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class ListaUsuariosScreen extends ConsumerWidget {
  const ListaUsuariosScreen({super.key});

  void _exibirDetalhes(
    BuildContext context,
    WidgetRef ref,
    UsuarioModel usuario,
  ) {
    DetalhesDialog.mostrar(
      context,
      icon: Icons.person_outline,
      cor: AppColors.primary,
      titulo: usuario.nome,
      cabecalho: UsuarioCabecalho(usuario: usuario),
      linhas: [
        DetalheLinha('Email', usuario.email),
        DetalheLinha('Tema atual', usuario.temaAtual),
        DetalheLinha('ID', usuario.uid),
      ],
      acoes: [
        AcaoSecao(
          label: usuario.admin ? 'Remover admin' : 'Tornar admin',
          variant: AppButtonVariant.neutral,
          onPressed: () => _alternarAdmin(context, ref, usuario),
        ),
        AcaoSecao(
          label: 'Excluir',
          variant: AppButtonVariant.danger,
          onPressed: () => _excluir(context, ref, usuario),
        ),
      ],
    );
  }

  Future<void> _alternarAdmin(
    BuildContext context,
    WidgetRef ref,
    UsuarioModel usuario,
  ) async {
    if (usuario.uid == null) return;
    final tornar = !usuario.admin;
    final confirmado = await confirmarAcao(
      context,
      titulo: tornar ? 'Tornar admin?' : 'Remover admin?',
      mensagem: tornar
          ? 'Conceder acesso de administrador a "${usuario.nome}"?'
          : 'Remover o acesso de administrador de "${usuario.nome}"?',
      confirmar: tornar ? 'Tornar admin' : 'Remover',
    );
    if (!confirmado) return;
    if (!context.mounted) return;
    Navigator.pop(context);
    await ref.read(usuarioRepositoryProvider).update(usuario.uid!, {
      'admin': tornar,
    });
  }

  Future<void> _excluir(
    BuildContext context,
    WidgetRef ref,
    UsuarioModel usuario,
  ) async {
    final confirmado = await confirmarAcao(
      context,
      titulo: 'Excluir usuário?',
      mensagem:
          'Tem certeza que deseja excluir "${usuario.nome}"? '
          'Essa ação não pode ser desfeita.',
      confirmar: 'Excluir',
      destrutivo: true,
    );
    if (!confirmado || usuario.uid == null) return;
    if (!context.mounted) return;
    Navigator.pop(context);
    await ref.read(usuarioRepositoryProvider).remove(usuario.uid!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuariosAsync = ref.watch(todosUsuariosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: usuariosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os usuários.',
        ),
        data: (usuarios) {
          if (usuarios.isEmpty) {
            return const MensagemEstado(
              icon: Icons.people_outline,
              titulo: 'Nenhum usuário cadastrado',
              subtitulo: 'Os usuários cadastrados aparecerão aqui.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              final detalhes = [
                usuario.ranking,
                '${usuario.pontos} phatos',
              ].join(' • ');

              return ItemListaAdmin(
                icon: Icons.person_outline,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                cor: AppColors.primary,
                titulo: usuario.nome,
                subtitulo: detalhes,
                onTap: () => _exibirDetalhes(context, ref, usuario),
              );
            },
          );
        },
      ),
    );
  }
}
