import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/task_notifier.dart';

class AddTaskTile extends ConsumerStatefulWidget {
  const AddTaskTile({super.key});

  @override
  ConsumerState<AddTaskTile> createState() => _AddTaskTileState();
}

class _AddTaskTileState extends ConsumerState<AddTaskTile> {
  bool _isExpanded = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isNotEmpty) {
      ref
          .read(tasksProvider.notifier)
          .add(title, description.isEmpty ? null : description);
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _isExpanded = false;
      });
    }
  }

  void _cancel() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 2,
      child: ExpansionTile(
        leading: const Icon(Icons.add, color: Colors.blue),
        title: _isExpanded
            ? TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                style: const TextStyle(fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  hintText: 'Enter task title...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) {
                  if (_titleController.text.trim().isNotEmpty) {
                    _descriptionFocusNode.requestFocus();
                  }
                },
                onTap: () {
                  _titleController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _titleController.text.length,
                  );
                },
              )
            : const Text(
                'Add new task',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
          if (expanded) {
            // Focus on title field when expanded
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _titleFocusNode.requestFocus();
            });
          }
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocusNode,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'Enter description (optional)...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _addTask(),
                  onTap: () {
                    _descriptionController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _descriptionController.text.length,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: _cancel, child: const Text('Cancel')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
