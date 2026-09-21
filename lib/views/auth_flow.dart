import 'package:flutter/material.dart';
import 'package:zetesis/views/cadastro_screen.dart';
import 'package:zetesis/views/login_screen.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key});

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool _showCadastro = false;

  @override
  Widget build(BuildContext context) {
    return _showCadastro
        ? CadastroScreen(
            onLoginTap: () => setState(() => _showCadastro = false),
          )
        : LoginScreen(
            onCadastroTap: () => setState(() => _showCadastro = true),
          );
  }
}
