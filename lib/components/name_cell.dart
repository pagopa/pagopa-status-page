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
        if (repoVersion.isNotEmpty) {
          return Tooltip(
            message: repoVersion[project['product']] ?? '',
            child: Text(
              repoVersion[project['product']] ?? '',
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
        // By default, show a loading spinner.
        return const SizedBox(
            height: 20, width: 20, child: CircularProgressIndicator());
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

  buildLabelPipe(project) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              project['actions'] == 'GHA' ? Colors.black54 : Colors.blue[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            project['actions'] ?? 'TODO',
            style: TextStyle(
                color: project['actions'] == 'GHA'
                    ? Colors.white
                    : Colors.blue[500],
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  buildLabelEnv(project) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            project['env'] == 'AKS' ? Colors.deepPurple[100] : Colors.blue[100],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          project['env'] ?? 'TODO',
          style: TextStyle(
              color: project['env'] == 'AKS'
                  ? Colors.deepPurple[500]
                  : Colors.blue[500],
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  buildExtraLabel(context) {
    return MediaQuery.of(context).size.width > 450
        ? Row(children: [
            buildLabelEnv(project),
            buildLabelPipe(project),
          ])
        : Container();
  }
}
