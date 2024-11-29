import '../model/taskfield.dart'; 
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._internal();

  static Database? _database;

  TaskDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${TaskFields.tableName} (
          ${TaskFields.id} ${TaskFields.idType},
          ${TaskFields.fecha} ${TaskFields.dateType},
          ${TaskFields.tarea} ${TaskFields.textType},
          ${TaskFields.tiempoEstimado} ${TaskFields.intType},
          ${TaskFields.descripcion} ${TaskFields.textType}
        )
      ''');
  }

  Future<TaskModel> create(TaskModel task) async {
    final db = await instance.database;
    final id = await db.insert(TaskFields.tableName, task.toJson());
    return task.copy(id: id);
  }

  Future<TaskModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      TaskFields.tableName,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TaskModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${TaskFields.fecha} DESC'; // Ordenar por fecha
    final result = await db.query(TaskFields.tableName, orderBy: orderBy);
    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<int> update(TaskModel task) async {
    final db = await instance.database;
    return db.update(
      TaskFields.tableName,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      TaskFields.tableName,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
