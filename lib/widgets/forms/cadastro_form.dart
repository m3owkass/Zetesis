import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
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
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.status == next.status) return;
      if (next.hasError && next.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red.shade700,
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
                  label: "Email",
                  hint: 'exemplo@dominio.com',
                  prefixIcon: const Icon(Icons.email, color: Color(0xff4c4666)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite seu email';
                    } else if (!_emailRegex.hasMatch(value)) {
                      return 'Digite um email válido';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomFormField(
                    controller: _nomeController,
                    fieldType: FieldType.username,
                    label: 'Nome',
                    hint: 'Nome de usuário',
                    prefixIcon: const Icon(Icons.person, color: Color(0xff4c4666)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite um nome';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomFormField(
                    controller: _passwordController,
                    fieldType: FieldType.password,
                    label: 'Senha',
                    hint: 'Senha segura',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xff4c4666)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite uma senha';
                      } else if (!_strongPasswordRegex.hasMatch(value)) {
                        return 'Senha deve ter 8+ caracteres, incluir maiúscula e minúscula, número, e símbolo';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomFormField(
                    controller: _secondPasswordController,
                    fieldType: FieldType.password,
                    label: 'Confirme sua Senha',
                    hint: 'Senha segura',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xff4c4666)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite uma senha';
                      } else if (!(value == _passwordController.text)) {
                        return 'as senhas devem ser iguais';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width / 1.5,
                        MediaQuery.of(context).size.height / 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(14),
                      ),
                    ),
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.027,
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
