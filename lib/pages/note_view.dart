import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:notes_viewer/util/markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoteViewerPage extends StatefulWidget {
  String path;

  NoteViewerPage(String path) {
    this.path = path;
  }

  @override
  _NoteViewerPageState createState() => _NoteViewerPageState(this.path);
}

class _NoteViewerPageState extends State<NoteViewerPage> {
  String path;
  String url;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _NoteViewerPageState(String path) {
    MarkdownSanitizer sanitizer = MarkdownSanitizer();
    this.path = path;
    final file = new File(path);
    final content = file.readAsStringSync();

    final md = markdown.markdownToHtml(sanitizer.fixLatex(content));

    final html = """
    <!DOCTYPE html>
    <html>
    <head>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/katex.min.css" integrity="sha384-AfEj0r4/OFrOo5t7NnNe46zW/tFgW6x/bCJG8FqQCEo3+Aro6EYUG4+cU+KJWu/X" crossorigin="anonymous">
      <script defer src="https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/katex.min.js" integrity="sha384-g7c+Jr9ZivxKLnZTDUhnkOnsh30B4H0rpLUpJ4jAIKs4fnJI+sEnkvrMWph2EDg4" crossorigin="anonymous"></script>
      <script defer src="https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/contrib/auto-render.min.js" integrity="sha384-mll67QQFJfxn0IYznZYonOWZ644AWYC+Pt2cHqMaRhXVrursRwvLnLaebdGIlYNa" crossorigin="anonymous" onload="renderMathInElement(document.body, { delimiters: [{ left: '\$\$', right: '\$\$\', display: true }, {left: '\$', right: '\$', display: false }]})"></script>
    </head>
    <body>
     $md
    </body>
    """;
    final contentBase64 = base64Encode(new Utf8Encoder().convert(html));
    url = 'data:text/html;base64,$contentBase64';
  }

  @override
  Widget build(BuildContext context) {
    var parts = this.path.split("/");
    var name = parts[parts.length - 1];

    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: WebView(
            initialUrl: this.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              this._controller.complete(controller);
            },
            navigationDelegate: (request) {
              print(request);
              return NavigationDecision.prevent;
            }));
  }
}
