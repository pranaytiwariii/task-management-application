import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/filter_model.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../providers/task_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/offline_indicator.dart';
import '../widgets/skeleton_loaders.dart';
import '../widgets/task_list_item.dart';
import '../widgets/summary_cards.dart';
import '../widgets/task_filters.dart';
import '../widgets/search_bar.dart';
import 'task_form_bottom_sheet.dart';

class TaskDashboard extends ConsumerStatefulWidget {
  const TaskDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends ConsumerState<TaskDashboard> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateTaskForm() {
    ref.read(formTaskProvider.notifier).state = null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const TaskFormBottomSheet(),
    );
  }

  void _showEditTaskForm(Task task) {
    ref.read(formTaskProvider.notifier).state = task;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const TaskFormBottomSheet(),
    );
  }

  void _showFilters() {
    final currentFilter = ref.read(filterProvider);
    showModalBottomSheet(
      context: context,
      builder: (context) => TaskFiltersWidget(
        currentFilter: currentFilter,
        onFilterChanged: (newFilter) {
          ref.read(filterProvider.notifier).state = newFilter;
          ref.read(taskListProvider.notifier).updateFilters(newFilter);
        },
      ),
    );
  }

  void _onSearch(String query) {
    final filter = ref.read(filterProvider);
    final newFilter = filter.copyWith(searchQuery: query, offset: 0);
    ref.read(filterProvider.notifier).state = newFilter;
    ref.read(taskListProvider.notifier).updateFilters(newFilter);
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);
    final taskListState = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(taskListProvider.notifier).refetch(),
          ),
        ],
      ),
      body: Column(
        children: [
          OfflineIndicator(isOnline: isOnline),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(taskListProvider.notifier).refetch(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search bar
                      SearchBarWidget(onSearch: _onSearch),
                      const SizedBox(height: 16),
                      // Summary cards
                      taskListState.when(
                        data: (data) => _buildSummaryCards(data.tasks),
                        loading: () => _buildSummaryCardSkeletons(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tasks',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Task list
                      _buildTaskList(taskListState),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCards(List<Task> tasks) {
    final pending = tasks.where((t) => t.status == 'pending').length;
    final inProgress = tasks.where((t) => t.status == 'in_progress').length;
    final completed = tasks.where((t) => t.status == 'completed').length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SummaryCard(title: 'Pending', count: pending, color: Colors.orange),
          const SizedBox(width: 12),
          SummaryCard(
            title: 'In Progress',
            count: inProgress,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          SummaryCard(
            title: 'Completed',
            count: completed,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardSkeletons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SkeletonLoader(width: 120, height: 100),
          const SizedBox(width: 12),
          SkeletonLoader(width: 120, height: 100),
          const SizedBox(width: 12),
          SkeletonLoader(width: 120, height: 100),
        ],
      ),
    );
  }

  Widget _buildTaskList(
    AsyncValue<({List<Task> tasks, dynamic pagination})> taskListState,
  ) {
    return taskListState.when(
      data: (data) {
        final tasks = data.tasks;
        if (tasks.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.noTasksMessage,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            ...tasks.map(
              (task) => TaskListItem(
                task: task,
                onTap: () => _showEditTaskForm(task),
                onDeletePressed: () => _deleteTask(task.id!),
              ),
            ),
            if (data.pagination.hasNextPage)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () =>
                      ref.read(taskListProvider.notifier).nextPage(),
                  child: const Text('Load More'),
                ),
              ),
          ],
        );
      },
      loading: () => Column(
        children: [...List.generate(5, (index) => const TaskCardSkeleton())],
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.error, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Error loading tasks: $error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(taskListProvider.notifier).refetch(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTask(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(taskListProvider.notifier).deleteTask(taskId);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Task deleted')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete task: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
