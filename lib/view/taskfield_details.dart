import 'package:flutter/material.dart';
import '../model/taskfield.dart';  // Ruta relativa a la carpeta model
import '../database/taskfield_database.dart';  // Ruta relativa a la carpeta database

class TaskDetailsView extends StatefulWidget {
  const TaskDetailsView({super.key, this.taskId});
  final int? taskId;

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  TaskDatabase taskDatabase = TaskDatabase.instance;

  TextEditingController tareaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController tiempoEstimadoController = TextEditingController();

  late TaskModel task;
  bool isLoading = false;
  bool isNewTask = false;

  @override
  void initState() {
    super.initState();
    refreshTask();
  }

  /// Obtiene la tarea de la base de datos y actualiza el estado si taskId no es nulo, de lo contrario, establece isNewTask a verdadero
  refreshTask() {
    if (widget.taskId == null) {
      setState(() {
        isNewTask = true;
      });
      return;
    }
    taskDatabase.read(widget.taskId!).then((value) {
      setState(() {
        task = value;
        tareaController.text = task.tarea;
        descripcionController.text = task.descripcion;
        tiempoEstimadoController.text = task.tiempoEstimado.toString();
      });
    });
  }

  createTask() {
    setState(() {
      isLoading = true;
    });
    final model = TaskModel(
      fecha: DateTime.now().toIso8601String(),
      tarea: tareaController.text,
      tiempoEstimado: int.tryParse(tiempoEstimadoController.text) ?? 0,
      descripcion: descripcionController.text,
    );
    if (isNewTask) {
      taskDatabase.create(model);
    } else {
      model.id = task.id;
      taskDatabase.update(model);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context); 
  }

  deleteTask() {
    taskDatabase.delete(task.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          Visibility(
            visible: !isNewTask,
            child: IconButton(
              onPressed: deleteTask,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: createTask,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  TextField(
                    controller: tareaController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Nombre de la tarea',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: descripcionController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Descripción',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: tiempoEstimadoController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Tiempo estimado (minutos)',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ]), 
        ),
      ),
    );
  }
}
