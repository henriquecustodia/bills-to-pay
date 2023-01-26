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

  Future<bool> init() async {
    var now = DateTime.now();

    selectedMonth = now;

    await Db().setData(
        toDbKey(
          now.subtract(Duration(days: 30)),
        ),
        [
          ReminderModel(
            title: 'test 1',
            endDate: DateTime(2023, DateTime.april, 20),
          ),
          ReminderModel(
            title: 'test 2',
            endDate: DateTime(2023, DateTime.november, 20),
          )
        ]);

    var reminders = await getOrCreateListInDb(now);

    value.addAll(reminders);

    return true;
  }

  String toDbKey(DateTime dt) {
    return DateFormat('yyyy-MM').format(dt);
  }

  Future<List<ReminderModel>> getOrCreateListInDb(DateTime dt) async {
    var reminders = await Db().getData(toDbKey(dt));

    if (reminders == null) {
      reminders = await getListFromPreviousMonth(dt) ?? [];

      var copiedReminders = copyReminders(reminders);

      await Db().setData(toDbKey(dt), copiedReminders);
    }

    return reminders;
  }

  Future<List<ReminderModel>> createReminderList(DateTime dt) async {
    var reminders = await getListFromPreviousMonth(dt) ?? [];

    var copiedReminders = copyReminders(reminders);

    await Db().setData(toDbKey(dt), copiedReminders);

    return copiedReminders;
  }

  Future<List<ReminderModel>?> getListFromPreviousMonth(DateTime dt) async {
    var hasItems = await Db().hasItems();

    if (!hasItems) {
      return null;
    }

    var firstDayOftheMonth = DateTime(dt.year, dt.month, 1);

    while (true) {
      var previousMonth = firstDayOftheMonth.subtract(const Duration(days: 30));
      firstDayOftheMonth = DateTime(previousMonth.year, previousMonth.month, 1);

      var hasKey = await Db().hasKey(toDbKey(firstDayOftheMonth));

      if (!hasKey) {
        continue;
      }

      return await Db().getData(toDbKey(firstDayOftheMonth));
    }
  }

  List<ReminderModel> copyReminders(List<ReminderModel> reminders) {
    List<ReminderModel> copiedReminders = [];

    reminders.forEach((element) {
      if (element.endDate == null) {
        return;
      }

      var firstDayOfEndDate = DateTime(element.endDate!.year, element.endDate!.month, 1);
      var firstDayOfSelectedMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);

      if (firstDayOfEndDate.isBefore(firstDayOfSelectedMonth)) {
        return;
      }

      copiedReminders.add(
        ReminderModel(
          title: element.title,
          endDate: element.endDate,
        ),
      );
    });

    return copiedReminders;
  }
}
