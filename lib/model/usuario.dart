class UsuarioModel {
  final String? email;
  final String nome;
  final String ranking;
  final int pontos;
  final String avatarUrl;
  final bool admin;

  UsuarioModel({
    this.email,
    required this.nome,
    required this.ranking,
    required this.pontos,
    required this.avatarUrl,
    required this.admin,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      email: map['email'],
      nome: map['nome'],
      ranking: map['ranking'],
      pontos: map['pontos'],
      avatarUrl: map['avatarUrl'],
      admin: map['admin'] ?? false,
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
    };
  }
}