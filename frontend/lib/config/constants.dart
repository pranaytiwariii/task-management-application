/// API and App Constants
class AppConstants {
  // API Endpoints
  static const String tasksEndpoint = '/api/tasks';

  // Pagination defaults
  static const int defaultPageSize = 10;
  static const int defaultOffset = 0;

  // Task statuses
  static const List<String> taskStatuses = [
    'pending',
    'in_progress',
    'completed',
  ];

  // Task categories
  static const List<String> taskCategories = [
    'scheduling',
    'finance',
    'technical',
    'safety',
    'general',
  ];

  // Task priorities
  static const List<String> taskPriorities = ['low', 'medium', 'high'];

  // String constants
  static const String noTasksMessage = 'No tasks found';
  static const String errorFetchingTasks = 'Failed to fetch tasks';
  static const String taskCreatedSuccess = 'Task created successfully';
  static const String taskUpdatedSuccess = 'Task updated successfully';
  static const String taskDeletedSuccess = 'Task deleted successfully';
  static const String taskFormValidationError =
      'Please fill in all required fields';
  static const String offlineWarning = 'You are offline';
}
