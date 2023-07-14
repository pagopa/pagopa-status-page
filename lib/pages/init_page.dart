import 'dart:html';

import 'package:flutter/material.dart';
import 'package:statuspage/pages/home_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  InitPageState createState() => InitPageState();
}

class InitPageState extends State<InitPage> {
  final Storage storage = window.localStorage;
  final TextEditingController textController = TextEditingController();

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
    if (storage['gh_token'] != null) {
      return const HomePage();
    } else {
      return buildForm(context);
    }
  }

  Material buildForm(BuildContext context) {
    return Material(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBar(
            title: const Text(
              "Status Page",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Inserisci il tuo PAT Github'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Github Token',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        child: const Text('Continua senza Token'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          storage['gh_token'] = textController.text;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        child: const Text(
                          'Salva Token',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Text('* senza token alcune funzionalità non sono disponibili', style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
