import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/widgets/components/appbar.dart';
import 'package:zetesis/widgets/components/password_recovery_dialog.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  late TextEditingController _nomeController;
  final _emailController = TextEditingController();
  bool _editandoNome = false;

  final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  int kill() {
    return 1;
  }

  Future<void> _openRecoverPasswordDialog() async {
    await PasswordRecoveryDialog.show(
      context: context,
      initialEmail: _emailController.text.trim(),
      emailRegex: _emailRegex,
      onRecoverPassword: (email) =>
          ref.read(authControllerProvider.notifier).recoverPassword(email),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomStatefulAppBar(),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erro ao carregar perfil')),
        data: (user) {
          if (_nomeController.text.isEmpty) {
            _nomeController.text = user?.nome ?? '';
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 66,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                (user?.avatarUrl != null &&
                                    user!.avatarUrl.isNotEmpty)
                                ? NetworkImage(user.avatarUrl)
                                : null,
                            child:
                                (user?.avatarUrl == null ||
                                    user!.avatarUrl.isEmpty)
                                ? Text(
                                    user?.nome.isNotEmpty == true
                                        ? user!.nome[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      color: Colors.black,
                                    ),
                                  )
                                : null,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: kill,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8175c8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: Size(
                                    MediaQuery.widthOf(context) * 0.5,
                                    MediaQuery.heightOf(context) * 0.06,
                                  ),
                                ),
                                child: const Text(
                                  'Trocar Ícone',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: kill,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8175c8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: Size(
                                    MediaQuery.widthOf(context) * 0.5,
                                    MediaQuery.heightOf(context) * 0.06,
                                  ),
                                ),
                                child: const Text(
                                  'Remover Ícone',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Nome de Usuário',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe8ddd8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _editandoNome
                                  ? TextField(
                                      controller: _nomeController,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onSubmitted: (_) =>
                                          setState(() => _editandoNome = false),
                                    )
                                  : Text(
                                      _nomeController.text,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () =>
                                  setState(() => _editandoNome = true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe8ddd8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                user?.email ?? '',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : _openRecoverPasswordDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8175c8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(220, 48),
                          ),
                          child: const Text(
                            'Redefinir Senha',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffcbafa2), width: 2),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffef5350),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(0, 48),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .updateNome(_nomeController.text.trim());
                          if (context.mounted) Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff66bb6a),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(0, 48),
                        ),
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
