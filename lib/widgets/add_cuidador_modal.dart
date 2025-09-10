import 'package:flutter/material.dart';

class AddCuidadorModal extends StatefulWidget {
  final void Function(String) onEnviarSolicitud;

  const AddCuidadorModal({super.key, required this.onEnviarSolicitud});

  @override
  State<AddCuidadorModal> createState() => _AddCuidadorModalState();
}

class _AddCuidadorModalState extends State<AddCuidadorModal> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Agregar Cuidador'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
            hintText: 'Ingrese el nombre del cuidador...'
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final nombre = _controller.text.trim();
            if (nombre.isNotEmpty) {
              widget.onEnviarSolicitud(nombre);
              Navigator.pop(context);
            }
          },
          child: const Text('Enviar solicitud'),
        ),
      ],
    );
  }
}
