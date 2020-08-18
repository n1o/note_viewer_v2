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
  String name;
  String directory;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _NoteViewerPageState(String path) {
    this.path = path;
    final file = new File(path);
    final content = file.readAsStringSync();
    final parts = this.path.split("/");
    this.name = parts[parts.length - 1];

    this.directory = parts.sublist(0, parts.length - 1).join("/");
    MarkdownSanitizer mdSanitizer = MarkdownSanitizer(MarkdownSanitizer.fileToBase64);
    final md = markdown.markdownToHtml(mdSanitizer.sanitize(content, path));

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
    <style>
    img{
      max-height:500px;
      max-width:500px;
      height:auto;
      width:auto;
    }
    </style>
    """;
    final contentBase64 = base64Encode(new Utf8Encoder().convert(html));
    url = 'data:text/html;base64,$contentBase64';
  }

  void _actionButton(BuildContext context) {
    // showBottomSheet(context: context, builder: (BuildContext context) => { return Container});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.name),
      ),
      body: WebView(
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
                    builder: (context) => new NoteViewerPage(path),
                  ));
            }
            return NavigationDecision.prevent;
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _actionButton(context),
        child: Icon(Icons.arrow_drop_up),
      ),
    );
  }
}
