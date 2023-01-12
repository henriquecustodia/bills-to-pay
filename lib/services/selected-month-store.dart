import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/services/db.dart';

class SelectedMonthStore extends ValueNotifier<List<ReminderModel>> {
  SelectedMonthStore._() : super([]);

  static final SelectedMonthStore _instance = SelectedMonthStore._();

  late DateTime selectedMonth;

  factory SelectedMonthStore() => SelectedMonthStore._instance;

  void add(ReminderModel reminder) {
    value.add(reminder);
    Db().setData(toDbKey(selectedMonth), value);
    notifyListeners();
  }

  void edit(ReminderModel reminder) {
    var index = value.indexWhere((element) => element.id == reminder.id);

    value[index] = ReminderModel(
      title: reminder.title,
      isCompleted: reminder.isCompleted,
      id: reminder.id,
    );

    Db().setData(toDbKey(selectedMonth), value);

    notifyListeners();
  }

  void remove(ReminderModel reminder) {
    value.removeWhere((element) => element.id == reminder.id);

    Db().setData(toDbKey(selectedMonth), value);

    notifyListeners();
  }

  ReminderModel getById(String reminderId) {
    return value.firstWhere((element) => element.id == reminderId);
  }

  List<ReminderModel> list() {
    return value;
  }

  // setMonth(String month, List<ReminderModel> reminders) {
  //   selectedMonth = month;
  //   value.addAll(reminders);
  // }

  init() async {
    var now = DateTime.now();

    selectedMonth = now;

    var formattedDate = toDbKey(now);
    var reminders = await Db().getData(formattedDate);

    if (reminders == null) {
      reminders = [];
      await Db().setData(formattedDate, reminders);
    }

    value.addAll(reminders);

    print(await Db().getData(formattedDate));
  }

  toDbKey(DateTime dt) {
    return DateFormat('yyyy-MM').format(dt);
  }
}
