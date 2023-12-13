import 'package:flutter/material.dart';
import 'package:statuspage/components/info_cell.dart';
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
          Flexible(
              flex: 1, child: InfoCell(env: "DEV", project: widget.project)),
          Flexible(
              flex: 1, child: InfoCell(env: "UAT", project: widget.project)),
          Flexible(
              flex: 1, child: InfoCell(env: "PROD", project: widget.project)),
          MediaQuery.of(context).size.width > 1200
              ? Flexible(flex: 1, child: LinkCell(project: widget.project))
              : Container()
        ],
      ),
    );
  }
}
