import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NameCell extends StatelessWidget {
  const NameCell({
    super.key,
    this.name,
    this.project,
  });

  final dynamic name;
  final dynamic project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(children: [
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
    );
  }

  buildLabelPipe(project) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: project['actions'] == 'GHA' ? Colors.black54 : Colors.blue[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            project['actions'] ?? 'TODO',
            style: TextStyle(
                color: project['actions'] == 'GHA' ? Colors.white : Colors.blue[500],
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
        color: project['env'] == 'AKS' ? Colors.deepPurple[100] : Colors.blue[100],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          project['env'] ?? 'TODO',
          style: TextStyle(
              color: project['env'] == 'AKS' ? Colors.deepPurple[500] : Colors.blue[500],
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<String> fetchRelease(repository) async {
    final Storage storage = window.sessionStorage;

    var response;
    if (storage['gh_token'] != null) {
      response = await http.get(
        Uri.parse('https://api.github.com/repos/pagopa/$repository/releases/latest'),
        headers: <String, String>{
          'X-GitHub-Api-Version': '2022-11-28',
          'Authorization': 'Bearer ${storage['gh_token']}',
          'Accept': 'application/vnd.github+json'
        },
      ); // there are limitation 60 requests per hour
    } else {
      response = await http.get(Uri.parse(
          'https://api.github.com/repos/pagopa/$repository/releases/latest')); // there are limitation 60 requests per hour
    }
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
