import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskDragDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskDragDemo extends StatefulWidget {
  const TaskDragDemo({super.key});

  @override
  State<TaskDragDemo> createState() => _TaskDragDemoState();
}

class _TaskDragDemoState extends State<TaskDragDemo> {
  final List<String> tasks = ["Buy Milk", "Study Flutter", "Workout"];
  final List<String> completedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DragTarget Demo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // DRAGGABLE TASKS
            Column(
              children: tasks.map((task) {
                return Draggable<String>(
                  data: task,
                  feedback: Material(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue,
                      child: Text(task,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: taskWidget(task),
                  ),
                  child: taskWidget(task),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // DRAG TARGET
            Expanded(
              child: DragTarget<String>(

                // PROPERTY 1: builder
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: candidateData.isNotEmpty
                        ? Colors.green[300]
                        : Colors.grey[300],
                    child: Text(
                      completedTasks.isEmpty
                          ? "Drop Tasks Here"
                          : completedTasks.join("\n"),
                      textAlign: TextAlign.center,
                    ),
                  );
                },

                // PROPERTY 2: onWillAcceptWithDetails
                onWillAcceptWithDetails: (details) {
                  return true;
                },

                // PROPERTY 3: onAcceptWithDetails
                onAcceptWithDetails: (details) {
                  setState(() {
                    completedTasks.add(details.data);
                    tasks.remove(details.data);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskWidget(String task) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(task),
      ),
    );
  }
}