import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

Future<String> remember(String key, Function fun) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var cached = prefs.getString(key);

  if (cached != null && cached.isNotEmpty) {
    return cached;
  }
  var result = await fun();

  prefs.setString(lastUpdatedKey, DateTime.now().toIso8601String());
  prefs.setString(key, result.toString());
  return result.toString();
}

int compareTo(String semanticVersion1, String semanticVersion2) {
  try {
    if (semanticVersion1 == semanticVersion2) {
      return 0;
    }

    var sv1 = semanticVersion1.split('-')[0].split('.');
    var sv2 = semanticVersion2.split('-')[0].split('.');

    int major1 = int.parse(sv1[0]);
    int major2 = int.parse(sv2[0]);
    if (major1 > major2) {
      return -1;
    }
    if (major1 < major2) {
      return 1;
    }

    int minor1 = int.parse(sv1[1]);
    int minor2 = int.parse(sv2[1]);
    if (minor1 > minor2) {
      return 1;
    }
    if (minor1 < minor2) {
      return -1;
    }

    int patch1 = int.parse(sv1[2]);
    int patch2 = int.parse(sv2[2]);
    if (patch1 > patch2) {
      return 1;
    }
    if (patch1 < patch2) {
      return -1;
    }

    if (semanticVersion2.contains('-')) {
      return -1;
    }

    return 0;
  } catch (e) {
    return -2;
  }
}
