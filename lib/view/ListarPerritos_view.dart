import 'package:flutter/material.dart';
import '../model/perrito.dart';
import '../services/perrito_service.dart';

class ListarPerritos extends StatefulWidget {
  @override
  _ListarPerritosState createState() => _ListarPerritosState();
}

class _ListarPerritosState extends State<ListarPerritos> {
  final PerritoService _perritoService = PerritoService(baseUrl: 'http://192.168.0.114:8000/api');
  late Future<List<Perrito>> _futurePerritos;

  @override
  void initState() {
    super.initState();
    _futurePerritos = _perritoService.getPerritos(); // Cargar la lista inicial
  }

  // Método para eliminar un perrito
  void _eliminarPerrito(int id) async {
    try {
      // Llamamos al servicio para eliminar el perrito y obtener el mensaje de éxito
      String message = await _perritoService.deletePerrito(id);

      // Actualizamos el estado para eliminar el perrito de la lista
      setState(() {
        _futurePerritos = _perritoService.getPerritos(); // Volver a cargar la lista
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)), // Mostrar el mensaje de éxito
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el perrito')),
      );
    }
  }

  // Método para recargar la lista de perritos cuando se arrastra hacia abajo
  Future<void> _recargarPerritos() async {
    setState(() {
      _futurePerritos = _perritoService.getPerritos(); // Recargar los datos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listar Perritos'),
      ),
      body: FutureBuilder<List<Perrito>>(
        future: _futurePerritos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay perritos disponibles.'));
          }

          final perritos = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _recargarPerritos, // Acción de recarga al arrastrar hacia abajo
            child: ListView.builder(
              itemCount: perritos.length,
              itemBuilder: (context, index) {
                final perrito = perritos[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(perrito.nombre[0].toUpperCase()), // Primera letra del nombre
                  ),
                  title: Text(perrito.nombre),
                  subtitle: Text('Edad: ${perrito.edad}, Raza: ${perrito.raza}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarPerrito(perrito.id!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
