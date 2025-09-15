import 'package:flutter/material.dart';
import '../../widgets/add_contacto_modal.dart'; // 👈 ajusta ruta según tu proyecto

class UserConfianzaPage extends StatefulWidget {
  const UserConfianzaPage({super.key});

  @override
  State<UserConfianzaPage> createState() => _UserConfianzaPageState();
}

class _UserConfianzaPageState extends State<UserConfianzaPage> {
  List<String> contactos = [];
  List<String> pendientes = [];

  void _mostrarFormularioAgregar() {
    showDialog(
      context: context,
      builder: (context) => AddContactoModal(
        onEnviarInvitacion: (nombre) {
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
      contactos.add(nombre);
    });
  }

  void _rechazarSolicitud(String nombre) {
    setState(() {
      pendientes.remove(nombre);
    });
  }

  void _eliminarContacto(String nombre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar contacto de confianza'),
        content: Text('¿Seguro que deseas eliminar a "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                contactos.remove(nombre);
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos de confianza'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (pendientes.isNotEmpty) ...[
              Text(
                'Solicitudes de contactos pendientes:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              ...pendientes.map(
                    (nombre) => Card(
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
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (contactos.isNotEmpty) ...[
              Text(
                'Contactos de confianza aceptados:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              ...contactos.map(
                    (nombre) => Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(nombre),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _eliminarContacto(nombre),
                    ),
                  ),
                ),
              ),
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
