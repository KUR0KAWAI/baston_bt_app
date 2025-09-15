import 'package:flutter/material.dart';

class AddContactoModal extends StatefulWidget {
  final void Function(String) onEnviarInvitacion;

  const AddContactoModal({super.key, required this.onEnviarInvitacion});

  @override
  State<AddContactoModal> createState() => _AddContactoModalState();
}

class _AddContactoModalState extends State<AddContactoModal> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Agregar contacto de confianza'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Ingrese el nombre del contacto de confianza...',
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
              widget.onEnviarInvitacion(nombre);
              Navigator.pop(context);
            }
          },
          child: const Text('Enviar invitación'),
        ),
      ],
    );
  }
}
