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
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _PasswordRecoveryDialogContent(
        parentContext: context,
        initialEmail: initialEmail,
        onRecoverPassword: onRecoverPassword,
        emailRegex: emailRegex,
        title: title,
        cancelLabel: cancelLabel,
        submitLabel: submitLabel,
        successMessage: successMessage,
      ),
    );
  }
}

class _PasswordRecoveryDialogContent extends StatefulWidget {
  final BuildContext parentContext;
  final Future<bool> Function(String email) onRecoverPassword;
  final RegExp emailRegex;
  final String initialEmail;
  final String title;
  final String cancelLabel;
  final String submitLabel;
  final String successMessage;

  const _PasswordRecoveryDialogContent({
    required this.parentContext,
    required this.onRecoverPassword,
    required this.emailRegex,
    required this.initialEmail,
    required this.title,
    required this.cancelLabel,
    required this.submitLabel,
    required this.successMessage,
  });

  @override
  State<_PasswordRecoveryDialogContent> createState() =>
      _PasswordRecoveryDialogContentState();
}

class _PasswordRecoveryDialogContentState
    extends State<_PasswordRecoveryDialogContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final success = await widget.onRecoverPassword(
      _emailController.text.trim(),
    );
    if (!mounted || !widget.parentContext.mounted) return;

    setState(() => _isSubmitting = false);
    if (!success) return;

    final messenger = ScaffoldMessenger.of(widget.parentContext);
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(widget.successMessage)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
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
            if (!widget.emailRegex.hasMatch(trimmed)) {
              return 'Digite um email válido';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.submitLabel),
        ),
      ],
    );
  }
}
