import 'package:uuid/uuid.dart';

class ReminderModel {
  ReminderModel({
    required this.title,
    this.isCompleted = false,
  });

  final String id = const Uuid().v4();
  final String title;
  final bool isCompleted;
}
