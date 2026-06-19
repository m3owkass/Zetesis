import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/provider/auth_providers.dart';
import 'package:zetesis/provider/repository_providers.dart';

final itemsProvider = StreamProvider<List<ItemLojaModel>>((ref) {
  return ref.read(itemLojaRepositoryProvider).watchAll();
});

const kNomeItemTemaEscuro = 'Tema Escuro';

final possuiTemaEscuroProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider).value;
  if (user == null) return false;
  final itens = ref.watch(itemsProvider).value ?? const [];
  return itens.any((i) => i.nome == kNomeItemTemaEscuro && user.comprou(i.id));
});

final modoEscuroAtivoProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider).value;
  return (user?.modoEscuro ?? false) && ref.watch(possuiTemaEscuroProvider);
});
