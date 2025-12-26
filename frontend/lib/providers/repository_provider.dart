import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/task_repository.dart';
import 'api_provider.dart';

/// Task repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TaskRepository(apiService: apiService);
});
