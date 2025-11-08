import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_tile.dart';
import 'task_edit_screen.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      context.read<TaskProvider>().loadTasks(auth.user!.id);
    });
  }

  void openAdd() async {
    final uid = context.read<AuthProvider>().user!.id;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskEditScreen(userId: uid)),
    );

    if (result is! Task) return;
    final due = result.dueDate == null
        ? null
        : DateTime.tryParse(result.dueDate.toString());

    await context.read<TaskProvider>().addTask(
      result.title,
      result.description,
      due,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tp = context.watch<TaskProvider>();
    final theme = context.watch<ThemeProvider>();

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress = tp.completionRate;

    return Scaffold(
      backgroundColor: theme.isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('TaskMate', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        foregroundColor: theme.isDarkMode ? Colors.white : Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAdd,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),

      body: RefreshIndicator(
        onRefresh: () => tp.loadTasks(auth.user!.id),
        child: Column(
          children: [
            // 🔍 Search + Sort Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: tp.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: "Search tasks...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: theme.isDarkMode ? Colors.grey[850] : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilterChip(
                    label: const Text("Sort"),
                    selected: false,
                    avatar: const Icon(Icons.sort),
                    onSelected: (_) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => _buildSortSheet(context, tp),
                      );
                    },
                  ),
                ],
              ),
            ),

           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Task Progress", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 400),
                      builder: (_, val, __) => LinearProgressIndicator(
                        value: val,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: tp.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: tp.tasks.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: TaskTile(
                    task: tp.tasks[i],
                    onToggle: () => tp.toggleComplete(tp.tasks[i]),
                    onEdit: () async {
                      final edited = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskEditScreen(
                            task: tp.tasks[i],
                            userId: tp.tasks[i].userId,
                          ),
                        ),
                      );
                      if (edited is Task) await tp.updateTask(edited);
                    },
                    onDelete: () => tp.deleteTask(tp.tasks[i].id!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortSheet(BuildContext context, TaskProvider tp) {
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          title: const Text("Newest"),
          onTap: () => { tp.setSort(TaskSortOption.newest), Navigator.pop(context) },
        ),
        ListTile(
          title: const Text("Oldest"),
          onTap: () => { tp.setSort(TaskSortOption.oldest), Navigator.pop(context) },
        ),
        ListTile(
          title: const Text("Completed First"),
          onTap: () => { tp.setSort(TaskSortOption.completedFirst), Navigator.pop(context) },
        ),
        ListTile(
          title: const Text("Pending First"),
          onTap: () => { tp.setSort(TaskSortOption.pendingFirst), Navigator.pop(context) },
        ),
      ]),
    );
  }
}   