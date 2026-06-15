import 'package:flutter/material.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/custom_formfield.dart';
import 'package:zetesis/widgets/components/password_recovery_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);
    await controller.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  void _loginGoogle() async {
    await ref.read(authControllerProvider.notifier).loginGoogle();
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
              }
              if (!_emailRegex.hasMatch(value)) {
                return 'Digite um email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomFormField(
            controller: _passwordController,
            fieldType: FieldType.password,
            label: 'Senha',
            hint: 'Sua senha',
            prefixIcon: const Icon(Icons.lock, color: AppColors.primary),

            validator: (value) => (value == null || value.isEmpty)
                ? 'Por favor, digite sua senha'
                : null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: authState.isLoading
                  ? null
                  : _openRecoverPasswordDialog,
              child: const Text('Esqueci minha senha'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Entrar',
            loading: authState.isLoading,
            onPressed: _login,
          ),
          const SizedBox(height: AppSpacing.md),
          _GoogleButton(onPressed: authState.isLoading ? null : _loginGoogle),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(0, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon_google.png', height: 26),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Entrar com Google',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
