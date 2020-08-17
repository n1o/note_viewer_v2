class MarkdownSanitizer {
  RegExp exp = new RegExp(r"\\\n", multiLine: true);

  String fixLatex(String content) {
    var copy = content;
    final matches = exp.allMatches(copy);

    for (final match in matches) {
      copy = copy.replaceAll(match.group(0), "\\ ");
    }

    if (matches.isNotEmpty) {
      return this.fixLatex(copy);
    } else {
      return copy;
    }

  }
}
