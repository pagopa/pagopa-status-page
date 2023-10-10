import 'dart:async';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:statuspage/constant.dart';
import 'package:statuspage/pages/status_page.dart';

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

  void emptyCache() {
    projectsCore.forEach((name, info) {
      var key1 = "${info['product']}-info-DEV";
      var key2 = "${info['product']}-info-UAT";
      var key3 = "${info['product']}-info-PROD";
      var key4 = "${info['product']}-release";
      DeleteCache.deleteKey(key1);
      DeleteCache.deleteKey(key2);
      DeleteCache.deleteKey(key3);
      DeleteCache.deleteKey(key4);
      DeleteCache.deleteKey(lastUpdatedKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          "Status Page",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          StreamBuilder(
              stream: asyncPeriodic(const Duration(minutes: 1), (count) => ReadCache.getString(key: lastUpdatedKey)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text(
                    "Last updated: now",
                    style: TextStyle(color: Colors.white.withAlpha(200)),
                  ));
                } else {
                  final dateTime = DateTime.parse(snapshot.data);
                  final now = DateTime.now();

                  final timeDifference = now.difference(dateTime);
                  return Center(child: Text(
                      "Last updated: ${timeDifference.inMinutes + 1} minutes ago",
                      style: TextStyle(color: Colors.white.withAlpha(200)),
                  ));
                }
              }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                updateData();
              },
              icon: const Icon(Icons.update),
            )
          ),
        ],
      ),
      body: getTab(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: "Core"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "TouchPoint"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getTab() {
    return IndexedStack(
      index: _selectedIndex,
      children: const <Widget>[
        StatusPage(projects: projectsCore),
        StatusPage(projects: projectsTouchPoint),
      ],
    );
  }

  Stream<T> asyncPeriodic<T>(Duration period, Future<T> Function(int count) f) {
    return Stream.periodic(period, f).asyncMap((event) async => await event);
  }

  void updateData() {
    emptyCache();
    Navigator.popAndPushNamed(context, '/');
  }
}
