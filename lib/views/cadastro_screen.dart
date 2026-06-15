import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/login_screen.dart';
import 'package:zetesis/widgets/forms/cadastro_form.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Zetesis',
                style: TextStyle(color: Colors.white, fontSize: 44),
              ),
              const Text(
                'Cadastro',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: AppSpacing.lg),
              const CadastroForm(),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Já tem uma conta? ',
                      style: TextStyle(color: Colors.white60),
                      children: [
                        TextSpan(
                          text: 'Faça login',
                          style: TextStyle(
                            color: AppColors.accent,
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
