import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/password_recovery_dialog.dart';
import 'package:zetesis/widgets/components/pontos_badge.dart';
import 'package:zetesis/widgets/components/storage_image.dart';
import 'package:zetesis/widgets/perfil/avatar_picker_dialog.dart';
import 'package:zetesis/widgets/perfil/campo_perfil.dart';
import 'package:zetesis/widgets/perfil/perfil_chip.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  final _nomeController = TextEditingController();
  bool _editandoNome = false;
  bool _salvando = false;

  final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _openRecoverPasswordDialog(String email) async {
    await PasswordRecoveryDialog.show(
      context: context,
      initialEmail: email,
      emailRegex: _emailRegex,
      onRecoverPassword: (e) =>
          ref.read(authControllerProvider.notifier).recoverPassword(e),
    );
  }

  Future<void> _salvarNome() async {
    final nome = _nomeController.text.trim();
    if (nome.isEmpty) return;
    setState(() => _salvando = true);
    final ok = await ref.read(authControllerProvider.notifier).updateNome(nome);
    if (!mounted) return;
    setState(() {
      _salvando = false;
      _editandoNome = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Nome atualizado!' : 'Não foi possível salvar.'),
        backgroundColor: ok ? context.colors.success : context.colors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final authState = ref.watch(authControllerProvider);
    final possuiTemaEscuro = ref.watch(possuiTemaEscuroProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Perfil')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Erro ao carregar perfil')),
        data: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: user == null
                      ? null
                      : () => AvatarPickerDialog.mostrar(context, user),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: context.colors.field,
                        backgroundImage:
                            StorageImage.resolveUrl(user?.avatarUrl) != null
                            ? NetworkImage(
                                StorageImage.resolveUrl(user!.avatarUrl)!,
                              )
                            : null,
                        child: StorageImage.resolveUrl(user?.avatarUrl) == null
                            ? Text(
                                user?.nome.isNotEmpty == true
                                    ? user!.nome[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: context.colors.primaryDark,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.primary,
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: context.colors.onDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PerfilChip(
                      child: PontosBadge(
                        valor: user?.pontos ?? 0,
                        iconSize: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    PerfilChip.icone(
                      context: context,
                      icon: Icons.military_tech,
                      cor: context.colors.primary,
                      texto: user?.ranking ?? 'Bronze',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                CampoPerfil(
                  label: 'Nome de usuário',
                  child: Row(
                    children: [
                      Expanded(
                        child: _editandoNome
                            ? TextField(
                                controller: _nomeController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                                onSubmitted: (_) => _salvarNome(),
                              )
                            : Text(
                                user?.nome ?? '',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                      ),
                      if (_salvando)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        IconButton(
                          icon: Icon(
                            _editandoNome ? Icons.check : Icons.edit,
                            size: 20,
                            color: context.colors.primary,
                          ),
                          onPressed: () {
                            if (_editandoNome) {
                              _salvarNome();
                            } else {
                              setState(() {
                                _nomeController.text = user?.nome ?? '';
                                _editandoNome = true;
                              });
                            }
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CampoPerfil(
                  label: 'Email',
                  child: Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CampoPerfil(
                  label: 'Tema escuro',
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          possuiTemaEscuro
                              ? 'Ativar tema escuro no app'
                              : 'Compre "Tema Escuro" na loja para desbloquear',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Switch(
                        value: possuiTemaEscuro && (user?.modoEscuro ?? false),
                        onChanged: possuiTemaEscuro
                            ? (ativo) => ref
                                  .read(authControllerProvider.notifier)
                                  .updateModoEscuro(ativo)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Redefinir senha',
                  variant: AppButtonVariant.primary,
                  onPressed: authState.isLoading
                      ? null
                      : () => _openRecoverPasswordDialog(user?.email ?? ''),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Sair',
                  variant: AppButtonVariant.danger,
                  icon: Icons.logout,
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
