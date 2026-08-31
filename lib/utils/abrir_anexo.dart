import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

Future<void> abrirAnexo(BuildContext context, String? assetUrl) async {
  final url = StorageImage.resolveUrl(assetUrl);
  final uri = url == null ? null : Uri.tryParse(url);

  if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o anexo.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}
