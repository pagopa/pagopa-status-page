import 'dart:convert';

import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statuspage/constant.dart';

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

      return FutureBuilder(
          future: getInfoFE(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            late List<Widget> children;
            if (snapshot.hasData) {
              children = buildOk(snapshot.data);
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
                  children: children,
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


  getInfoFE() async {

    String url = 'https://${project["host"]}';
    if (env == 'DEV') {
      url = url + dns_d;
    }
    if (env == 'UAT') {
      url = url + dns_u;
    }
    if (env == 'PROD') {
      url = url + dns_p;
    }

    var parser = await Chaleno().load(url);
    // TODO react application are javascript dynamic built
    List<Result> results = parser!.getElementsByClassName('.info-box');
    results.map((item) => debugPrint(item.text));
    return "No Data";
  }

}