// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskHistory _$TaskHistoryFromJson(Map<String, dynamic> json) => TaskHistory(
  id: (json['id'] as num?)?.toInt(),
  task_id: (json['task_id'] as num).toInt(),
  action: json['action'] as String,
  changes: json['changes'] as Map<String, dynamic>?,
  changed_by: json['changed_by'] as String?,
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$TaskHistoryToJson(TaskHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.task_id,
      'action': instance.action,
      'changes': instance.changes,
      'changed_by': instance.changed_by,
      'timestamp': instance.timestamp,
    };
