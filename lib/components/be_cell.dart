import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statuspage/constant.dart';

class BeCell extends StatelessWidget {
  const BeCell({
    super.key,
    required this.env,
    this.project,
  });

  final String env;
  final dynamic project;

  @override
  Widget build(BuildContext context) {
    String url = project['product'];
    return FutureBuilder<http.Response>(
        future: getInfo(env, url),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          late List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data?.statusCode == 200 && snapshot.data!.bodyBytes.isNotEmpty) {
              children = buildOk(jsonDecode(snapshot.data!.body)['version'] ?? 'No Info Version');
            } else {
              if (snapshot.data!.bodyBytes.isEmpty) {
                children = buildError('Empty Body');
              } else {
                children = buildError(snapshot.data?.statusCode ?? 'Unknown');
              }
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
                children: [...children, buildReleaseButton(env)],
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
        child: Text('⬆️ New Releases'),
      );
    }
    if (env == 'PROD') {
      return TextButton(
        onPressed: () {
          print('');
        },
        child: Text('➡️ Promote'),
      );
    }

    return TextButton(
      onPressed: () {
        print('');
      },
      child: Text('⏺️ Deploy'),
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
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Version: $version'),
      ),
    ];
  }

  getInfo(String env, String product) {
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

    return http.get(Uri.parse(url));
  }
}
