import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/perrito.dart'; // Importa el modelo

class PerritoService {
  final String baseUrl;

  // Constructor que recibe la URL base de la API
  PerritoService({required this.baseUrl});

  // Método para obtener todos los perritos
  Future<List<Perrito>> getPerritos() async {
    final url = Uri.parse('$baseUrl/perritos'); // Ruta de la API
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON
      final List<dynamic> data = jsonDecode(response.body);
      // Convierte cada elemento en una instancia de Perrito
      return data.map((json) => Perrito.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los perritos: ${response.statusCode}');
    }
  }

  // Método para agregar un nuevo perrito
  Future<Perrito> createPerrito(Perrito perrito) async {
    final url = Uri.parse('$baseUrl/perritos'); // Ruta de la API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: perrito.toJsonString(),
    );

    if (response.statusCode == 201) {
      return Perrito.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear el perrito: ${response.statusCode}');
    }
  }

  // Método para obtener un perrito por ID
  Future<Perrito> getPerritoById(int id) async {
    final url = Uri.parse('$baseUrl/perritos/$id/'); // Añadida la barra inclinada al final
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Perrito.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el perrito: ${response.statusCode}');
    }
  }

  // Método para actualizar un perrito
  Future<Perrito> updatePerrito(Perrito perrito) async {
    final url = Uri.parse('$baseUrl/perritos/${perrito.id}/'); // Añadida la barra inclinada al final
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: perrito.toJsonString(),
    );

    if (response.statusCode == 200) {
      return Perrito.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar el perrito: ${response.statusCode}');
    }
  }

  // Método para eliminar un perrito
// Método para eliminar un perrito
Future<String> deletePerrito(int id) async {
  final url = Uri.parse('$baseUrl/perritos/$id/'); // Añadida la barra inclinada al final
  final response = await http.delete(url);

  if (response.statusCode == 204) {
    return 'Perrito eliminado con éxito';
  } else {
    throw Exception('Error al eliminar el perrito: ${response.statusCode}');
  }
}

}
