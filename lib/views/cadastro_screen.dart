import 'package:flutter/material.dart';
import 'package:zetesis/views/login_screen.dart';
import 'package:zetesis/widgets/forms/cadastro_form.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.07,
              left: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Zetesis',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: MediaQuery.of(context).size.height * 0.06,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Cadastro',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          const Padding(padding: EdgeInsets.all(8.0), child: CadastroForm()),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            child: RichText(
              text: const TextSpan(
                text: 'Já tem uma conta? ',
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: 'Faça login',
                    style: TextStyle(
                      color: Color(0xff5f54a0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
