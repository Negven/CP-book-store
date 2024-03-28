

import 'package:client/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';


class UniversalMarkdown extends StatelessWidget {

  final String data;
  final double? maxHeight;
  const UniversalMarkdown(this.data, {super.key, this.maxHeight });

  @override
  Widget build(BuildContext context) {

    onTapLink(text, url, title){
      launchUrl(Uri.parse(url));
    }

    if (maxHeight != null) {
      return Container(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: Markdown(data: data, styleSheet: context.styles.markdown, onTapLink: onTapLink), // Scrollable markdown
      );
    } else {
      return MarkdownBody(data: data, styleSheet: context.styles.markdown, onTapLink: onTapLink); // Non-scrollable markdown
    }

  }


}