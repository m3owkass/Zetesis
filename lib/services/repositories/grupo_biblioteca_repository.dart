import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/services/repositories/base_repository.dart';

class GrupoBibliotecaRepository extends BaseRepository<GrupoBibliotecaModel> {
  GrupoBibliotecaRepository() : super('grupos_biblioteca');

  @override
  GrupoBibliotecaModel fromDoc(String id, Map<String, dynamic> data) =>
      GrupoBibliotecaModel.fromMap(data, id: id);

  @override
  Map<String, dynamic> toMap(GrupoBibliotecaModel item) => item.toMap();
}
