import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoteWebView extends StatelessWidget {
  String url;
  String directory;
  Completer<WebViewController> _controller;
  Widget Function(String) onNavigate;

  NoteWebView(this.url, this.directory, this._controller, this.onNavigate);

  @override
  Widget build(BuildContext context) {
    return WebView(
          initialUrl: this.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller.complete(controller);
          },
          navigationDelegate: (request) {
            if (request.url.endsWith("\.md") || request.url.endsWith("\.md/")) {
              var path = request.url
                  .replaceFirst("https://", this.directory + "/")
                  .replaceFirst("\.md/", "\.md");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => this.onNavigate(path),
                  ));
            }
            return NavigationDecision.prevent;
          });
  }
}
