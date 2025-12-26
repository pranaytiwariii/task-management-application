import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String? id;
  final String title;
  final String? description;
  final String category;
  final String priority;
  final String? assigned_to;
  final String status;
  final String? due_date;
  final String? requirements;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.category = 'general',
    this.priority = 'medium',
    this.assigned_to,
    this.status = 'pending',
    this.due_date,
    this.requirements,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? assigned_to,
    String? status,
    String? due_date,
    String? requirements,
    String? createdAt,
    String? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      assigned_to: assigned_to ?? this.assigned_to,
      status: status ?? this.status,
      due_date: due_date ?? this.due_date,
      requirements: requirements ?? this.requirements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
