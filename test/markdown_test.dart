import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:notes_viewer/util/markdown.dart';

void main() {
  final md = MarkdownSanitizer((s) => "base64:$s");
  final latex = """\$\$
p(\theta|D) \propto p(D|\theta) p(\theta) \\

p(\theta|D) =  \frac{p(D|\theta)p(\theta)}{p(D)}
\$\$""";

  final latexFixed = """\$\$
p(\theta|D) \propto p(D|\theta) p(\theta) \\ p(\theta|D) =  \frac{p(D|\theta)p(\theta)}{p(D)}
\$\$""";

  final link = """
The main goal of Bayesian statistics is finding the [posterior distribution](posterior_distribution.md). That is the distribution of parameteres of interest given the data.
""";

  final image = """
* \$P(A,B)\$ this tells us the probability that booth A and B have happend.
* \$p(B)\$ is a normalization constant. (But it has happend)

![Conditional Distribution](../.images/conditional_distribution.png)

Now we can express this the other way:
""";
  test("Math", () {
    final sanitized = md.fixLatex(latex);
    expect(sanitized, latexFixed);
  });

  test("Link", () {
    final sanitized = md.fixLinks(link);
    expect(sanitized.contains("https://posterior_distribution.md"), true);
  });

  test("fix paths", () {
    final filePath = "/var/notes/bayes_rule.md".split("/");
    final relativePath = "../.images/conditional_distribution.png".split("/");

    final path = MarkdownSanitizer.absolutePath(filePath.sublist(0, filePath.length - 1), relativePath);

    expect(path, "/var/.images/conditional_distribution.png");
  });

  test("fix image", () {
    final sanitized = md.fixImages(image, "/var/home/notes/bayes_rule.md");

    sanitized.contains("base64:/var/home/.images/conditional_distribution.png");
  });
}
