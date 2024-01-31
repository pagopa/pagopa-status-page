import 'package:flutter/material.dart';
import 'package:statuspage/widgets/row_item.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key, this.projects}) : super(key: key);

  final dynamic projects;

  @override
  StatusPageState createState() => StatusPageState();
}

class StatusPageState extends State<StatusPage> {
  final Map<String, bool> _data = {};

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
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  Map<String, List> aux = widget.projects;
                  int i = 0;
                  for (var m in aux.entries) {
                    if (index == i) {
                      setState(() {
                        _data[m.key] = isExpanded;
                      });
                      break;
                    }
                    i++;
                  }
                },
                children: buildAccordions(),
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
      list.add(RowItem(project: info));
      list.add(const Divider());
    });
    return list;
  }

  List<ExpansionPanel> buildAccordions() {
    List<ExpansionPanel> list = [];
    widget.projects.forEach((namespace, List<dynamic> elements) {
      list.add(ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(namespace),
            );
          },
          canTapOnHeader: true,
          body: Column(
            children: <Widget>[
              ...elements.map((elem) => RowItem(project: elem))
            ],
          ),
          isExpanded: _data[namespace] ?? false));
    });
    return list;
  }
}
