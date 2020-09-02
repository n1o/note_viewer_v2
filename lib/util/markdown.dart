import 'dart:convert';
import 'dart:io';
import 'package:markdown/markdown.dart' as markdown;

class RenderedNode {
  String name;
  String _path;
  String directory;
  String url;

  RenderedNode(String path) {
    this._path = path;
    final file = new File(path);
    final content = file.readAsStringSync();
    final parts = this._path.split("/");
    this.name = parts[parts.length - 1];

    this.directory = parts.sublist(0, parts.length - 1).join("/");
    MarkdownSanitizer mdSanitizer =
        MarkdownSanitizer(MarkdownSanitizer.fileToBase64);
    final md = mdSanitizer
        .fixHtml(markdown.markdownToHtml(mdSanitizer.sanitize(content, path)));

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
    this.url = 'data:text/html;base64,$contentBase64';
  }
}

class MarkdownSanitizer {
  RegExp latexSpaceReg = new RegExp(r"\\\n", multiLine: true);
  RegExp linksRegex = new RegExp(r"\[(.+?)\](\((.+\.md)\))", multiLine: true);
  RegExp imageRegexp = new RegExp(r"!\[(.+?)\]\((.+)\)", multiLine: true);
  RegExp emRegex = new RegExp(r"\$\$.+(<em>|</em>).+\$\$", multiLine: true);

  String Function(String) imageLoader;

  MarkdownSanitizer(this.imageLoader);

  String fixImages(String content, String filePath) {
    var copy = content;
    final filePathParts = filePath.split(Platform.pathSeparator);
    final directory = filePathParts.sublist(0, filePathParts.length - 1);

    final matches = imageRegexp.allMatches(content);

    for (final match in matches) {
      final relativeImagePath = match.group(2).split(Platform.pathSeparator);
      final fixedImagePath =
          MarkdownSanitizer.absolutePath(directory, relativeImagePath);
      copy = copy.replaceFirst(match.group(2), imageLoader(fixedImagePath));
    }
    return copy;
  }

  String fixLatex(String content) {
    var copy = content;
    final matches = latexSpaceReg.allMatches(copy);

    for (final match in matches) {
      copy = copy.replaceAll(match.group(0), "\\ ");
    }

    if (matches.isNotEmpty) {
      return this.fixLatex(copy);
    } else {
      return copy;
    }
  }

  static String absolutePath(List<String> filePath, List<String> relativePath) {
    final contentHead = relativePath[0];
    if (contentHead == "..") {
      return absolutePath(
          filePath.sublist(0, filePath.length - 1), relativePath.sublist(1));
    }
    if (contentHead == ".") {
      return absolutePath(filePath, relativePath.sublist(1));
    }

    return [...filePath, ...relativePath].join(Platform.pathSeparator);
  }

  String fixLinks(String content) {
    var copy = content;
    final matches = linksRegex.allMatches(copy);

    for (final match in matches) {
      copy = copy.replaceAll(match.group(3), "https://${match.group(3)}");
    }

    if (matches.isNotEmpty) {
      return this.fixLatex(copy);
    } else {
      return copy;
    }
  }

  String fixHtml(String content) {
    var copy = content;
    final matches = emRegex.allMatches(copy);

    for (final match in matches) {
      final fixedEm =
          match.group(0).replaceAll("<em>", "_").replaceAll("</em>", "_");
      copy = copy.replaceAll(match.group(0), fixedEm);
    }

    return copy.replaceAll("&amp;", "&").replaceAll(" \\ ", "\\\\");
  }

  String sanitize(String content, String filePath) {
    var copy = content;
    copy = this.fixLatex(copy);
    copy = this.fixLinks(copy);
    return this.fixImages(copy, filePath);
  }

  static String fileToBase64(String path) {
    final file = new File(path);
    final bytes = file.readAsBytesSync();
    return "data:image/png;base64,${base64Encode(bytes)}";
  }
}
