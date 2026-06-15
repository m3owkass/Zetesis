import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/cadastro_screen.dart';
import 'package:zetesis/widgets/forms/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                'Login',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: AppSpacing.lg),
              const LoginForm(),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CadastroScreen()),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Não tem uma conta? ',
                      style: TextStyle(color: Colors.white60),
                      children: [
                        TextSpan(
                          text: 'Cadastre-se',
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
