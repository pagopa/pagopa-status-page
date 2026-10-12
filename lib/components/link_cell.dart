import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCell extends StatelessWidget {
  const LinkCell({
    super.key,
    this.project,
  });

  final dynamic project;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final repository = project['repository'] as String;
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          _linkButton(
            context,
            tooltip: 'Repository GitHub',
            icon: const FaIcon(FontAwesomeIcons.githubAlt),
            url: Uri.parse('https://github.com/pagopa/$repository'),
          ),
          _linkButton(
            context,
            tooltip: 'Pipeline di deploy',
            icon: Icon(Icons.rocket_launch, color: colors.tertiary),
            url: Uri.parse(project['pipeline'] as String),
          ),
          _linkButton(
            context,
            tooltip: 'Dashboard Azure',
            icon: Icon(Icons.show_chart, color: colors.primary),
            url: Uri.parse(
              'https://portal.azure.com/#@pagopait.onmicrosoft.com/dashboard/arm/subscriptions/b9fc9419-6097-45fe-9f74-ba0641c91912/resourceGroups/dashboards/providers/Microsoft.Portal/dashboards/pagopa-p-opex_$repository',
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkButton(
    BuildContext context, {
    required String tooltip,
    required Widget icon,
    required Uri url,
  }) {
    return IconButton(
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      icon: icon,
      onPressed: () => launchUrl(url),
    );
  }
}
