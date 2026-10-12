import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/bloc/versions/app_state.dart';

class NameCell extends StatelessWidget {
  const NameCell({
    super.key,
    this.project,
  });

  final dynamic project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildName(),
        buildRepoVersion(context),
        buildExtraLabel(context),
      ],
    );
  }

  buildRepoVersion(context) {
    return BlocSelector<AppCubit, AppState, Map<String, String>>(
      selector: (state) => state.repoVersion,
      builder: (context, repoVersion) {
        final version = repoVersion[project['product']];
        if (version == null || version.isEmpty || version == 'ERROR') {
          return const SizedBox.shrink();
        }
        return Tooltip(
          message: version,
          child: Text(
            version,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Tooltip buildName() {
    return Tooltip(
      message: project['name'],
      child: Text(
        project['name'],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildLabelPipe(Map<String, String> project, BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isGithubActions = project['actions'] == 'GHA';
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(project['actions'] ?? 'TODO'),
        backgroundColor: isGithubActions
            ? colors.primaryContainer
            : colors.secondaryContainer,
        labelStyle: TextStyle(
          color: isGithubActions
              ? colors.onPrimaryContainer
              : colors.onSecondaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide.none,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget buildLabelEnv(Map<String, String> project, BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isAks = project['env'] == 'AKS';
    return Chip(
      label: Text(project['env'] ?? 'TODO'),
      backgroundColor:
          isAks ? colors.tertiaryContainer : colors.secondaryContainer,
      labelStyle: TextStyle(
        color: isAks ? colors.onTertiaryContainer : colors.onSecondaryContainer,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
    );
  }

  buildExtraLabel(context) {
    return MediaQuery.of(context).size.width > 450
        ? Row(children: [
            buildLabelEnv(project, context),
            buildLabelPipe(project, context),
          ])
        : const SizedBox.shrink();
  }
}
