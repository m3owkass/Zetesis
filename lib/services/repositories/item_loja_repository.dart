import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/services/repositories/base_repository.dart';

class ItemLojaRepository extends BaseRepository<ItemLojaModel> {
  ItemLojaRepository() : super('items');

  @override
  ItemLojaModel fromDoc(String id, Map<String, dynamic> data) =>
      ItemLojaModel.fromMap(data, id: id);

  @override
  Map<String, dynamic> toMap(ItemLojaModel item) => item.toMap();
}
