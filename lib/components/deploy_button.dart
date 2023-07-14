import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class DeployButton extends StatefulWidget {
  const DeployButton({Key? key, required this.env, required this.project}) : super(key: key);

  final project;
  final String env;

  @override
  DeployButtonState createState() => DeployButtonState();
}

class DeployButtonState extends State<DeployButton> {
  final Storage storage = window.sessionStorage;

  final StreamController<String> _refreshController = StreamController();
  late Timer _timer;
  bool _loading = false;

  @override
  initState() {
    super.initState();
    _refreshController.add("available");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _refreshController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!_loading) {
              return buildButton();
            } else {
              return const LinearProgressIndicator();
            }
          } else {
            return const SizedBox();
          }
        });
  }

  Widget buildButton() {
    return OutlinedButton.icon(
      onPressed: () {
        if (storage['gh_token'] != null) {
          triggerDeploy();
        } else {
          showAlert();
        }
      },
      label: Text(
        getLabel(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      icon: const FaIcon(
        FontAwesomeIcons.arrowRight,
        color: Colors.white,
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blue),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String getLabel() {
    if (widget.env == "DEV") {
      return 'Deploy';
    } else if (widget.env == "UAT") {
      return 'New Release';
    } else {
      return 'Promote';
    }
  }

  getWorkflow() async {
    dynamic response = await http.get(
      Uri.parse('https://api.github.com/repos/pagopa/${widget.project['repository']}/actions/runs'),
      headers: <String, String>{
        'X-GitHub-Api-Version': '2022-11-28',
        'Authorization': 'Bearer ${storage['gh_token']}',
        'Accept': 'application/vnd.github+json'
      },
    );
    response = jsonDecode(response.body);

    for (var elem in response['workflow_runs']) {
      if (elem['name'] == 'Release And Deploy') {
        if (elem['conclusion'] != null) {
          setState(() {
            _refreshController.add("available");
            _timer.cancel();
            _loading = false;
          });
        }
        break;
      }
    }
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Token Github richiesto'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Per lanciare il deplot è necessario un PAT Github'),
                  Text('Ricarica la pagina e inseriscilo.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  triggerDeploy() async {
    _refreshController.add("loading");
    setState(() {
      _loading = true;
    });

    dynamic response = await http.get(
      Uri.parse('https://api.github.com/repos/pagopa/${widget.project['repository']}/actions/workflows'),
      headers: <String, String>{
        'X-GitHub-Api-Version': '2022-11-28',
        'Authorization': 'Bearer ${storage['gh_token']}',
        'Accept': 'application/vnd.github+json'
      },
    );

    response = jsonDecode(response.body);
    var id = -1;
    for (var elem in response['workflows']) {
      if (elem['name'] == 'Release And Deploy') {
        id = elem['id'];
        break;
      }
    }

    response = await http.post(
      Uri.parse('https://api.github.com/repos/pagopa/${widget.project['repository']}/actions/workflows/$id/dispatches'),
      headers: <String, String>{
        'X-GitHub-Api-Version': '2022-11-28',
        'Authorization': 'Bearer ${storage['gh_token']}',
        'Accept': 'application/vnd.github+json'
      },
      body: jsonEncode({
        'ref': 'main',
        'inputs': {'environment': widget.env.toLowerCase(), 'skip_release': 'true'},
      }),
    );

    setState(() {
      _timer = Timer.periodic(
        const Duration(seconds: 60),
        (Timer timer) {
          getWorkflow();
        },
      );
    });
  }
}
