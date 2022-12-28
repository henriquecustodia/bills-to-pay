import 'package:reminder/models/reminder.dart';

class Store {
  final List<ReminderModel> _data = [];

  Store._();

  static final Store _instance = Store._();

  factory Store() => Store._instance;

  add(ReminderModel reminder) {
    _data.add(reminder);
  }

  remove(ReminderModel reminder) {
    _data.removeWhere((element) => element.id == reminder.id);
  }

  list() {
    return _data;
  }
}
