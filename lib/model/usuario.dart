import 'package:zetesis/model/ranking.dart';

class UsuarioModel {
  final String? uid;
  final String? email;
  final String nome;
  final int pontos;
  final int xp;
  final int acertosTotais;
  final int questoesRespondidas;
  final String avatarUrl;
  final bool admin;
  final bool developer;
  final String? temaAtual;
  final bool modoEscuro;

  final List<String> tarefasConcluidas;

  final List<String> itensComprados;

  UsuarioModel({
    this.uid,
    this.email,
    required this.nome,
    required this.pontos,
    this.xp = 0,
    this.acertosTotais = 0,
    this.questoesRespondidas = 0,
    required this.avatarUrl,
    required this.admin,
    this.developer = false,
    this.temaAtual,
    this.modoEscuro = false,
    this.tarefasConcluidas = const [],
    this.itensComprados = const [],
  });

  bool concluiu(String? tarefaId) =>
      tarefaId != null && tarefasConcluidas.contains(tarefaId);

  bool comprou(String? itemId) =>
      itemId != null && itensComprados.contains(itemId);

  double get acuracia =>
      questoesRespondidas == 0 ? 0.0 : acertosTotais / questoesRespondidas;

  String get ranking => rankingTierDe(
    xp: xp,
    acuracia: acuracia,
    questoesRespondidas: questoesRespondidas,
  ).nome;

  factory UsuarioModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return UsuarioModel(
      uid: id ?? map['uid'],
      email: map['email'],
      nome: map['nome'] ?? 'Usuário',
      pontos: (map['pontos'] as num?)?.toInt() ?? 0,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      acertosTotais: (map['acertosTotais'] as num?)?.toInt() ?? 0,
      questoesRespondidas: (map['questoesRespondidas'] as num?)?.toInt() ?? 0,
      avatarUrl: map['avatarUrl'] ?? '',
      admin: map['admin'] ?? false,
      developer: map['developer'] ?? false,
      temaAtual: map['temaAtual'],
      modoEscuro: map['modoEscuro'] ?? false,
      tarefasConcluidas: List<String>.from(
        (map['tarefasConcluidas'] as List? ?? []).whereType<String>(),
      ),
      itensComprados: List<String>.from(
        (map['itensComprados'] as List? ?? []).whereType<String>(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nome': nome,
      'pontos': pontos,
      'xp': xp,
      'acertosTotais': acertosTotais,
      'questoesRespondidas': questoesRespondidas,
      'avatarUrl': avatarUrl,
      'admin': admin,
      'developer': developer,
      'temaAtual': temaAtual,
      'modoEscuro': modoEscuro,
      'tarefasConcluidas': tarefasConcluidas,
      'itensComprados': itensComprados,
    };
  }
}
