import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuspage/bloc/settings/settings_state.dart';
import 'package:statuspage/constant.dart';
import 'package:statuspage/pages/status_page.dart';

import '../bloc/settings/settings_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 60 * 5),
      (Timer timer) {
        updateData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: getTab(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: const Text("Status Page"),
      actions: <Widget>[
        Padding(
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
        ),
        StreamBuilder(
            stream: asyncPeriodic(const Duration(minutes: 1), (count) async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
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
            }),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                updateData();
              },
              icon: const Icon(Icons.update),
            )),
      ],
    );
  }

  BottomNavigationBar buildBottomBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded), label: "Core"),
        BottomNavigationBarItem(icon: Icon(Icons.account_box), label: "VAS"),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance), label: "TouchPoint"),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  getTab() {
    return IndexedStack(
      index: _selectedIndex,
      children: const <Widget>[
        StatusPage(projects: projectsCore),
        StatusPage(projects: projectsVAS),
        StatusPage(projects: projectsTouchPoint),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Stream<T> asyncPeriodic<T>(Duration period, Future<T> Function(int count) f) {
    return Stream.periodic(period, f).asyncMap((event) async => await event);
  }

  void updateData() {
    emptyCache();
    Navigator.popAndPushNamed(context, '/');
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
