import 'package:flutter/material.dart';
import '../widgets/add_cuidador_modal.dart';

class CuidadoresPage extends StatefulWidget {
  const CuidadoresPage({super.key});

  @override
  State<CuidadoresPage> createState() => _CuidadoresPageState();
}

class _CuidadoresPageState extends State<CuidadoresPage> {
  List<String> cuidadores = [];
  List<String> pendientes = [];

  void _mostrarFormularioAgregar() {
    showDialog(
      context: context,
      builder: (context) => AddCuidadorModal(
        onEnviarSolicitud: (nombre) {
          setState(() {
            pendientes.add(nombre);
          });
        },
      ),
    );
  }

  void _aceptarSolicitud(String nombre) {
    setState(() {
      pendientes.remove(nombre);
      cuidadores.add(nombre);
    });
  }

  void _rechazarSolicitud(String nombre) {
    setState(() {
      pendientes.remove(nombre);
    });
  }

  void _eliminarCuidador(String nombre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cuidador'),
        content: Text('¿Seguro que deseas eliminar a "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                cuidadores.remove(nombre);
              });
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuidadores'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (pendientes.isNotEmpty) ...[
              const Text(
                'Solicitudes pendientes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...pendientes.map((nombre) => Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  title: Text(nombre),
                  subtitle: const Text('Pendiente de aceptación...'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _aceptarSolicitud(nombre),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _rechazarSolicitud(nombre),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 20),
            ],
            if (cuidadores.isNotEmpty) ...[
              const Text(
                'Cuidadores aceptados:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...cuidadores.map((nombre) => Card(
                elevation: 1,
                child: ListTile(
                  title: Text(nombre),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _eliminarCuidador(nombre),
                  ),
                ),
              )),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioAgregar,
        child: const Icon(Icons.add),
      ),
    );
  }
}
