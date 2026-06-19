import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/provider/repository_providers.dart';

final gruposProvider = StreamProvider<List<GrupoBibliotecaModel>>((ref) {
  return ref.read(grupoBibliotecaRepositoryProvider).watchAll();
});

final grupoSelecionadoProvider = StateProvider<String?>((ref) => null);

final todosMateriaisProvider = StreamProvider<List<MaterialBibliotecaModel>>((
  ref,
) {
  return ref.read(materialBibliotecaRepositoryProvider).watchAll();
});

final materiaisProvider = StreamProvider<List<MaterialBibliotecaModel>>((ref) {
  final tipo = ref.watch(grupoSelecionadoProvider);
  if (tipo == null) return Stream.value([]);
  return ref.read(materialBibliotecaRepositoryProvider).watchByType(tipo);
});

enum OrdenacaoMaterial { recentes, antigos, autor, nome }

final ordenacaoMaterialProvider = StateProvider<OrdenacaoMaterial>(
  (ref) => OrdenacaoMaterial.recentes,
);
final filtroEnviadoPorProvider = StateProvider<String?>((ref) => null);
final filtroAutorProvider = StateProvider<String?>((ref) => null);

DateTime? _parseDataEnvio(String? s) {
  if (s == null) return null;
  final p = s.split('/');
  if (p.length != 3) return null;
  final dia = int.tryParse(p[0]);
  final mes = int.tryParse(p[1]);
  final ano = int.tryParse(p[2]);
  if (dia == null || mes == null || ano == null) return null;
  return DateTime(ano, mes, dia);
}

List<MaterialBibliotecaModel> ordenarMateriais(
  List<MaterialBibliotecaModel> materiais,
  OrdenacaoMaterial ordem,
) {
  final lista = [...materiais];
  switch (ordem) {
    case OrdenacaoMaterial.recentes:
    case OrdenacaoMaterial.antigos:
      lista.sort((a, b) {
        final da = _parseDataEnvio(a.dataEnvio);
        final db = _parseDataEnvio(b.dataEnvio);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return ordem == OrdenacaoMaterial.recentes
            ? db.compareTo(da)
            : da.compareTo(db);
      });
    case OrdenacaoMaterial.autor:
      lista.sort(
        (a, b) => (a.autor ?? '').toLowerCase().compareTo(
          (b.autor ?? '').toLowerCase(),
        ),
      );
    case OrdenacaoMaterial.nome:
      lista.sort(
        (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
      );
  }
  return lista;
}
