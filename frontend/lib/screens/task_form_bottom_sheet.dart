import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/repository_provider.dart';
import '../utils/validators.dart';
import '../utils/classification_helper.dart';

class TaskFormBottomSheet extends ConsumerStatefulWidget {
  const TaskFormBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskFormBottomSheet> createState() =>
      _TaskFormBottomSheetState();
}

class _TaskFormBottomSheetState extends ConsumerState<TaskFormBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedToController;
  late TextEditingController _dueDateController;
  late TextEditingController _requirementsController;

  String? _selectedCategory;
  String? _selectedPriority;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final formTask = ref.read(formTaskProvider);

    _titleController = TextEditingController(text: formTask?.title ?? '');
    _descriptionController = TextEditingController(
      text: formTask?.description ?? '',
    );
    _assignedToController = TextEditingController(
      text: formTask?.assigned_to ?? '',
    );
    _dueDateController = TextEditingController(text: formTask?.due_date ?? '');
    _requirementsController = TextEditingController(
      text: formTask?.requirements ?? '',
    );
    _selectedCategory = formTask?.category;
    _selectedPriority = formTask?.priority;

    // Add listeners to refresh auto-detection preview
    _titleController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    _dueDateController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDateController.text.isNotEmpty
          ? DateTime.parse(_dueDateController.text)
          : DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dueDateController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  String _getAutoDetectedCategory() {
    return ClassificationHelper.classifyCategory(
      _titleController.text,
      _descriptionController.text,
    );
  }

  String _getAutoDetectedPriority() {
    return ClassificationHelper.classifyPriority(
      _titleController.text,
      _descriptionController.text,
    );
  }

  void _showClassificationPreview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Classification Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Category: ${_selectedCategory ?? 'general'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Recommended Priority: ${_selectedPriority ?? 'medium'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('You can override these before saving.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    // Validate
    final titleError = FormValidator.validateTitle(_titleController.text);
    final descError = FormValidator.validateDescription(
      _descriptionController.text,
    );

    if (titleError != null || descError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(titleError ?? descError ?? 'Validation error')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final task = Task(
        id: ref.read(formTaskProvider)?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        // Send null if not manually selected - backend will auto-detect
        category: _selectedCategory,
        priority: _selectedPriority,
        assigned_to: _assignedToController.text.isEmpty
            ? null
            : _assignedToController.text,
        due_date: _dueDateController.text.isEmpty
            ? null
            : _dueDateController.text,
        requirements: _requirementsController.text.isEmpty
            ? null
            : _requirementsController.text,
        status: ref.read(formTaskProvider)?.status ?? 'pending',
      );

      final repo = ref.read(taskRepositoryProvider);
      final isEdit = ref.read(formTaskProvider) != null;

      if (isEdit) {
        await repo.updateTask(task.id!, task);
      } else {
        await repo.createTask(task);
      }

      // Refresh list
      await ref.read(taskListProvider.notifier).refetch();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Task updated successfully'
                  : 'Task created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = ref.watch(formTaskProvider) != null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEdit ? 'Edit Task' : 'Create Task',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Title field
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title *',
              hintText: 'Enter task title',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Description field
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description *',
              hintText: 'Enter task description',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          // Requirements field (optional)
          TextFormField(
            controller: _requirementsController,
            decoration: InputDecoration(
              labelText: 'Requirements (Optional)',
              hintText: 'Any special requirements',
              prefixIcon: const Icon(Icons.list),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          // Assigned to field
          TextFormField(
            controller: _assignedToController,
            decoration: InputDecoration(
              labelText: 'Assigned To',
              hintText: 'person@example.com',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Due date field
          GestureDetector(
            onTap: _selectDate,
            child: TextFormField(
              controller: _dueDateController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Due Date',
                hintText: 'Select a due date',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _dueDateController.clear(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Auto-detection preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Auto-detected:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Category: ${_selectedCategory ?? _getAutoDetectedCategory()}',
                  style: TextStyle(fontSize: 13, color: Colors.green.shade900),
                ),
                Text(
                  'Priority: ${_selectedPriority ?? _getAutoDetectedPriority()}',
                  style: TextStyle(fontSize: 13, color: Colors.green.shade900),
                ),
                const SizedBox(height: 4),
                Text(
                  'Override below if needed',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Category selector (optional override)
          Text(
            'Category (Optional - Override auto-detection)',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                ['scheduling', 'finance', 'technical', 'safety', 'general']
                    .map(
                      (cat) => ChoiceChip(
                        label: Text(cat),
                        selected: _selectedCategory == cat,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? cat : null;
                          });
                        },
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          // Priority selector (optional override)
          Text(
            'Priority (Optional - Override auto-detection)',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['low', 'medium', 'high']
                .map(
                  (pri) => ChoiceChip(
                    label: Text(pri),
                    selected: _selectedPriority == pri,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPriority = selected ? pri : null;
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 12),
          // Submit button
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEdit ? 'Update Task' : 'Create Task'),
          ),
        ],
      ),
    );
  }
}
