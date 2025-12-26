import 'package:flutter/material.dart';
import '../models/task.dart';
import '../config/theme.dart';
import '../utils/date_formatter.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDeletePressed;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.getStatusColor(
                        task.status,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.status.replaceAll('_', ' ').toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.getStatusColor(task.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Chips: Category and Priority
              Wrap(
                spacing: 6,
                children: [
                  Chip(
                    label: Text(task.category.capitalize()),
                    backgroundColor: AppTheme.getCategoryColor(
                      task.category,
                    ).withOpacity(0.2),
                    labelStyle: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(
                          color: AppTheme.getCategoryColor(task.category),
                        ),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
                  Chip(
                    label: Text(task.priority.capitalize()),
                    backgroundColor: AppTheme.getPriorityColor(
                      task.priority,
                    ).withOpacity(0.2),
                    labelStyle: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(
                          color: AppTheme.getPriorityColor(task.priority),
                        ),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Due date and assignee
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.formatDueDate(task.due_date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (task.assigned_to != null) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.assigned_to!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
