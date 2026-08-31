import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/anexo.dart';
import 'package:zetesis/widgets/components/attachment_preview.dart';

/// Campo de anexo reutilizável: escolhe um arquivo (imagem, documento ou
/// qualquer um, conforme [tipo]), mostra o preview e permite remover.
///
/// Não faz upload sozinho — devolve o [PickedAttachment] escolhido via
/// [onChanged] (`null` quando removido) pro formulário decidir quando enviar
/// (normalmente depois de salvar o registro, usando o id gerado no caminho
/// de armazenamento). Pra realizar o upload em si, use
/// `storageUploadServiceProvider`.
class AttachmentPicker extends StatefulWidget {
  final TipoAnexo tipo;
  final String label;
  final String? assetUrlExistente;
  final ValueChanged<PickedAttachment?> onChanged;

  const AttachmentPicker({
    super.key,
    this.tipo = TipoAnexo.qualquer,
    this.label = 'Anexo',
    this.assetUrlExistente,
    required this.onChanged,
  });

  @override
  State<AttachmentPicker> createState() => _AttachmentPickerState();
}

class _AttachmentPickerState extends State<AttachmentPicker> {
  PickedAttachment? _novoAnexo;
  bool _removido = false;
  bool _carregando = false;

  Future<void> _selecionar() async {
    setState(() => _carregando = true);
    try {
      final arquivo = await FilePicker.pickFile(
        type: widget.tipo.fileType,
        allowedExtensions: widget.tipo.extensoesPermitidas,
      );
      if (arquivo == null) return;

      final bytes = await arquivo.readAsBytes();
      final anexo = PickedAttachment(fileName: arquivo.name, bytes: bytes);
      setState(() {
        _novoAnexo = anexo;
        _removido = false;
      });
      widget.onChanged(anexo);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _remover() {
    setState(() {
      _novoAnexo = null;
      _removido = true;
    });
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final existeAssetSalvo =
        !_removido &&
        widget.assetUrlExistente != null &&
        widget.assetUrlExistente!.isNotEmpty;
    final existenteVisivel = existeAssetSalvo ? widget.assetUrlExistente : null;
    final temAlgo = _novoAnexo != null || existeAssetSalvo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (temAlgo) ...[
          AttachmentPreview(
            anexo: _novoAnexo,
            assetUrlExistente: existenteVisivel,
            onRemove: _remover,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        OutlinedButton.icon(
          onPressed: _carregando ? null : _selecionar,
          icon: _carregando
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.attach_file),
          label: Text(temAlgo ? 'Trocar arquivo' : 'Selecionar arquivo'),
        ),
      ],
    );
  }
}
