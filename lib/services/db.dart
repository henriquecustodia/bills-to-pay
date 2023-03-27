import 'dart:convert';

import 'package:reminder/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Db {
  Future<SharedPreferences> getInstance() async =>
      await SharedPreferences.getInstance();

  Future<List<ReminderModel>?> getData(String key) async {
    var pref = await getInstance();

    var dataAsString = pref.get(key);

    if (dataAsString == null || dataAsString == '()' || dataAsString == '[]') {
      return null;
    }

    return List.from(jsonDecode(dataAsString as String))
        .map((e) => ReminderModel.fromJson(e))
        .toList();
  }

  Future<bool> setData(String key, List<ReminderModel> reminders) async {
    var pref = await getInstance();

    var remindersAsString = jsonEncode(reminders);

    return pref.setString(key, remindersAsString);
  }

  Future<bool> clearData() async {
    var pref = await getInstance();

    return pref.clear();
  }

  Future<Map<String, List<ReminderModel>>> getAll() async {
    var pref = await getInstance();

    var keys = pref.getKeys();

    Map<String, List<ReminderModel>> result = keys.fold({}, (map, currentKey) {
      var listAsString = pref.getString(currentKey) as String;
      var decodedJsonData = jsonDecode(listAsString);
      var reminders = List.from(decodedJsonData)
          .map((e) => ReminderModel.fromJson(e))
          .toList();

      map.addAll({currentKey: reminders});

      return map;
    });

    return Future(() => result);
  }

  Future<bool> hasItems() async {
    var pref = await getInstance();
    var keys = pref.getKeys();

    return keys.isNotEmpty;
  }

  Future<bool> hasKey(String key) async {
    var pref = await getInstance();
    return pref.containsKey(key);
  }

  Future<List<String>> getKeys() async {
    var map = await Db().getAll();
    return map.keys.toList();
  }
}
