import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/provider/auth_providers.dart';
import 'package:zetesis/provider/repository_providers.dart';

final itemsProvider = StreamProvider<List<ItemLojaModel>>((ref) {
  return ref.read(itemLojaRepositoryProvider).watchAll();
});

enum FiltroTipoLoja { todos, avatar, geral }

enum FiltroPosseLoja { todos, adquiridos, naoAdquiridos }

enum OrdenacaoLoja { padrao, menorPreco, maiorPreco }

final filtroTipoLojaProvider = StateProvider<FiltroTipoLoja>(
  (ref) => FiltroTipoLoja.todos,
);
final filtroPosseLojaProvider = StateProvider<FiltroPosseLoja>(
  (ref) => FiltroPosseLoja.todos,
);
final ordenacaoLojaProvider = StateProvider<OrdenacaoLoja>(
  (ref) => OrdenacaoLoja.padrao,
);

final itensFiltradosProvider = Provider<List<ItemLojaModel>>((ref) {
  final itens = ref.watch(itemsProvider).value ?? const [];
  final user = ref.watch(userProvider).value;
  final tipo = ref.watch(filtroTipoLojaProvider);
  final posse = ref.watch(filtroPosseLojaProvider);
  final ordenacao = ref.watch(ordenacaoLojaProvider);

  final filtrados = itens.where((item) {
    if (tipo == FiltroTipoLoja.avatar && item.tipo != 'avatar') return false;
    if (tipo == FiltroTipoLoja.geral && item.tipo != 'geral') return false;

    final adquirido = user?.comprou(item.id) ?? false;
    if (posse == FiltroPosseLoja.adquiridos && !adquirido) return false;
    if (posse == FiltroPosseLoja.naoAdquiridos && adquirido) return false;

    return true;
  }).toList();

  switch (ordenacao) {
    case OrdenacaoLoja.padrao:
      break;
    case OrdenacaoLoja.menorPreco:
      filtrados.sort((a, b) => a.custo.compareTo(b.custo));
    case OrdenacaoLoja.maiorPreco:
      filtrados.sort((a, b) => b.custo.compareTo(a.custo));
  }

  return filtrados;
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

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(modoEscuroAtivoProvider) ? ThemeMode.dark : ThemeMode.light;
});
