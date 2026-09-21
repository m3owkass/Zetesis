import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/forms/cadastro_form.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key, required this.onLoginTap});

  final VoidCallback onLoginTap;

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
                'Cadastro',
                style: TextStyle(
                  color: context.colors.onDark.withValues(alpha: 0.7),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const CadastroForm(),
              Center(
                child: TextButton(
                  onPressed: onLoginTap,
                  child: RichText(
                    text: TextSpan(
                      text: 'Já tem uma conta? ',
                      style: TextStyle(
                        color: context.colors.onDark.withValues(alpha: 0.6),
                      ),
                      children: [
                        TextSpan(
                          text: 'Faça login',
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
