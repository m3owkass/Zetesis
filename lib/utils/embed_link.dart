enum EmbedProvider { youtube, spotify }

class EmbedInfo {
  final EmbedProvider provider;
  final String embedUrl;
  final double? aspectRatio;
  final double? alturaFixa;

  const EmbedInfo({
    required this.provider,
    required this.embedUrl,
    this.aspectRatio,
    this.alturaFixa,
  });
}

const _tiposSpotifyValidos = ['track', 'album', 'playlist', 'episode', 'show'];

EmbedInfo? detectarEmbed(String? url) {
  if (url == null || url.isEmpty) return null;
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  final host = uri.host.replaceFirst('www.', '').replaceFirst('m.', '');

  if (host == 'youtube.com') {
    final id = uri.queryParameters['v'];
    if (id == null || id.isEmpty) return null;
    return EmbedInfo(
      provider: EmbedProvider.youtube,
      embedUrl: 'https://www.youtube.com/embed/$id',
      aspectRatio: 16 / 9,
    );
  }

  if (host == 'youtu.be') {
    final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    if (id == null || id.isEmpty) return null;
    return EmbedInfo(
      provider: EmbedProvider.youtube,
      embedUrl: 'https://www.youtube.com/embed/$id',
      aspectRatio: 16 / 9,
    );
  }

  if (host == 'open.spotify.com') {
    // O Spotify pode prefixar o caminho com o idioma, ex.: /intl-pt/track/{id}.
    final segmentos = uri.pathSegments;
    final tipoIndex = segmentos.indexWhere(_tiposSpotifyValidos.contains);
    if (tipoIndex == -1 || tipoIndex + 1 >= segmentos.length) return null;

    final tipo = segmentos[tipoIndex];
    final id = segmentos[tipoIndex + 1];
    return EmbedInfo(
      provider: EmbedProvider.spotify,
      embedUrl: 'https://open.spotify.com/embed/$tipo/$id',
      alturaFixa: tipo == 'track' || tipo == 'episode' ? 152 : 352,
    );
  }

  return null;
}
