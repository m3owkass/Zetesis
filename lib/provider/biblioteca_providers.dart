import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/provider/repository_providers.dart';
import 'package:zetesis/provider/usuario_providers.dart';

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
final buscaMaterialProvider = StateProvider<String>((ref) => '');

final autoresDoGrupoProvider = Provider<List<String>>((ref) {
  final materiais = ref.watch(materiaisProvider).value ?? const [];
  final autores = materiais
      .map((m) => m.autor)
      .whereType<String>()
      .where((a) => a.trim().isNotEmpty)
      .toSet()
      .toList();
  autores.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return autores;
});

bool _combinaComBusca(MaterialBibliotecaModel m, String busca) {
  if (busca.trim().isEmpty) return true;
  final termo = busca.trim().toLowerCase();
  return m.nome.toLowerCase().contains(termo) ||
      (m.autor ?? '').toLowerCase().contains(termo) ||
      (m.descricao ?? '').toLowerCase().contains(termo);
}

final materiaisFiltradosProvider = Provider<List<MaterialBibliotecaModel>>((
  ref,
) {
  final materiais = ref.watch(materiaisProvider).value ?? const [];
  final favoritos = ref.watch(favoritosProvider).value ?? const {};
  final busca = ref.watch(buscaMaterialProvider);
  final autor = ref.watch(filtroAutorProvider);
  final ordenacao = ref.watch(ordenacaoMaterialProvider);

  final filtrados = materiais
      .where((m) => _combinaComBusca(m, busca))
      .where((m) => autor == null || m.autor == autor)
      .toList();

  final ordenados = ordenarMateriais(filtrados, ordenacao);

  return [
    ...ordenados.where((m) => favoritos.contains(m.id)),
    ...ordenados.where((m) => !favoritos.contains(m.id)),
  ];
});

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
