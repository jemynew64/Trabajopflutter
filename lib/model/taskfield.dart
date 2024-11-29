class TaskFields {
  static const List<String> values = [
    id,
    fecha,
    tarea,
    tiempoEstimado,
    descripcion,
  ];

  static const String tableName = 'tasks';

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String dateType = 'TEXT NOT NULL'; // Para la fecha

  static const String id = '_id';
  static const String fecha = 'fecha'; // Cambié el nombre a 'fecha'
  static const String tarea = 'tarea';
  static const String tiempoEstimado = 'tiempo_estimado'; // Cambié el nombre
  static const String descripcion = 'descripcion';
}

class TaskModel {
  int? id;
  final String fecha; // Usaremos String para almacenar la fecha en formato 'YYYY-MM-DD'
  final String tarea;
  final int tiempoEstimado; // En minutos, como en el ejemplo
  final String descripcion;

  TaskModel({
    this.id,
    required this.fecha,
    required this.tarea,
    required this.tiempoEstimado,
    required this.descripcion,
  });

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.fecha: fecha,
        TaskFields.tarea: tarea,
        TaskFields.tiempoEstimado: tiempoEstimado,
        TaskFields.descripcion: descripcion,
      };

  factory TaskModel.fromJson(Map<String, Object?> json) => TaskModel(
        id: json[TaskFields.id] as int?,
        fecha: json[TaskFields.fecha] as String, // Fecha almacenada como String
        tarea: json[TaskFields.tarea] as String,
        tiempoEstimado: json[TaskFields.tiempoEstimado] as int,
        descripcion: json[TaskFields.descripcion] as String,
      );

  TaskModel copy({
    int? id,
    String? fecha,
    String? tarea,
    int? tiempoEstimado,
    String? descripcion,
  }) =>
      TaskModel(
        id: id ?? this.id,
        fecha: fecha ?? this.fecha,
        tarea: tarea ?? this.tarea,
        tiempoEstimado: tiempoEstimado ?? this.tiempoEstimado,
        descripcion: descripcion ?? this.descripcion,
      );
}
