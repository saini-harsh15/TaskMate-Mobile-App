import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;
  final int userId;
  const TaskEditScreen({super.key, this.task, required this.userId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  DateTime? due;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    descCtrl = TextEditingController(text: widget.task?.description ?? '');
    due = widget.task?.dueDate != null
        ? DateTime.tryParse(widget.task!.dueDate!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  due == null ? 'No due date' : DateFormat.yMMMd().format(due!),
                ),
                const Spacer(),
                TextButton(
                  child: const Text('Pick Date'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: due ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => due = picked);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final t = Task(
                  id: widget.task?.id,
                  userId: widget.userId,
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  completed: widget.task?.completed ?? false,
                  dueDate: due?.toIso8601String(),
                );
                Navigator.pop(context, t);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
