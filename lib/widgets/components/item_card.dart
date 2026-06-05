import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final Widget? footer;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.footer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.0,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffddd6d2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: Colors.black26,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (footer != null) ...[
                const SizedBox(height: 4),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
