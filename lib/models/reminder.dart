import 'package:uuid/uuid.dart';

class ReminderModel {
  ReminderModel({
    required this.title,
    this.isCompleted = false,
    this.id,
  }) {
    id ??= const Uuid().v4();
  }

  String? id;
  final String title;
  final bool isCompleted;
}
