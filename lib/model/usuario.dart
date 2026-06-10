class UsuarioModel {
  final String? email;
  final String nome;
  final String ranking;
  final int pontos;
  final String avatarUrl;
  final bool admin;
  final bool developer;
  final String? temaAtual;
  final String? tarefaAtual;

  UsuarioModel({
    this.email,
    required this.nome,
    required this.ranking,
    required this.pontos,
    required this.avatarUrl,
    required this.admin,
    this.developer = false,
    this.temaAtual,
    this.tarefaAtual
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      email: map['email'],
      nome: map['nome'],
      ranking: map['ranking'],
      pontos: map['pontos'],
      avatarUrl: map['avatarUrl'],
      admin: map['admin'] ?? false,
      developer: map['developer'] ?? false,
      temaAtual: map['temaAtual'],
      tarefaAtual: map['tarefaAtual']
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
      'tarefaAtual':tarefaAtual,
    };
  }
}