import 'package:flutter/cupertino.dart';
import 'package:reminder/models/reminder.dart';

class AllMonthsStore {
  final Map<String, List<ReminderModel>> data = {};

  AllMonthsStore._();

  static final AllMonthsStore _instance = AllMonthsStore._();

  factory AllMonthsStore() => AllMonthsStore._instance;

  void add(String key, List<ReminderModel> reminders) {
    data.addAll({key: reminders});
  }

}
