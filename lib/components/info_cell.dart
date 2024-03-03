import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/bloc/versions/app_state.dart';
import 'package:statuspage/utils.dart';

class InfoCell extends StatelessWidget {
  const InfoCell({
    super.key,
    required this.env,
    this.project,
  });

  final String env;
  final dynamic project;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
        builder: (BuildContext context, state) {
      late List<Widget> children;
      String? version;
      if (env == 'DEV') {
        version = state.devVersion[project['product']];
      }
      if (env == 'UAT') {
        version = state.uatVersion[project['product']];
      }
      if (env == 'PROD') {
        version = state.prodVersion[project['product']];
      }
      if (version != null) {
        if (version != 'ERROR') {
          if (version.contains('.')) {
            children = buildOk(version, state);
          } else {
            children = buildWarning(version);
          }
        } else {
          children = buildError(version);
        }
      } else {
        children = buildLoading();
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...children,
              // buildReleaseButton(env)
            ],
          ),
        ),
      );
    });
  }

  List<Widget> buildLoading() {
    return const <Widget>[
      SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Awaiting result...'),
      ),
    ];
  }

  List<Widget> buildError(message) {
    return <Widget>[
      const Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
      Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Tooltip(
            message: '$message',
            child: Text(
              '$message',
              overflow: TextOverflow.ellipsis,
            ),
          ))
    ];
  }

  List<Widget> buildWarning(message) {
    return <Widget>[
      const Icon(
        Icons.check_circle_outline,
        color: Colors.lime,
      ),
      Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Tooltip(
            message: '$message',
            child: Text(
              '$message',
              overflow: TextOverflow.ellipsis,
            ),
          ))
    ];
  }

  List<Widget> buildOk(String version, state) {
    return <Widget>[
      const Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildIcon(state.repoVersion[project['product']] ?? '', version),
            Flexible(
              fit: FlexFit.loose,
              child: Tooltip(
                message: '$version',
                child: Text(
                  '$version',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget buildIcon(String repoVersion, String version) {
    repoVersion = repoVersion.replaceFirst('Release ', '');
    if (compareTo(repoVersion, version) == -1) {
      return const Tooltip(
          message: 'versione maggiore rispetto al repository',
          child: Icon(
            Icons.arrow_upward,
            color: Colors.red,
          ));
    }

    if (compareTo(repoVersion, version) == 1) {
      return const Tooltip(
          message: 'versione minore rispetto al repository',
          child: Icon(
            Icons.arrow_downward,
            color: Colors.orange,
          ));
    }
    if (compareTo(repoVersion, version) == 0) {
      return const Padding(
        padding: EdgeInsets.only(right: 2.0),
        child: Tooltip(
          message: 'versione allineata al repository',
          child: Icon(
            FontAwesomeIcons.equals,
            color: Colors.green,
            size: 20,
          ),
        ),
      );
    }
    return Container();
  }
}
