import 'dart:convert';
import 'dart:html' as html;

import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statuspage/constant.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key, this.projects}) : super(key: key);

  final dynamic projects;

  @override
  StatusPageState createState() => StatusPageState();
}

class StatusPageState extends State<StatusPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(2),
          },
          defaultColumnWidth: const FlexColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: Colors.black12, style: BorderStyle.solid)),
          children: [
            TableRow(children: buildHeader()),
            ...buildRows(),
            // TODO add other projects
          ],
        ),
      ),
    );
  }

  List<TableRow> buildRows() {
    late String product;
    List<TableRow> rows = [];
    widget.projects.forEach((name, value) {
      rows.add(TableRow(children: [
        buildNameCell(name, value),
        buildCell("DEV", value),
        buildCell("UAT", value),
        buildCell("PROD", value),
        Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton(
              onPressed: () {
                html.window.open(value['pipeline']!, "new tab");
              },
              child:
                  const Text('Deploy', style: TextStyle(color: Colors.white)),
            ))
      ], decoration: const BoxDecoration(color: Colors.white)));
    });
    return rows;
  }

  Padding buildNameCell(name, project) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Chip(
                  backgroundColor: project['env'] == 'AKS'
                      ? Colors.deepPurple[100]
                      : Colors.blue[100],
                  label: Text(
                    project['env'] ?? 'TODO',
                    style: TextStyle(
                        color: project['env'] == 'AKS'
                            ? Colors.deepPurple[500]
                            : Colors.blue[500], fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Chip(
                  backgroundColor: project['actions'] == 'GHA'
                      ? Colors.black54
                      : Colors.blue[100],
                  label: Text(
                    project['actions'] ?? 'TODO',
                    style: TextStyle(
                        color: project['actions'] == 'GHA'
                            ? Colors.white
                            : Colors.blue[500], fontWeight: FontWeight.bold),
                  ),
                )),
          ]),
          FutureBuilder(
            future: fetchRelease(project['repository']),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Last Release: ${snapshot.data!}'),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  buildHeader() {
    return [
      const Padding(
        padding: EdgeInsets.only(left: 32.0),
        child: Text("Prodotti e Servizi"),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "DEV",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "UAT",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "PROD",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "Pipeline",
        )),
      ),
    ];
  }

  Widget buildCell(env, product) {
    if (product["type"] == "frontend") {
      return buildCellFE(env, product);
    } else {
      return buildCellBE(env, product);
    }
  }

  FutureBuilder buildCellFE(env, product) {
    return FutureBuilder(
        future: getInfoFE(env, product),
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

  FutureBuilder<http.Response> buildCellBE(env, product) {
    String url = product['product'];
    return FutureBuilder<http.Response>(
        future: getInfo(env, url),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          late List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data?.statusCode == 200 &&
                snapshot.data!.bodyBytes.isNotEmpty) {
              children = buildOk(jsonDecode(snapshot.data!.body)['version'] ??
                  'No Info Version');
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
                children: children,
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

  getInfoFE(String env, product) async {
    String url = 'https://${product["host"]}';
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

  Future<String> fetchRelease(repository) async {
    var response = await http.get(Uri.parse(
        'https://api.github.com/repos/pagopa/$repository/releases/latest')); // there are limitation 60 requests per hour
    return jsonDecode(response.body)['tag_name'] ?? 'No Release';

    // final webScraper = WebScraper('https://github.com');
    // if (await webScraper.loadWebPage('/pagopa/$repository/releases')) {
    //   List<Map<String, dynamic>> elements =
    //       webScraper.getElement('a.Link--primary', ['href']);
    //   if (elements.isNotEmpty) {
    //     return elements[0]['title'];
    //   }
    // }
    // return "No Release";
  }
}
