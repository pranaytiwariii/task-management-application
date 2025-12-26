// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  category: json['category'] as String? ?? 'general',
  priority: json['priority'] as String? ?? 'medium',
  assigned_to: json['assigned_to'] as String?,
  status: json['status'] as String? ?? 'pending',
  due_date: json['due_date'] as String?,
  requirements: json['requirements'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'priority': instance.priority,
  'assigned_to': instance.assigned_to,
  'status': instance.status,
  'due_date': instance.due_date,
  'requirements': instance.requirements,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
