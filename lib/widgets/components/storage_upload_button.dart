import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zetesis/config/supabase_config.dart';

/// Botão de upload de imagem para o Supabase Storage.
///
/// Exemplo de uso:
/// ```dart
/// StorageUploadButton(
///   storagePath: 'grupos/$id',
///   onUploaded: (path) => db.updateGrupoBiblioteca(id, {'assetUrl': path}),
/// )
/// ```
class StorageUploadButton extends StatefulWidget {
  /// Caminho no bucket onde a imagem será salva (ex: 'grupos/abc123').
  final String storagePath;

  /// Chamado após upload bem-sucedido, recebendo o path salvo.
  final Future<void> Function(String path) onUploaded;

  final String label;
  final IconData icon;
  final ButtonStyle? style;

  const StorageUploadButton({
    super.key,
    required this.storagePath,
    required this.onUploaded,
    this.label = 'Upload',
    this.icon = Icons.upload,
    this.style,
  });

  @override
  State<StorageUploadButton> createState() => _StorageUploadButtonState();
}

class _StorageUploadButtonState extends State<StorageUploadButton> {
  bool _loading = false;

  Future<void> _upload() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _loading = true);
    try {
      final bytes = await picked.readAsBytes();
      await Supabase.instance.client.storage
          .from(supabaseBucket)
          .uploadBinary(
            widget.storagePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );
      await widget.onUploaded(widget.storagePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro no upload: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: widget.style,
      onPressed: _loading ? null : _upload,
      icon: _loading
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(widget.icon, size: 16),
      label: Text(widget.label),
    );
  }
}
