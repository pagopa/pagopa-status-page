import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statuspage/bloc/settings_cubit.dart';
import 'package:statuspage/pages/home_page.dart';
import 'package:statuspage/pages/init_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SettingsCubit(),
        child: BlocBuilder<SettingsCubit, bool>(
          builder: (context, darkTheme) => buildMaterialApp(darkTheme),
        ),);
  }

  MaterialApp buildMaterialApp(bool darkTheme) {
    return MaterialApp(
          title: 'Status Page',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            useMaterial3: true,
            brightness: darkTheme ? Brightness.dark : Brightness.light,
          ),
          home: const SelectionArea(
            child: SafeArea(child: HomePage()),
          ));
  }
}
