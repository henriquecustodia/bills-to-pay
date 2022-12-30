import 'package:flutter/cupertino.dart';
import 'package:reminder/models/reminder.dart';

class Store extends ValueNotifier<List<ReminderModel>> {

  Store._(): super([]); 

  static final Store _instance = Store._();

  factory Store() => Store._instance;

  void add(ReminderModel reminder) {
    value.add(reminder);
    notifyListeners();
  }

  void edit(ReminderModel reminder) {
    var index = value.indexWhere((element) => element.id == reminder.id);

    value[index] = ReminderModel(
      title: reminder.title,
      isCompleted: reminder.isCompleted,
      id: reminder.id,
    );

    notifyListeners();
  }

  void remove(ReminderModel reminder) {
    value.removeWhere((element) => element.id == reminder.id);
    notifyListeners();
  }

  ReminderModel getById(String reminderId) {
    return value.firstWhere((element) => element.id == reminderId);
  }

  List<ReminderModel> list() {
    return value;
  }
}
