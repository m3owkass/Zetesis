List<T> filtrarPorTermo<T>(
  Iterable<T> itens,
  String termo,
  Iterable<String?> Function(T) campos,
) {
  final t = termo.trim().toLowerCase();
  if (t.isEmpty) return itens.toList();
  return itens
      .where(
        (item) => campos(item).any((c) => (c ?? '').toLowerCase().contains(t)),
      )
      .toList();
}
