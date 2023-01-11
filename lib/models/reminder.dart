import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ReminderModel {
  ReminderModel({required this.title, this.isCompleted = false, this.id, this.endDate}) {
    id ??= const Uuid().v4();
    endDate ??= DateTime.now();
  }

  String? id;
  DateTime? endDate;
  final String title;
  final bool isCompleted;

  factory ReminderModel.fromJson(Map<String, dynamic> json) => _$ReminderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);
}

ReminderModel _$ReminderModelFromJson(Map<String, dynamic> json) => ReminderModel(
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      id: json['id'] as String,
      endDate: DateTime.parse(json['endDate']),
    );

Map<String, dynamic> _$ReminderModelToJson(ReminderModel instance) => <String, dynamic>{
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'id': instance.id,
      'endDate': instance.endDate!.toIso8601String(),
    };
