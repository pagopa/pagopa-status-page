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
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Material(
          // color: Colors.white,
          child: IconButton(
              tooltip: 'Repository',
              icon: const FaIcon(FontAwesomeIcons.github),
              onPressed: () {
                var url = Uri.parse(
                    'https://github.com/pagopa/${project['repository']}');
                launchUrl(url);
              })),
      Material(
        // color: Colors.white,
        child: IconButton(
            tooltip: 'Deploy pipeline',
            icon: FaIcon(
              FontAwesomeIcons.rocket,
              color: Colors.red[400],
            ),
            onPressed: () {
              var url = Uri.parse('${project['pipeline']}');
              launchUrl(url);
            }),
      ),
      Material(
        // color: Colors.white,
        child: IconButton(
            tooltip: 'Dashboard',
            icon: const FaIcon(
              FontAwesomeIcons.chartLine,
              color: Colors.blue,
            ),
            onPressed: () {
              launch(
                  'https://portal.azure.com/#@pagopait.onmicrosoft.com/dashboard/arm/subscriptions/b9fc9419-6097-45fe-9f74-ba0641c91912/resourceGroups/dashboards/providers/Microsoft.Portal/dashboards/pagopa-p-opex_${project['repository']}');
            }),
      ),
    ]));
  }
}
