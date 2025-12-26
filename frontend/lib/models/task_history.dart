import 'package:json_annotation/json_annotation.dart';

part 'task_history.g.dart';

@JsonSerializable()
class TaskHistory {
  final int? id;
  final int task_id;
  final String action; // created, updated, deleted
  final Map<String, dynamic>? changes;
  final String? changed_by;
  final String? timestamp;

  TaskHistory({
    this.id,
    required this.task_id,
    required this.action,
    this.changes,
    this.changed_by,
    this.timestamp,
  });

  factory TaskHistory.fromJson(Map<String, dynamic> json) =>
      _$TaskHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$TaskHistoryToJson(this);
}
