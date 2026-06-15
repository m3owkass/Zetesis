import 'package:flutter/foundation.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/services/repositories/base_repository.dart';

class MaterialBibliotecaRepository
    extends BaseRepository<MaterialBibliotecaModel> {
  MaterialBibliotecaRepository() : super('materiais');

  @override
  MaterialBibliotecaModel fromDoc(String id, Map<String, dynamic> data) =>
      MaterialBibliotecaModel.fromMap(data, id: id);

  @override
  Map<String, dynamic> toMap(MaterialBibliotecaModel item) => item.toMap();

  Future<List<MaterialBibliotecaModel>> getByType(String tipo) async {
    try {
      final snap = await col.where('tipo', isEqualTo: tipo).get();
      return snap.docs.map((d) => fromDoc(d.id, d.data())).toList();
    } catch (e) {
      debugPrint('Erro ao buscar materiais por tipo: $e');
      return [];
    }
  }

  Stream<List<MaterialBibliotecaModel>> watchByType(String tipo) {
    return col
        .where('tipo', isEqualTo: tipo)
        .snapshots()
        .map((s) => s.docs.map((d) => fromDoc(d.id, d.data())).toList());
  }
}
