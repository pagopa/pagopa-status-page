// import 'dart:convert';
// import 'dart:html' as html;
//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:statuspage/widgets/top_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class LoginPage extends StatefulWidget {
//   static const routeName = '/login';
//
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   LoginPageState createState() => LoginPageState();
// }
//
// class LoginPageState extends State<LoginPage> {
//   bool anonymous = false;
//
//   @override
//   Widget build(BuildContext context) {
//     _getToken(context);
//     return SafeArea(
//         child: Scaffold(
//       appBar: TopBar(
//         refresh: false,
//       ),
//       body: buildLogin(),
//     ));
//   }
//
//   _getToken(context) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var code = Uri.base.queryParameters['code'];
//     final args = ModalRoute.of(context)!.settings.arguments;
//     print('args ${args}');
//     print(code);
//     if (code != null) {
//       print('chiamo Azure');
//       var response = await http.get(
//           Uri.parse(
//               'https://api.dev.platform.pagopa.it/shared/statuspage/v1/access_token?code=$code'),
//           headers: {'Accept': 'application/json'});
//
//       var body = jsonDecode(response.body);
//       await prefs.setString('gh_token', body['access_token']);
//       print('ora ho il token');
//     }
//     print('step 2 ${prefs.getString("gh_token")}');
//
//     if (prefs.getString("gh_token") != null &&
//         prefs.getString("gh_token") != "") {
//       print('navigator');
//       print('go');
//
//       print(context);
//       html.window.history.pushState(null, 'login', '/');
//
//       Navigator.popAndPushNamed(context, '/home');
//     }
//   }
//
//   Center buildLogin() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextButton(
//               onPressed: () {
//                 setState(() {
//                   anonymous = true;
//                 });
//               },
//               child: Text('Entra come Anonimo')),
//           Text("Per un'esperinza completa esegui il login"),
//           ElevatedButton.icon(
//             onPressed: () async {
//               launchUrl(
//                 Uri.parse(
//                     'https://github.com/login/oauth/authorize?client_id=82d6ebcd7127e50877de&scope=public_repo'),
//                 webOnlyWindowName: '_self',
//               );
//             },
//             icon: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: const Icon(
//                 FontAwesomeIcons.github,
//                 size: 24.0,
//               ),
//             ),
//             label: Text('Login GitHub'),
//           ),
//         ],
//       ),
//     );
//   }
// }
