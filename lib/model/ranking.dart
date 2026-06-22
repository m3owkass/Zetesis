class RankingTier {
  final String nome;
  final int xpMinimo;
  final double acuraciaMinima;

  const RankingTier({
    required this.nome,
    required this.xpMinimo,
    required this.acuraciaMinima,
  });
}

const int kQuestoesParaAvaliarAcuracia = 20;

const List<RankingTier> kRankingTiers = [
  RankingTier(nome: 'Espanto', xpMinimo: 0, acuraciaMinima: 0),
  RankingTier(nome: 'Dúvida', xpMinimo: 100, acuraciaMinima: 0.50),
  RankingTier(nome: 'Indagação', xpMinimo: 300, acuraciaMinima: 0.60),
  RankingTier(nome: 'Diálogo', xpMinimo: 700, acuraciaMinima: 0.68),
  RankingTier(nome: 'Reflexão', xpMinimo: 1500, acuraciaMinima: 0.75),
  RankingTier(nome: 'Sabedoria', xpMinimo: 3000, acuraciaMinima: 0.82),
];

RankingTier rankingTierDe({
  required int xp,
  required double acuracia,
  required int questoesRespondidas,
}) {
  final avaliaAcuracia = questoesRespondidas >= kQuestoesParaAvaliarAcuracia;
  for (var i = kRankingTiers.length - 1; i >= 0; i--) {
    final tier = kRankingTiers[i];
    final passaXp = xp >= tier.xpMinimo;
    final passaAcuracia = !avaliaAcuracia || acuracia >= tier.acuraciaMinima;
    if (passaXp && passaAcuracia) return tier;
  }
  return kRankingTiers.first;
}
