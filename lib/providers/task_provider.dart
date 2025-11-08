import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

enum TaskSortOption { newest, oldest, completedFirst, pendingFirst }

class TaskProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<Task> _tasks = [];
  bool loading = false;
  TaskSortOption sortOption = TaskSortOption.newest;
  int userId = 0;

  String searchQuery = "";

  List<Task> get tasks {
    final copy = List<Task>.from(_tasks);

    switch (sortOption) {
      case TaskSortOption.newest:
        copy.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
      case TaskSortOption.oldest:
        copy.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        break;
      case TaskSortOption.completedFirst:
        copy.sort(
              (a, b) => (b.completed ? 1 : 0).compareTo(a.completed ? 1 : 0),
        );
        break;
      case TaskSortOption.pendingFirst:
        copy.sort(
              (a, b) => (a.completed ? 1 : 0).compareTo(b.completed ? 1 : 0),
        );
        break;
    }

    if (searchQuery.isNotEmpty) {
      return copy.where((t) =>
      t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    return copy;
  }

  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    final completed = _tasks.where((t) => t.completed).length;
    return completed / _tasks.length;
  }

  void setSearchQuery(String q) {
    searchQuery = q;
    notifyListeners();
  }

  Future<void> loadTasks(int uid) async {
    loading = true;
    userId = uid;
    notifyListeners();
    try {
      _tasks = await _api.fetchTasks(uid);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title, String description, DateTime? due) async {
    final t = Task(
      userId: userId,
      title: title,
      description: description,
      dueDate: due?.toIso8601String(),
    );
    final created = await _api.createTask(t);
    _tasks.add(created);
    notifyListeners();
  }

  Future<void> updateTask(Task t) async {
    final updated = await _api.updateTask(t);
    final idx = _tasks.indexWhere((e) => e.id == updated.id);
    if (idx >= 0) _tasks[idx] = updated;
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await _api.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> toggleComplete(Task t) async {
    t.completed = !t.completed;
    await updateTask(t);
  }


  void setSort(TaskSortOption opt) {
    sortOption = opt;
    notifyListeners();
  }
}
