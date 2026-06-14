class UsuarioModel {
  final String? uid;
  final String? email;
  final String nome;
  final String ranking;
  final int pontos;
  final String avatarUrl;
  final bool admin;
  final bool developer;
  final String? temaAtual;

  final List<String> tarefasConcluidas;

  final List<String> itensComprados;

  UsuarioModel({
    this.uid,
    this.email,
    required this.nome,
    required this.ranking,
    required this.pontos,
    required this.avatarUrl,
    required this.admin,
    this.developer = false,
    this.temaAtual,
    this.tarefasConcluidas = const [],
    this.itensComprados = const [],
  });

  bool concluiu(String? tarefaId) =>
      tarefaId != null && tarefasConcluidas.contains(tarefaId);

  bool comprou(String? itemId) =>
      itemId != null && itensComprados.contains(itemId);

  factory UsuarioModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return UsuarioModel(
      uid: id ?? map['uid'],
      email: map['email'],
      nome: map['nome'] ?? 'Usuário',
      ranking: map['ranking'] ?? 'Bronze',
      pontos: (map['pontos'] as num?)?.toInt() ?? 0,
      avatarUrl: map['avatarUrl'] ?? '',
      admin: map['admin'] ?? false,
      developer: map['developer'] ?? false,
      temaAtual: map['temaAtual'],
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
      'ranking': ranking,
      'pontos': pontos,
      'avatarUrl': avatarUrl,
      'admin': admin,
      'developer': developer,
      'temaAtual': temaAtual,
      'tarefasConcluidas': tarefasConcluidas,
      'itensComprados': itensComprados,
    };
  }
}
