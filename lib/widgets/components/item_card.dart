import 'package:flutter/material.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

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
        decoration: BoxDecoration(
          color: const Color(0xffddd6d2),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox.expand(
                child: StorageImage(
                  path: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 48, color: Colors.black26),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
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
          ],
        ),
      ),
    );
  }
}
