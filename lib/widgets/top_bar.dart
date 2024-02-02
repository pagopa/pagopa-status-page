import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuspage/bloc/settings/settings_state.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/constant.dart';

import '../bloc/settings/settings_cubit.dart';

class TopBar extends AppBar {
  TopBar(
      {Key? key,
      this.withTitle = true,
      this.switchTheme = true,
      this.refresh = true});

  final bool withTitle;
  final bool switchTheme;
  final bool refresh;

  @override
  TopBarState createState() => TopBarState();
}

class TopBarState extends State<TopBar> {
  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: widget.withTitle ? const Text("Status Page") : null,
      actions: <Widget>[
        if (widget.switchTheme) buildSwitchTheme(),
        if (widget.refresh) buildLastUpdate(),
        if (widget.refresh) buildRefresh(),
      ],
    );
  }

  Padding buildSwitchTheme() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Switch(
            value: state.darkTheme,
            onChanged: (value) {
              context.read<SettingsCubit>().toggle();
            },
            thumbIcon: MaterialStateProperty.resolveWith((states) {
              if (!state.darkTheme) {
                return const Icon(Icons.light_mode);
              }
              return const Icon(Icons.dark_mode);
            }),
          );
        },
      ),
    );
  }

  Padding buildRefresh() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IconButton(
          onPressed: () {
            updateData();
          },
          icon: const Icon(Icons.update),
        ));
  }

  StreamBuilder<String?> buildLastUpdate() {
    return StreamBuilder(
        stream: asyncPeriodic(const Duration(minutes: 1), (count) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          return prefs.getString(lastUpdatedKey);
        }),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: Text(
              "Last updated: now",
            ));
          } else {
            final dateTime = DateTime.parse(snapshot.data);
            final now = DateTime.now();

            final timeDifference = now.difference(dateTime);
            return Center(
                child: Text(
              "Last updated: ${timeDifference.inMinutes + 1} minutes ago",
            ));
          }
        });
  }

  Stream<T> asyncPeriodic<T>(Duration period, Future<T> Function(int count) f) {
    return Stream.periodic(period, f).asyncMap((event) async => await event);
  }

  void updateData() {
    emptyCache();
    if (context.mounted) {
      context.read<AppCubit>().empty();
    }
  }

  Future<void> emptyCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    projectsCore.forEach((namespace, value) {
      for (var repo in value) {
        var key1 = "${repo['product']}-info-DEV";
        var key2 = "${repo['product']}-info-UAT";
        var key3 = "${repo['product']}-info-PROD";
        var key4 = "${repo['product']}-release";
        prefs.remove(key1);
        prefs.remove(key2);
        prefs.remove(key3);
        prefs.remove(key4);
      }
    });
    prefs.remove(lastUpdatedKey);
  }
}
