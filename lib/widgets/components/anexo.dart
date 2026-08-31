import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

const _extensoesImagem = ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'];
const _extensoesDocumento = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt', 'xls', 'xlsx'];

enum TipoAnexo { imagem, documento, qualquer }

extension TipoAnexoFiltro on TipoAnexo {
  FileType get fileType => switch (this) {
    TipoAnexo.imagem => FileType.image,
    TipoAnexo.documento => FileType.custom,
    TipoAnexo.qualquer => FileType.any,
  };

  List<String>? get extensoesPermitidas =>
      this == TipoAnexo.documento ? _extensoesDocumento : null;
}

class PickedAttachment {
  final String fileName;
  final Uint8List bytes;

  const PickedAttachment({required this.fileName, required this.bytes});

  bool get isImagem {
    final ext = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
    return _extensoesImagem.contains(ext);
  }
}

bool ehExtensaoDeImagem(String? path) {
  if (path == null || !path.contains('.')) return false;
  return _extensoesImagem.contains(path.split('.').last.toLowerCase());
}
