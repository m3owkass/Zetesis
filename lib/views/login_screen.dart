import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/forms/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onCadastroTap});

  final VoidCallback onCadastroTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zetesis',
                style: TextStyle(color: context.colors.onDark, fontSize: 44),
              ),
              Text(
                'Login',
                style: TextStyle(
                  color: context.colors.onDark.withValues(alpha: 0.7),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const LoginForm(),
              Center(
                child: TextButton(
                  onPressed: onCadastroTap,
                  child: RichText(
                    text: TextSpan(
                      text: 'Não tem uma conta? ',
                      style: TextStyle(
                        color: context.colors.onDark.withValues(alpha: 0.6),
                      ),
                      children: [
                        TextSpan(
                          text: 'Cadastre-se',
                          style: TextStyle(
                            color: context.colors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
