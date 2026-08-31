import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/utils/abrir_anexo.dart';
import 'package:zetesis/utils/embed_link.dart';
import 'package:zetesis/widgets/components/embed_frame/embed_frame.dart';

bool get _plataformaSuportaEmbed {
  if (kIsWeb) return true;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

class EmbedPlayer extends StatelessWidget {
  final String url;

  const EmbedPlayer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final info = detectarEmbed(url);

    if (info == null || !_plataformaSuportaEmbed) {
      return OutlinedButton.icon(
        onPressed: () => abrirAnexo(context, url),
        icon: const Icon(Icons.open_in_new),
        label: const Text('Abrir link'),
      );
    }

    final frame = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: EmbedFrame(url: info.embedUrl),
    );

    if (info.alturaFixa != null) {
      return SizedBox(height: info.alturaFixa, child: frame);
    }
    return AspectRatio(aspectRatio: info.aspectRatio ?? 16 / 9, child: frame);
  }
}
