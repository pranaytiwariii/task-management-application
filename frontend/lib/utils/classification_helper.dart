/// Helper class to preview category and priority classification on the frontend
/// This mimics the backend classification logic to show users what will be detected
class ClassificationHelper {
  static const Map<String, List<String>> _categoryKeywords = {
    'scheduling': [
      'meeting',
      'meet',
      'schedule',
      'call',
      'appointment',
      'deadline',
      'conference',
      'standup',
      'sync',
      'calendar',
      'book',
    ],
    'finance': [
      'payment',
      'invoice',
      'bill',
      'budget',
      'cost',
      'expense',
      'financial',
      'accounting',
      'finalize',
      'finance',
      'money',
      'pay',
    ],
    'technical': [
      'bug',
      'fix',
      'error',
      'install',
      'repair',
      'maintain',
      'deploy',
      'code',
      'system',
    ],
    'safety': [
      'safety',
      'hazard',
      'inspection',
      'compliance',
      'ppe',
      'accident',
      'incident',
    ],
  };

  static const Map<String, List<String>> _priorityKeywords = {
    'high': ['urgent', 'asap', 'immediately', 'today', 'critical', 'emergency'],
    'medium': ['soon', 'this week', 'important', 'next week'],
  };

  /// Classify category based on keywords in title and description
  static String classifyCategory(String title, String? description) {
    final text = '${title} ${description ?? ''}'.toLowerCase();

    for (final entry in _categoryKeywords.entries) {
      final category = entry.key;
      final keywords = entry.value;

      if (keywords.any((keyword) => text.contains(keyword))) {
        return category;
      }
    }

    return 'general';
  }

  /// Classify priority based on keywords in title and description
  static String classifyPriority(String title, String? description) {
    final text = '${title} ${description ?? ''}'.toLowerCase();

    for (final entry in _priorityKeywords.entries) {
      final priority = entry.key;
      final keywords = entry.value;

      if (keywords.any((keyword) => text.contains(keyword))) {
        return priority;
      }
    }

    return 'low';
  }

  /// Get suggested actions based on category
  static List<String> getSuggestedActions(String category) {
    const actionMap = {
      'scheduling': ['Block calendar', 'Send invite', 'Prepare agenda'],
      'finance': ['Check budget', 'Generate invoice', 'Process payment'],
      'technical': ['Diagnose issue', 'Assign technician', 'Create ticket'],
      'safety': [
        'Conduct inspection',
        'Notify supervisor',
        'Document incident',
      ],
      'general': ['Review task', 'Plan approach', 'Assign resource'],
    };

    return actionMap[category] ?? actionMap['general']!;
  }
}
