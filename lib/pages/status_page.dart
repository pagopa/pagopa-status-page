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
        const Divider(),
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
      padding:
          const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8, top: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Flexible(
            flex: 1, fit: FlexFit.tight, child: Text("Prodotti e Servizi")),
        const Flexible(
          flex: 1,
          child: Center(
            child: Text(
              "DEV",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Flexible(
          flex: 1,
          child: Center(
            child: Text(
              "UAT",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Flexible(
          flex: 1,
          child: Center(
            child: Text(
              "PROD",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        MediaQuery.of(context).size.width > 1200
            ? const Flexible(
                flex: 1,
                child: Center(
                  child: Text(
                    "Link Utili",
                  ),
                ),
              )
            : Container()
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
