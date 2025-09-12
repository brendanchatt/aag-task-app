import 'dart:convert';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/task_status_filter.dart';
import 'package:path/path.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'package:sqflite/sqflite.dart';

final tasksProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
  isAutoDispose: true,
);

final filterProvider = NotifierProvider<FilterNotifier, TaskStatusFilter>(
  FilterNotifier.new,
);

class FilterNotifier extends Notifier<TaskStatusFilter> {
  @override
  TaskStatusFilter build() => TaskStatusFilter.all;

  void setFilter(TaskStatusFilter filter) {
    state = filter;
  }
}

final storageProvider = FutureProvider<Storage<String, String>>((ref) async {
  // Initialize SQFlite. We should share the Storage instance between providers.
  return JsonSqFliteStorage.open(join(await getDatabasesPath(), 'riverpod.db'));
});

const _uuid = Uuid();

class TaskNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    // here is persistence in action if you were wondering
    await persist(
      ref.watch(storageProvider.future),
      key: 'task_list',
      encode: (tasks) => jsonEncode(tasks.map((task) => task.toMap()).toList()),
      decode: (json) {
        final decoded = jsonDecode(json) as List;
        return decoded
            .map((taskData) => Task.fromMap(taskData as Map<String, Object?>))
            .toList();
      },
    ).future;

    if (state.value case final value?) {
      state = AsyncData(value);
      return value;
    }

    return state.value ?? [];
  }

  void add(String title, String? description) {
    state = AsyncData([
      ...state.value!,
      Task(
        id: _uuid.v4(),
        title: title,
        description: description?.trim().isEmpty == true
            ? null
            : description?.trim(),
        isCompleted: false,
      ),
    ]);
  }

  void toggle(String id) {
    state = AsyncData([
      for (final task in state.value!)
        if (task.id == id)
          Task(
            id: task.id,
            isCompleted: !task.isCompleted,
            title: task.title,
            description: task.description,
          )
        else
          task,
    ]);
  }

  void edit({required String id, required String title, String? description}) {
    state = AsyncValue.data([
      for (final task in state.value!)
        if (task.id == id)
          Task(
            id: task.id,
            isCompleted: task.isCompleted,
            title: title,
            description: description?.trim().isEmpty == true
                ? null
                : description?.trim(),
          )
        else
          task,
    ]);
  }

  void remove(String id) {
    state = AsyncValue.data(
      state.value!.where((todo) => todo.id != id).toList(),
    );
  }

  List<Task> getFilteredTasks(TaskStatusFilter filter) {
    if (state.value == null) return [];

    switch (filter) {
      case TaskStatusFilter.all:
        return state.value!;
      case TaskStatusFilter.active:
        return state.value!.where((task) => !task.isCompleted).toList();
      case TaskStatusFilter.completed:
        return state.value!.where((task) => task.isCompleted).toList();
    }
  }
}
