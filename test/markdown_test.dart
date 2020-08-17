


import 'package:flutter_test/flutter_test.dart';
import 'package:notes_viewer/util/markdown.dart';

void main() {

  final md = MarkdownSanitizer();
  final latex = """\$\$
p(\theta|D) \propto p(D|\theta) p(\theta) \\

p(\theta|D) =  \frac{p(D|\theta)p(\theta)}{p(D)}
\$\$""";

  final latexFixed =  """\$\$
p(\theta|D) \propto p(D|\theta) p(\theta) \\ p(\theta|D) =  \frac{p(D|\theta)p(\theta)}{p(D)}
\$\$""";

  test("Markdown", () {

    final sanitized = md.fixLatex(latex);
    expect(sanitized, latexFixed);
  });
}