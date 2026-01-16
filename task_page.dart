// task_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final Box<Task> box = Hive.box<Task>('tasks');
  final TextEditingController controller = TextEditingController();

  void _addTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'What do you want to do?',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    box.add(Task(title: controller.text.trim()));
                  }
                  controller.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = box.getAt(index)!;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: task.completed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (value) {
                      task.completed = value!;
                      task.save();
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                      task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    '${task.createdAt.hour.toString().padLeft(2, '0')}:${task.createdAt.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => task.delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}