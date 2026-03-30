import 'package:flutter/material.dart';
import 'package:zetesis/widgets/components/custom_formfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&._\-])[A-Za-z\d@$!%*?&._\-]{8,}$',
  );

  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                
                CustomFormField(
                  controller: _emailController,
                  fieldType: FieldType.email,
                  label: "Email",
                  hint: 'exemplo@dominio.com',
                  preffixIcon: Icon(Icons.email, color: Color(0xff4c4666)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite seu email';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Digite um email válido';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomFormField(
                    controller: _passwordController,
                    fieldType: FieldType.password,
                    label: 'Senha',
                    hint: 'Senha segura',
                    preffixIcon: Icon(Icons.lock, color: Color(0xff4c4666)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite uma senha';
                      } else if (!strongPasswordRegex.hasMatch(value)) {
                        return 'Senha deve ter 8+ caracteres, incluir maiúscula e minúscula, número, e símbolo';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width / 2,
                        55,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(14),
                      ),
                    ),
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
