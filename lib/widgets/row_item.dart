import 'package:flutter/material.dart';
import 'package:statuspage/components/be_cell.dart';
import 'package:statuspage/components/fe_cell.dart';
import 'package:statuspage/components/link_cell.dart';
import 'package:statuspage/components/name_cell.dart';

class RowItem extends StatefulWidget {
  const RowItem({Key? key, required this.name, this.project}) : super(key: key);

  final String name;
  final dynamic project;

  @override
  RowItemState createState() => RowItemState();
}

class RowItemState extends State<RowItem> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: NameCell(name: widget.name, project: widget.project)),
          Flexible(flex: 1, child: buildCell("DEV", widget.project)),
          Flexible(flex: 1, child: buildCell("UAT", widget.project)),
          Flexible(flex: 1, child: buildCell("PROD", widget.project)),
          MediaQuery.of(context).size.width > 1200
              ? Flexible(flex: 1, child: LinkCell(project: widget.project))
              : Container()
        ],
      ),
    );
  }

  Widget buildCell(env, product) {
    if (product["type"] == "frontend") {
      return FeCell(env: env, project: product);
    } else {
      return BeCell(env: env, project: product);
    }
  }
}
