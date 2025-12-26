import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import 'repository_provider.dart';

/// CSV export provider
final csvExportProvider = FutureProvider.family<String, List<Task>>((
  ref,
  tasks,
) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.exportTasksToCSV(tasks);
});
