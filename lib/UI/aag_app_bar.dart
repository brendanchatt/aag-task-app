import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_status_filter.dart';
import '../state/task_notifier.dart';

class AAGAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AAGAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(filterProvider);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Center(child: const Text("AAG Task App (logo)")),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
          child: SegmentedButton<TaskStatusFilter>(
            segments: TaskStatusFilter.values
                .map(
                  (filter) => ButtonSegment<TaskStatusFilter>(
                    value: filter,
                    label: Text(
                      filter.displayName,
                      style: TextStyle(
                        color: currentFilter == filter ? null : Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
            selected: {currentFilter},
            showSelectedIcon: false,
            onSelectionChanged: (Set<TaskStatusFilter> selection) {
              ref.read(filterProvider.notifier).setFilter(selection.first);
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
