import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

class Task {
  final String title;
  final String description;
  final Priority priority;
  final DateTime createdAt;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false,
  }) : createdAt = DateTime.now();
}

enum Priority { low, medium, high }

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [
    Task(
      title: "Complete Flutter Project",
      description: "Finish the task manager app with all features",
      priority: Priority.high,
      isCompleted: true,
    ),
    Task(
      title: "Buy groceries",
      description: "Milk, Eggs, Bread, Fruits",
      priority: Priority.medium,
    ),
    Task(
      title: "Schedule dentist appointment",
      description: "Call to book appointment for next week",
      priority: Priority.low,
    ),
    Task(
      title: "Prepare presentation",
      description: "Create slides for Monday's meeting",
      priority: Priority.high,
    ),
  ];

  // 1. ADD A NEW TASK
  void _addTask(String title, String description, Priority priority) {
    setState(() {
      tasks.add(Task(
        title: title,
        description: description,
        priority: priority,
      ));
    });
  }

  // 2. MARK TASK AS COMPLETED
  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  // 3. DELETE TASK WITH CONFIRMATION
  void _deleteTaskWithConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text(
          'Are you sure you want to delete "${tasks[index].title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteTask(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task "${tasks[index].title}" deleted'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // 4. SHOW ADD TASK DIALOG
  void _showAddTaskDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    Priority selectedPriority = Priority.medium;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  const Text('Priority'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPriorityChip(
                        'Low',
                        Priority.low,
                        selectedPriority,
                            () => setState(() => selectedPriority = Priority.low),
                      ),
                      _buildPriorityChip(
                        'Medium',
                        Priority.medium,
                        selectedPriority,
                            () => setState(() => selectedPriority = Priority.medium),
                      ),
                      _buildPriorityChip(
                        'High',
                        Priority.high,
                        selectedPriority,
                            () => setState(() => selectedPriority = Priority.high),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    _addTask(
                      titleController.text.trim(),
                      descController.text.trim(),
                      selectedPriority,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriorityChip(String label, Priority priority, Priority selected, VoidCallback onTap) {
    final Color color = priority == Priority.low
        ? Colors.green
        : priority == Priority.medium
        ? Colors.orange
        : Colors.red;

    return ChoiceChip(
      label: Text(label),
      selected: selected == priority,
      selectedColor: color.withOpacity(0.2),
      onSelected: (selected) => onTap(),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(
        color: selected == priority ? color : Colors.grey,
        fontWeight: selected == priority ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          // STATISTICS
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', '${tasks.length}', Colors.blue),
                _buildStatCard('Completed', '$completedTasks', Colors.green),
                _buildStatCard('Pending', '$pendingTasks', Colors.orange),
              ],
            ),
          ),

          // 2. VIEW LIST OF TASKS
          Expanded(
            child: tasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tasks yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to add your first task',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) => _toggleTaskCompletion(index),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: TextStyle(
                            color: task.isCompleted ? Colors.grey : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(task.priority).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _getPriorityColor(task.priority),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getPriorityText(task.priority),
                                style: TextStyle(
                                  color: _getPriorityColor(task.priority),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (task.isCompleted)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                            const SizedBox(width: 4),
                            Text(
                              task.isCompleted ? 'Completed' : 'Pending',
                              style: TextStyle(
                                color: task.isCompleted ? Colors.green : Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => _toggleTaskCompletion(index),
                          child: Row(
                            children: [
                              Icon(
                                task.isCompleted
                                    ? Icons.radio_button_unchecked
                                    : Icons.check_circle,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task.isCompleted
                                    ? 'Mark as Pending'
                                    : 'Mark as Completed',
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => _deleteTaskWithConfirmation(index),
                          child: const Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete Task'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}