//  P0-SEC-05: Turnstile Widget
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lumina/core/services/turnstile_service.dart';

class TurnstileWidget extends StatefulWidget {
  final Function(String token) onVerified;

  const TurnstileWidget({super.key, required this.onVerified});

  @override
  State<TurnstileWidget> createState() => _TurnstileWidgetState();
}

class _TurnstileWidgetState extends State<TurnstileWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('Turnstile', onMessageReceived: (msg) {
        widget.onVerified(msg.message);
      })
      ..loadHtmlString(_getTurnstileHtml());
  }

  String _getTurnstileHtml() => '''
    <!DOCTYPE html>
    <html>
    <head>
      <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
    </head>
    <body>
      <div class="cf-turnstile" 
           data-sitekey="${TurnstileService.siteKey}"
           data-callback="onVerify"></div>
      <script>
        function onVerify(token) {
          Turnstile.postMessage(token);
        }
      </script>
    </body>
    </html>
  ''';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: WebViewWidget(controller: _controller),
    );
  }
}
