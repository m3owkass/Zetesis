import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zetesis/config/supabase_config.dart';

class StorageImage extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  const StorageImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  /// Converte path curto em URL pública do Supabase
  /// Se já for uma URL completa, retorna direto
  static String? resolveUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '$supabaseUrl/storage/v1/object/public/$supabaseBucket/$path';
  }

  @override
  Widget build(BuildContext context) {
    final url = resolveUrl(path);
    final fallback =
        placeholder ??
        const Center(child: Icon(Icons.image_outlined, color: Colors.white38));

    if (url == null) return fallback;

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => fallback,
      errorWidget: (_, _, _) => fallback,
    );
  }
}
