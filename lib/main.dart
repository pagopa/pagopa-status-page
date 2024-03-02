import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statuspage/bloc/settings/settings_cubit.dart';
import 'package:statuspage/bloc/settings/settings_state.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/pages/home_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SettingsCubit()..loadSettings(),
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()..addAll(),
        ),
      ],
      child: BlocSelector<SettingsCubit, SettingsState, bool>(
        selector: (state) {
          return state.darkTheme;
        },
        builder: (context, darkTheme) => buildMaterialApp(darkTheme),
      ),
    );
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
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
      },
    );
  }
}
