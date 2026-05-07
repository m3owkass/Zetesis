import 'package:flutter/material.dart';

class PasswordRecoveryDialog {
  PasswordRecoveryDialog._();

  static Future<void> show({
    required BuildContext context,
    required Future<bool> Function(String email) onRecoverPassword,
    required RegExp emailRegex,
    String initialEmail = '',
    String title = 'Recuperar senha',
    String cancelLabel = 'Cancelar',
    String submitLabel = 'Enviar',
    String successMessage =
        'Se o email estiver cadastrado, você receberá um link para redefinir a senha.',
  }) async {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(text: initialEmail);
    var isSubmitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulContext, setState) {
            return AlertDialog(
              title: Text(title),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'exemplo@dominio.com',
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Por favor, digite seu email';
                    }
                    if (!emailRegex.hasMatch(trimmed)) {
                      return 'Digite um email válido';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(cancelLabel),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setState(() => isSubmitting = true);
                          final success = await onRecoverPassword(
                            emailController.text.trim(),
                          );
                          if (!statefulContext.mounted || !context.mounted) {
                            return;
                          }
                          setState(() => isSubmitting = false);

                          if (!success) return;

                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(successMessage)),
                          );
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(submitLabel),
                ),
              ],
            );
          },
        );
      },
    );

    emailController.dispose();
  }
}
