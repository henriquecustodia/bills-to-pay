import 'dart:convert';

import 'package:reminder/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Db {
  Future<SharedPreferences> getInstance() async => await SharedPreferences.getInstance();

  Future<List<ReminderModel>?> getData(String key) async {
    var pref = await getInstance();

    var dataAsString = pref.get(key);

    if (dataAsString == null || dataAsString == '()') {
      return null;
    }

    var list = jsonDecode(dataAsString as String) as List;

    return list.map((e) => ReminderModel.fromJson(e)).toList();
  }

  Future<bool> setData(String key, List<ReminderModel> reminders) async {
    var pref = await getInstance();

    var remindersAsString =  jsonEncode(reminders);

    return pref.setString(key, remindersAsString);
  }

  Future<Map<String, List<ReminderModel>>> getAll() async {
    var pref = await getInstance();

    var keys = pref.getKeys();

    var result = keys.fold({}, (map, currentKey) {
      var listAsString = pref.getString(currentKey) as String;
      var reminders = jsonDecode(listAsString) as List<ReminderModel>;

      map.addAll({currentKey: reminders});

      return map;
    });

    return result as Future<Map<String, List<ReminderModel>>>;
  }
  
  Future<bool> hasItems() async {
    var pref = await getInstance();
    var keys = pref.getKeys();

    return keys.isEmpty;
  }

  Future<bool> hasKey(String key) async {
    var pref = await getInstance();
    return  pref.containsKey(key);
  }
  
}
