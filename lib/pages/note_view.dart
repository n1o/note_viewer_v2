import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_viewer/componets/note_web_view.dart';
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
  RenderedNode _node;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _NoteViewerPageState(String path) {
    this._node = RenderedNode(path);
  }

  Widget _onNavigate(String path) {
    return new NoteViewerPage(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this._node.name),
        ),
        body: NoteWebView(this._node.url, this._node.directory, _controller, _onNavigate));
  }
}
