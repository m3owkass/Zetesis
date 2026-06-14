import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/custom_formfield.dart';

class CadastroForm extends ConsumerStatefulWidget {
  const CadastroForm({super.key});

  @override
  ConsumerState<CadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends ConsumerState<CadastroForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secondPasswordController = TextEditingController();
  final _nomeController = TextEditingController();

  final _strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&._\-])[A-Za-z\d@$!%*?&._\-]{8,}$',
  );

  final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _secondPasswordController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);
    await controller.register(
      _nomeController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.status == next.status) return;
      if (next.hasError && next.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: AppColors.danger,
            ),
          );
          ref.read(authControllerProvider.notifier).resetState();
        });
      } else if (next.status == AuthStatus.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            controller: _emailController,
            fieldType: FieldType.email,
            label: 'Email',
            hint: 'exemplo@dominio.com',
            prefixIcon: const Icon(Icons.email, color: AppColors.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite seu email';
              } else if (!_emailRegex.hasMatch(value)) {
                return 'Digite um email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomFormField(
            controller: _nomeController,
            fieldType: FieldType.username,
            label: 'Nome',
            hint: 'Nome de usuário',
            prefixIcon: const Icon(Icons.person, color: AppColors.primary),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Por favor, digite um nome'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomFormField(
            controller: _passwordController,
            fieldType: FieldType.password,
            label: 'Senha',
            hint: 'Senha segura',
            prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite uma senha';
              } else if (!_strongPasswordRegex.hasMatch(value)) {
                return 'Senha deve ter 8+ caracteres, incluir maiúscula e minúscula, número, e símbolo';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomFormField(
            controller: _secondPasswordController,
            fieldType: FieldType.password,
            label: 'Confirme sua Senha',
            hint: 'Repita a senha',
            prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite uma senha';
              } else if (value != _passwordController.text) {
                return 'As senhas devem ser iguais';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Cadastrar',
            loading: authState.isLoading,
            onPressed: _register,
          ),
        ],
      ),
    );
  }
}
