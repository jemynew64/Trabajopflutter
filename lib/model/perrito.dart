import 'dart:convert';


class Perrito {
  final int? id;
  final String nombre;
  final int edad;
  final String raza;

  Perrito({this.id, required this.nombre, required this.edad, required this.raza});

  factory Perrito.fromJson(Map<String, dynamic> json) {
    return Perrito(
      id: json['id'],
      nombre: json['nombre'],
      edad: json['edad'],
      raza: json['raza'],
    );
  }

  String toJsonString() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'edad': edad,
      'raza': raza,
    };

    if (id != null) {
      data['id'] = id;
    }

    return jsonEncode(data);
  }
}
