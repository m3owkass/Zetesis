import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zetesis/config/supabase_config.dart';

class StorageUploadService {
  const StorageUploadService();

  Future<String> upload({required String path, required Uint8List bytes}) async {
    await Supabase.instance.client.storage
        .from(supabaseBucket)
        .uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: true));
    return path;
  }

  Future<void> remove(String path) async {
    await Supabase.instance.client.storage.from(supabaseBucket).remove([path]);
  }

  String extensaoDe(String fileName) {
    final ponto = fileName.lastIndexOf('.');
    return ponto == -1 ? '' : fileName.substring(ponto);
  }
}
