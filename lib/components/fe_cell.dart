import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:statuspage/bloc/app_cubit.dart';
import 'package:statuspage/bloc/app_state.dart';
import 'package:statuspage/constant.dart';
import 'package:statuspage/utils.dart';

class FeCell extends StatelessWidget {
  const FeCell({
    super.key,
    required this.env,
    this.project,
  });

  final String env;
  final dynamic project;

  @override
  Widget build(BuildContext context) {
    String url = project['product'];
    return FutureBuilder(
        future: getInfoFE(env, url),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          late List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data.contains('.')) {
              children = buildOk(snapshot.data);
            } else {
              children = buildError(snapshot.data);
            }
          } else if (snapshot.hasError) {
            children = buildError(snapshot.error);
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

  TextButton buildReleaseButton(env) {
    if (env == 'UAT') {
      return TextButton(
        onPressed: () {
          print('');
        },
        child: const Text('⬆️ New Releases'),
      );
    }
    if (env == 'PROD') {
      return TextButton(
        onPressed: () {
          print('');
        },
        child: const Text('➡️ Promote'),
      );
    }

    return TextButton(
      onPressed: () {
        print('');
      },
      child: const Text('⏺️ Deploy'),
    );
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
        child: Text('Error: $message'),
      ),
    ];
  }

  List<Widget> buildOk(version) {
    return <Widget>[
      const Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocSelector<AppCubit, AppState, Map<String, String>>(
              selector: (state) {
            return state.repoVersion;
          }, builder: (context, Map<String, String> repoVersion) {
            return buildIcon(repoVersion[project['product']] ?? '', version);
          }),
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
      )
    ];
  }

  Widget buildIcon(String repoVersion, String version) {
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

  getInfoFE(String env, String product) async {
    late String url;
    if (env == 'DEV') {
      url = apim_d + basePath + product;
    }
    if (env == 'UAT') {
      url = apim_u + basePath + product;
    }
    if (env == 'PROD') {
      url = apim_p + basePath + product;
    }
    var key = "${project['product']}-info-$env";
    return remember(key, () async {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return jsonDecode(response.body)['version'] ?? 'No Info Version';
      } else {
        if (response.bodyBytes.isEmpty) {
          return 'Empty Body';
        } else {
          return response.statusCode;
        }
      }
    });
  }
}
