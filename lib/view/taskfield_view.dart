import '../model/taskfield.dart';  
import '../database/taskfield_database.dart'; 
import 'package:flutter/material.dart';
import 'taskfield_details.dart';  
import 'package:intl/intl.dart';  

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  TaskDatabase taskDatabase = TaskDatabase.instance;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    refreshTasks();
  }

  @override
  dispose() {
    taskDatabase.close();
    super.dispose();
  }

  refreshTasks() {
    taskDatabase.readAll().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  goToTaskDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsView(taskId: id)),
    );
    refreshTasks(); // Refresh the task list after returning from the detail view
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {}, // You can implement search functionality if needed
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: tasks.isEmpty
            ? const Text(
                'No tienes tareas aún',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  // Format the date to a more readable format
                  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(task.fecha));
                  String formattedTime = '${task.tiempoEstimado} minutos'; // Format time estimation

                  return GestureDetector(
                    onTap: () => goToTaskDetailsView(id: task.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.black45, size: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    formattedDate,  // Display the formatted date
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                task.tarea,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                task.descripcion,
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: Colors.black45, size: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    formattedTime,  // Display the estimated time
                                    style: const TextStyle(color: Colors.black45, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToTaskDetailsView,
        tooltip: 'Crear tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}
