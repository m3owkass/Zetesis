import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbedFrame extends StatefulWidget {
  final String url;

  const EmbedFrame({super.key, required this.url});

  @override
  State<EmbedFrame> createState() => _EmbedFrameState();
}

class _EmbedFrameState extends State<EmbedFrame> {
  late final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(widget.url));

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}
