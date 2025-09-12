import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_status_filter.dart';
import '../state/task_notifier.dart';
import 'add_task_tile.dart';
import 'aag_app_bar.dart';
import 'task_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final currentFilter = ref.watch(filterProvider);

    return Scaffold(
      appBar: const AAGAppBar(),
      body: switch (tasks) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError() => Center(child: Text(tasks.error.toString())),
        AsyncData() => Builder(
          builder: (context) {
            final filteredTasks = ref
                .read(tasksProvider.notifier)
                .getFilteredTasks(currentFilter);
            final shouldShowAddTask =
                currentFilter != TaskStatusFilter.completed;
            return ListView.separated(
              itemCount:
                  filteredTasks.length +
                  (shouldShowAddTask
                      ? 1
                      : 0), // +1 for AddTaskTile if not completed filter
              itemBuilder: (context, index) {
                if (shouldShowAddTask && index == filteredTasks.length) {
                  // Add the AddTaskTile at the bottom
                  return const AddTaskTile();
                }
                return TaskCard(filteredTasks[index]);
              },
              separatorBuilder: (context, index) {
                if (shouldShowAddTask && index == filteredTasks.length - 1) {
                  // Add extra spacing before the AddTaskTile
                  return const SizedBox(height: 16);
                }
                return const SizedBox(height: 8);
              },
            );
          },
        ),
      },
    );
  }
}
