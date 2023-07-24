import 'package:flutter/material.dart';
import 'package:statuspage/widgets/row_item.dart';

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
    return buildTable();
  }

  Column buildTable() {
    return Column(
      children: [
        buildHeader(),
        const Divider(
          color: Colors.grey,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: buildRows(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8, top: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.20, child: const Text("Prodotti e Servizi")),
        SizedBox(width: MediaQuery.of(context).size.width * 0.10),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.10,
            child: const Center(
              child: Text(
                "DEV",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        SizedBox(width: MediaQuery.of(context).size.width * 0.10),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.10,
            child: const Center(
              child: Text(
                "UAT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        SizedBox(width: MediaQuery.of(context).size.width * 0.10),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.10,
            child: const Center(
              child: Text(
                "PROD",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.10,
            child: const Center(
              child: Text(
                "Link Utili",
              ),
            ))
      ]),
    );
  }

  List<Widget> buildRows() {
    List<Widget> list = [];
    widget.projects.forEach((name, info) {
      list.add(RowItem(name: name, project: info));
      list.add(const Divider());
    });
    return list;
  }
}
