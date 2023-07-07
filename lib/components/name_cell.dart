import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NameCell extends StatelessWidget {
  const NameCell({
    super.key,
    required this.name,
    this.project,
  });

  final String name;
  final dynamic project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              project[''],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            buildLabelEnv(project),
            buildLabelPipe(project),
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
              return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }



  Padding buildLabelPipe(project) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Chip(
          backgroundColor:
          project['actions'] == 'GHA' ? Colors.black54 : Colors.blue[100],
          label: Text(
            project['actions'] ?? 'TODO',
            style: TextStyle(
                color: project['actions'] == 'GHA'
                    ? Colors.white
                    : Colors.blue[500],
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  Padding buildLabelEnv(project) {
    return Padding(
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
                    : Colors.blue[500],
                fontWeight: FontWeight.bold),
          ),
        ));
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
