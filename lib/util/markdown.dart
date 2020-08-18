import 'dart:convert';
import 'dart:io';

class MarkdownSanitizer {
  RegExp latexSpaceReg = new RegExp(r"\\\n", multiLine: true);
  RegExp linksRegex = new RegExp(r"\[(.+?)\](\((.+\.md)\))", multiLine: true);
  RegExp imageRegexp = new RegExp(r"!\[(.+?)\]\((.+)\)", multiLine: true);

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

  String sanitize(String content, String filePath) {
    var copy = content;
    copy = this.fixLatex(copy);
    copy = this.fixLinks(copy);
    return this.fixImages(copy, filePath);
  }

  static String fileToBase64(String path) {
    final file = new File(path);
    final bytes = file.readAsBytesSync();
    return  "data:image/png;base64,${base64Encode(bytes)}";
  }
}
