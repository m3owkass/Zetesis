import 'package:flutter/material.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/widgets/components/custom_formfield.dart';
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
  final _strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&._\-])[A-Za-z\d@$!%*?&._\-]{8,}$',
  );

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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.hasError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade700,
          ),
        );
        ref.read(authControllerProvider.notifier).resetState();
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                CustomFormField(
                  controller: _emailController,
                  fieldType: FieldType.email,
                  label: 'Email',
                  hint: 'exemplo@dominio.com',
                  preffixIcon: const Icon(Icons.email, color: Color(0xff4c4666)),
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
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomFormField(
                    controller: _passwordController,
                    fieldType: FieldType.password,
                    label: 'Senha',
                    hint: 'Senha segura',
                    preffixIcon: const Icon(Icons.lock, color: Color(0xff4c4666)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite uma senha';
                      }
                      if (!_strongPasswordRegex.hasMatch(value)) {
                        return 'Senha deve ter 8+ caracteres, maiúscula, minúscula, número e símbolo';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width / 1.5,
                        MediaQuery.of(context).size.height / 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Entrar',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: MediaQuery.of(context).size.height * 0.027,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _loginGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(0, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon_google.png', height: 32),
                        const SizedBox(width: 12),
                        const Text(
                          'Entrar com Google',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
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