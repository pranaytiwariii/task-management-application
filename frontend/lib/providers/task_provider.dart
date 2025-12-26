import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter_model.dart';
import '../models/task.dart';
import '../models/pagination.dart';
import '../repositories/task_repository.dart';
import 'repository_provider.dart';

/// Filter state provider
final filterProvider = StateProvider<FilterModel>((ref) {
  return FilterModel();
});

/// Task list state notifier
class TaskListNotifier
    extends
        StateNotifier<AsyncValue<({List<Task> tasks, Pagination pagination})>> {
  final TaskRepository repo;
  final Ref ref;

  TaskListNotifier({required this.repo, required this.ref})
    : super(const AsyncValue.loading()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    state = const AsyncValue.loading();
    final filter = ref.read(filterProvider);

    try {
      final result = await repo.getTasks(filter);
      state = AsyncValue.data(result);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<void> refetch() => _loadTasks();

  Future<void> nextPage() async {
    final filter = ref.read(filterProvider);
    final newFilter = filter.copyWith(offset: filter.offset + filter.limit);
    ref.read(filterProvider.notifier).state = newFilter;
    await _loadTasks();
  }

  Future<void> updateFilters(FilterModel newFilter) async {
    ref.read(filterProvider.notifier).state = newFilter;
    await _loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await repo.deleteTask(taskId);
      await refetch();
    } catch (e) {
      rethrow;
    }
  }
}

/// Task list provider
final taskListProvider =
    StateNotifierProvider<
      TaskListNotifier,
      AsyncValue<({List<Task> tasks, Pagination pagination})>
    >(
      (ref) =>
          TaskListNotifier(repo: ref.watch(taskRepositoryProvider), ref: ref),
    );

/// Selected task provider
final selectedTaskProvider = StateProvider<Task?>((ref) => null);

/// Create/Edit form task provider
final formTaskProvider = StateProvider<Task?>((ref) => null);
