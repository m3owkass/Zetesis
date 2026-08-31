import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

class EmbedFrame extends StatelessWidget {
  final String url;

  const EmbedFrame({super.key, required this.url});

  static final _registrados = <String>{};

  @override
  Widget build(BuildContext context) {
    final viewType = 'embed-frame-${url.hashCode}';

    if (_registrados.add(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
        return html.IFrameElement()
          ..src = url
          ..style.border = 'none'
          ..allow =
              'autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture'
          ..allowFullscreen = true;
      });
    }

    return HtmlElementView(viewType: viewType);
  }
}
