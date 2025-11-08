import 'package:intl/intl.dart';

class Task {
  int? id;
  int userId;
  String title;
  String description;
  bool completed;
  String? dueDate;

  Task({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.completed = false,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'] ?? json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ??
          json['isCompleted'] ??
          json['is_completed'] ??
          false,
      dueDate: json['dueDate'] ?? json['due_date'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'completed': completed,
    'dueDate': dueDate,
  };


  String get formattedDueDate {
    if (dueDate == null) return 'No due date';
    try {
      final date = DateTime.parse(dueDate!);
      return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(date);
    } catch (_) {
      return 'Invalid date';
    }
  }


  String get remainingTime {
    if (dueDate == null) return 'No due date';
    final due = DateTime.parse(dueDate!);
    final diff = due.difference(DateTime.now());

    if (diff.isNegative) return 'Overdue';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins left';
    if (diff.inHours < 24) return '${diff.inHours} hrs left';
    return '${diff.inDays} days left';
  }

  /// Returns true if the task is due within the next hour
  bool get isDueSoon {
    if (dueDate == null) return false;
    final due = DateTime.parse(dueDate!);
    final diff = due.difference(DateTime.now());
    return diff.inMinutes <= 60 && !diff.isNegative;
  }


  Task copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    bool? completed,
    String? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
