import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/filter_model.dart';

class TaskFiltersWidget extends StatefulWidget {
  final FilterModel currentFilter;
  final Function(FilterModel) onFilterChanged;

  const TaskFiltersWidget({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<TaskFiltersWidget> createState() => _TaskFiltersWidgetState();
}

class _TaskFiltersWidgetState extends State<TaskFiltersWidget> {
  late String? selectedCategory;
  late String? selectedPriority;
  late String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.currentFilter.category;
    selectedPriority = widget.currentFilter.priority;
    selectedStatus = widget.currentFilter.status;
  }

  void _applyFilters() {
    final newFilter = widget.currentFilter.copyWith(
      category: selectedCategory,
      priority: selectedPriority,
      status: selectedStatus,
      offset: 0, // Reset to first page
    );
    widget.onFilterChanged(newFilter);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedPriority = null;
      selectedStatus = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filters', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // Category filter
            Text('Category', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final cat in AppConstants.taskCategories)
                  FilterChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected ? cat : null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Priority filter
            Text('Priority', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final pri in AppConstants.taskPriorities)
                  FilterChip(
                    label: Text(pri),
                    selected: selectedPriority == pri,
                    onSelected: (selected) {
                      setState(() {
                        selectedPriority = selected ? pri : null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Status filter
            Text('Status', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final stat in AppConstants.taskStatuses)
                  FilterChip(
                    label: Text(stat.replaceAll('_', ' ')),
                    selected: selectedStatus == stat,
                    onSelected: (selected) {
                      setState(() {
                        selectedStatus = selected ? stat : null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Apply and Reset buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
