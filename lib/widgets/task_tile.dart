import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? due = task.dueDate != null
        ? DateTime.tryParse(task.dueDate!)
        : null;
    String dueLabel = '';
    if (due != null) {
      final now = DateTime.now();
      if (DateTime(
        due.year,
        due.month,
        due.day,
      ).isBefore(DateTime(now.year, now.month, now.day))) {
        dueLabel = 'Overdue • ${DateFormat.yMMMd().format(due)}';
      } else if (DateTime(due.year, due.month, due.day) ==
          DateTime(now.year, now.month, now.day)) {
        dueLabel = 'Today • ${DateFormat.yMMMd().format(due)}';
      } else {
        dueLabel = '${DateFormat.yMMMd().format(due)}';
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(value: task.completed, onChanged: (_) => onToggle()),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            if (dueLabel.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(dueLabel, style: const TextStyle(fontSize: 12)),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit') onEdit();
            if (v == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
