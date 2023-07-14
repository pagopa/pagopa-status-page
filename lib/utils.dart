import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';

Future<String> remember(String key, Function fun) async {
  var cached = await ReadCache.getString(key: key);

  if (cached != null && cached.isNotEmpty) {
    return cached;
  }
  var result = await fun();
  WriteCache.setString(key: key, value: result.toString());
  return result.toString();
}
