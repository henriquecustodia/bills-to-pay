class ReminderModel {
  ReminderModel({
    required this.title,
    this.isCompleted = false,
  });

  final String title;
  final bool isCompleted;
}
