import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuspage/bloc/settings/settings_state.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/bloc/versions/app_state.dart';
import 'package:statuspage/constant.dart';
import 'package:statuspage/pages/status_page.dart';
import 'package:statuspage/widgets/top_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/settings/settings_cubit.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 60 * 5),
      (Timer timer) {
        final appCubit = context.read<AppCubit>();
        if (appCubit.state.accessGranted) {
          appCubit.empty();
        }
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TopBar(),
        body: Stack(
          children: [
            Column(
              children: [
                buildGithubRateLimitBanner(),
                Expanded(child: getTab()),
              ],
            ),
            buildAuthGate(),
          ],
        ),
        bottomNavigationBar: buildBottomBar(),
      ),
    );
  }

  Widget buildAuthGate() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (!state.authChecking && !state.authPromptVisible) {
          return const SizedBox.shrink();
        }
        return Positioned.fill(
          child: Material(
            color: Colors.black54,
            child: Center(
              child: AlertDialog(
                title: Text(state.authChecking
                    ? 'Verifica accesso GitHub'
                    : 'Accedi o continua come guest'),
                content: state.authChecking
                    ? const SizedBox(
                        height: 56,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.githubLoginMessage != null)
                            Text(state.githubLoginMessage!),
                          if (state.githubLoginInProgress &&
                              state.githubUserCode != null) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Inserisci questo codice nella pagina GitHub:',
                            ),
                            SelectableText(
                              state.githubUserCode!,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            TextButton.icon(
                              onPressed: () => launchGithubVerification(
                                state.githubVerificationUri!,
                              ),
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('Apri GitHub'),
                            ),
                          ],
                        ],
                      ),
                actions: [
                  if (state.authPromptVisible &&
                      !state.githubLoginInProgress) ...[
                    TextButton(
                      onPressed: context.read<AppCubit>().continueAsGuest,
                      child: const Text('Continua come guest'),
                    ),
                    FilledButton(
                      onPressed: () =>
                          context.read<AppCubit>().loginWithGithub(),
                      child: const Text('Accedi con GitHub'),
                    ),
                  ],
                  if (state.githubLoginInProgress)
                    TextButton(
                      onPressed: context.read<AppCubit>().cancelGithubLogin,
                      child: const Text('Annulla'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGithubRateLimitBanner() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (!state.githubRateLimited || state.githubRateLimitBannerDismissed) {
          return const SizedBox.shrink();
        }
        return MaterialBanner(
          content: const Text(
            'GitHub ha raggiunto il limite di richieste anonime: le versioni '
            'dei repository potrebbero non essere disponibili.',
          ),
          leading: const Icon(Icons.info_outline),
          actions: [
            TextButton(
              onPressed: () => showGithubLoginDialog(context),
              child: const Text('Accedi con GitHub'),
            ),
            TextButton(
              onPressed: context.read<AppCubit>().dismissGithubRateLimitBanner,
              child: const Text('Non ora'),
            ),
          ],
        );
      },
    );
  }

  void showGithubLoginDialog(BuildContext context) {
    unawaited(context.read<AppCubit>().loginWithGithub());
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return AlertDialog(
            title: const Text('Accedi con GitHub'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.githubLoginInProgress && state.githubUserCode == null)
                  const LinearProgressIndicator(),
                if (state.githubUserCode != null) ...[
                  Text(state.githubLoginMessage ?? ''),
                  const SizedBox(height: 12),
                  SelectableText(
                    state.githubUserCode!,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton.icon(
                    onPressed: () => launchGithubVerification(
                      state.githubVerificationUri!,
                    ),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Apri GitHub'),
                  ),
                ] else if (state.githubLoginMessage != null) ...[
                  Text(state.githubLoginMessage!),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: state.githubLoginInProgress
                    ? context.read<AppCubit>().cancelGithubLogin
                    : () => Navigator.of(dialogContext).pop(),
                child: Text(state.githubLoginInProgress ? 'Annulla' : 'Chiudi'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> launchGithubVerification(String uri) async {
    await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
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
      children: <Widget>[
        StatusPage.sorted(projects: projectsCore),
        StatusPage.sorted(projects: projectsTouchPoint),
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
    context.read<AppCubit>().empty();
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
    projectsTouchPoint.forEach((namespace, value) {
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
