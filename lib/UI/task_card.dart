import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../state/task_notifier.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard(this.task, {super.key});
  final Task task;

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  bool _isEditingTitle = false;
  bool _isEditingDescription = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTitle() {
    if (_titleController.text.trim().isNotEmpty) {
      ref
          .read(tasksProvider.notifier)
          .edit(
            id: widget.task.id,
            title: _titleController.text.trim(),
            description: widget.task.description,
          );
    }
    setState(() {
      _isEditingTitle = false;
    });
  }

  void _saveDescription() {
    final description = _descriptionController.text.trim();
    ref
        .read(tasksProvider.notifier)
        .edit(
          id: widget.task.id,
          title: widget.task.title,
          description: description.isEmpty ? null : description,
        );
    setState(() {
      _isEditingDescription = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.task.id),
      onDismissed: (_) {
        ref.read(tasksProvider.notifier).remove(widget.task.id);
      },
      child: Card(
        color: widget.task.isCompleted ? Colors.green.shade50 : Colors.white,
        elevation: widget.task.isCompleted ? 2 : 4,
        child: ExpansionTile(
          leading: Checkbox(
            value: widget.task.isCompleted,
            onChanged: (value) {
              ref.read(tasksProvider.notifier).toggle(widget.task.id);
            },
            activeColor: Colors.green,
          ),
          title: _isEditingTitle
              ? TextField(
                  controller: _titleController,
                  style: TextStyle(
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: widget.task.isCompleted
                        ? Colors.grey.shade600
                        : Colors.black,
                    fontWeight: widget.task.isCompleted
                        ? FontWeight.normal
                        : FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  autofocus: true,
                  onSubmitted: (_) => _saveTitle(),
                  onTapOutside: (_) => _saveTitle(),
                  onTap: () {
                    // Select all text when tapping to edit
                    _titleController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _titleController.text.length,
                    );
                  },
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditingTitle = true;
                    });
                  },
                  child: Text(
                    widget.task.title,
                    style: TextStyle(
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: widget.task.isCompleted
                          ? Colors.grey.shade600
                          : Colors.black,
                      fontWeight: widget.task.isCompleted
                          ? FontWeight.normal
                          : FontWeight.w500,
                    ),
                  ),
                ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isEditingDescription
                  ? TextField(
                      controller: _descriptionController,
                      style: TextStyle(
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: widget.task.isCompleted
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter description (optional)...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: null,
                      autofocus: true,
                      onSubmitted: (_) => _saveDescription(),
                      onTapOutside: (_) => _saveDescription(),
                      onTap: () {
                        // Select all text when tapping to edit
                        _descriptionController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _descriptionController.text.length,
                        );
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditingDescription = true;
                        });
                      },
                      child: Text(
                        widget.task.description?.isEmpty ?? true
                            ? 'Tap to add description'
                            : widget.task.description!,
                        style: TextStyle(
                          decoration: widget.task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: (widget.task.description?.isEmpty ?? true)
                              ? Colors.grey.shade500
                              : widget.task.isCompleted
                              ? Colors.grey.shade600
                              : Colors.black87,
                          fontStyle: (widget.task.description?.isEmpty ?? true)
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
