import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/anexo.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

/// Mostra o anexo atual de um formulário: um [PickedAttachment] recém
/// selecionado (ainda não enviado) tem prioridade; senão, mostra o que já
/// está salvo em [assetUrlExistente] (resolvido via [StorageImage]).
class AttachmentPreview extends StatelessWidget {
  final PickedAttachment? anexo;
  final String? assetUrlExistente;
  final VoidCallback? onRemove;
  final double altura;

  const AttachmentPreview({
    super.key,
    this.anexo,
    this.assetUrlExistente,
    this.onRemove,
    this.altura = 120,
  });

  @override
  Widget build(BuildContext context) {
    final anexo = this.anexo;
    final existente = assetUrlExistente;

    Widget conteudo;
    String nomeArquivo;

    if (anexo != null) {
      nomeArquivo = anexo.fileName;
      conteudo = anexo.isImagem
          ? Image.memory(anexo.bytes, height: altura, fit: BoxFit.cover)
          : _tileArquivo(context, nomeArquivo);
    } else if (existente != null && existente.isNotEmpty) {
      nomeArquivo = existente.split('/').last;
      conteudo = ehExtensaoDeImagem(existente)
          ? StorageImage(path: existente, height: altura, fit: BoxFit.cover)
          : _tileArquivo(context, nomeArquivo);
    } else {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: conteudo,
        ),
        if (onRemove != null)
          Positioned(
            right: 4,
            top: 4,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _tileArquivo(BuildContext context, String nome) {
    return Container(
      height: altura,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
