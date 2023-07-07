import 'package:flutter/material.dart';
import 'package:statuspage/components/be_cell.dart';
import 'package:statuspage/components/fe_cell.dart';
import 'package:statuspage/components/link_cell.dart';
import 'package:statuspage/components/name_cell.dart';

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
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(2),
          },
          defaultColumnWidth: const FlexColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
              horizontalInside: BorderSide(width: 1, color: Colors.black12, style: BorderStyle.solid)),
          children: [
            TableRow(children: buildHeader()),
            ...buildRows(),
          ],
        ),
      ),
    );
  }

  List<Widget> buildHeader() {
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
          "Link Utili",
        )),
      ),
    ];
  }

  List<TableRow> buildRows() {
    List<TableRow> rows = [];
    widget.projects.forEach((name, info) {
      rows.add(TableRow(children: [
        NameCell(name: name, project: info),
        buildCell("DEV", info),
        buildCell("UAT", info),
        buildCell("PROD", info),
        LinkCell(project: info)
      ], decoration: const BoxDecoration(color: Colors.white)));
    });
    return rows;
  }

  Widget buildCell(env, product) {
    if (product["type"] == "frontend") {
      return FeCell(env: env, project: product);
    } else {
      return BeCell(env: env, project: product);
    }
  }
}
