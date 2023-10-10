import 'package:flutter/material.dart';
import 'package:statuspage/components/be_cell.dart';
import 'package:statuspage/components/deploy_button.dart';
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

  bool _isHover = false;

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
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          // _isHover = true; TODO disabled for now
        });
      },
      onExit: (event) {
        setState(() {
          _isHover = false;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.20,
              child: NameCell(name: widget.name, project: widget.project)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
              child: Visibility(
                visible: _isHover,
                maintainState: true,
                child: DeployButton(
                  env: "DEV",
                  project: widget.project,
                ),
              )),
          SizedBox(width: MediaQuery.of(context).size.width * 0.10, child: buildCell("DEV", widget.project)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
              child: Visibility(
                visible: _isHover,
                maintainState: true,
                child: DeployButton(
                  env: "UAT",
                  project: widget.project,
                ),
              )),
          SizedBox(width: MediaQuery.of(context).size.width * 0.10, child: buildCell("UAT", widget.project)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
              child: Visibility(
                visible: _isHover,
                maintainState: true,
                child: DeployButton(
                  env: "PROD",
                  project: widget.project,
                ),
              )),
          SizedBox(width: MediaQuery.of(context).size.width * 0.10, child: buildCell("PROD", widget.project)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.10,
            child: LinkCell(project: widget.project),
          )
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
