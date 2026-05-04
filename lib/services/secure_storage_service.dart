import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  const SecureStorageService();

  static const _storage = FlutterSecureStorage();

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: 'user', value: jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final data = await _storage.read(key: 'user');
    if (data == null) return null;
    return jsonDecode(data);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}