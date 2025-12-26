import 'package:dio/dio.dart';
import '../models/task.dart';
import '../models/pagination.dart';
import '../models/filter_model.dart';
import '../services/api_service.dart';
import '../config/constants.dart';

class TaskRepository {
  final ApiService apiService;

  TaskRepository({required this.apiService});

  /// Fetch tasks with pagination, filtering, and sorting
  Future<({List<Task> tasks, Pagination pagination})> getTasks(
    FilterModel filter,
  ) async {
    try {
      final response = await apiService.dio.get(
        AppConstants.tasksEndpoint,
        queryParameters: filter.toQueryParams(),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final responseData = response.data['data'];
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('tasks')) {
          final tasksList = responseData['tasks'] as List;
          final tasks = tasksList
              .map((json) => Task.fromJson(json as Map<String, dynamic>))
              .toList();
          final pagination = Pagination.fromJson(
            responseData['pagination'] ?? {},
          );

          // Client-side search filtering if needed
          final filtered = _filterBySearch(tasks, filter.searchQuery);

          return (tasks: filtered, pagination: pagination);
        } else {
          throw Exception('API returned unexpected data structure for tasks.');
        }
      }

      throw Exception('Failed to load tasks: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch single task by ID
  Future<Task> getTaskById(String id) async {
    try {
      final response = await apiService.dio.get(
        '${AppConstants.tasksEndpoint}/$id',
      );

      if (response.statusCode == 200) {
        return Task.fromJson(response.data['data'] as Map<String, dynamic>);
      }

      throw Exception('Failed to load task');
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new task
  Future<Task> createTask(Task task) async {
    try {
      final response = await apiService.dio.post(
        AppConstants.tasksEndpoint,
        data: task.toJson(),
      );

      if (response.statusCode == 201) {
        return Task.fromJson(response.data['data'] as Map<String, dynamic>);
      }

      throw Exception('Failed to create task: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing task
  Future<Task> updateTask(String id, Task task) async {
    try {
      final response = await apiService.dio.patch(
        '${AppConstants.tasksEndpoint}/$id',
        data: task.toJson(),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(response.data['data'] as Map<String, dynamic>);
      }

      throw Exception('Failed to update task: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Delete an existing task
  Future<void> deleteTask(String id) async {
    try {
      final response = await apiService.dio.delete(
        '${AppConstants.tasksEndpoint}/$id',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Export tasks to CSV
  Future<String> exportTasksToCSV(List<Task> tasks) async {
    try {
      // Create CSV header
      final csv = StringBuffer();
      csv.writeln(
        'ID,Title,Description,Category,Priority,Status,Assigned To,Due Date,Created At',
      );

      // Add task rows
      for (final task in tasks) {
        csv.writeln(
          '"${task.id}","${_escapeCsv(task.title)}","${_escapeCsv(task.description ?? '')}","${task.category}","${task.priority}","${task.status}","${task.assigned_to ?? ''}","${task.due_date ?? ''}","${task.createdAt ?? ''}"',
        );
      }

      return csv.toString();
    } catch (e) {
      rethrow;
    }
  }

  /// Filter tasks by search query (client-side)
  List<Task> _filterBySearch(List<Task> tasks, String? query) {
    if (query == null || query.isEmpty) return tasks;

    final lowerQuery = query.toLowerCase();
    return tasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(lowerQuery) ||
              (task.description ?? '').toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Escape CSV values
  String _escapeCsv(String value) {
    return value.replaceAll('"', '""');
  }
}
