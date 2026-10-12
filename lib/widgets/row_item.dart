import 'package:flutter/material.dart';
import 'package:statuspage/components/info_cell.dart';
import 'package:statuspage/components/link_cell.dart';
import 'package:statuspage/components/name_cell.dart';

class RowItem extends StatelessWidget {
  const RowItem({Key? key, required this.project}) : super(key: key);

  final Map<String, String> project;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 900) {
      return _buildCompact(context);
    }
    return _buildWide(context);
  }

  Widget _buildCompact(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NameCell(project: project),
            const SizedBox(height: 16),
            Row(
              children: [
                _environmentCell(context, 'DEV'),
                _environmentCell(context, 'UAT'),
                _environmentCell(context, 'PROD'),
              ],
            ),
            const Divider(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: LinkCell(project: project),
            ),
          ],
        ),
      ),
    );
  }

  Widget _environmentCell(BuildContext context, String environment) {
    return Expanded(
      child: Column(
        children: [
          Text(
            environment,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          InfoCell(env: environment, project: project, compact: true),
        ],
      ),
    );
  }

  Widget _buildWide(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: NameCell(project: project)),
          Expanded(child: InfoCell(env: 'DEV', project: project)),
          Expanded(child: InfoCell(env: 'UAT', project: project)),
          Expanded(child: InfoCell(env: 'PROD', project: project)),
          SizedBox(width: 144, child: LinkCell(project: project)),
        ],
      ),
    );
  }
}
