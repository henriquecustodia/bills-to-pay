import 'dart:convert';

import 'package:reminder/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Db {
   
  Future<SharedPreferences> getInstance() async => await SharedPreferences.getInstance();

  getData(String key) async {
      var pref = await getInstance();

      var dataAsString = pref.getString(key) as String;

      var decodedData = json.decode(dataAsString) as List;

      return decodedData.map((e) => ReminderModel.fromJson(e)).toList();
  }

  setData(String key, List<ReminderModel> reminders) async {
      var pref = await getInstance();

      var remindersAsString = reminders.map((e) => e.toJson()).toString();
      
      return pref.setString(key, remindersAsString) as String;
  }

}