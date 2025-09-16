import 'package:flutter/material.dart';

class AddZonaSeguraDialog extends StatefulWidget {
  const AddZonaSeguraDialog({super.key});

  @override
  State<AddZonaSeguraDialog> createState() => _AddZonaSeguraDialogState();
}

class _AddZonaSeguraDialogState extends State<AddZonaSeguraDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva Zona Segura"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: "Ingrese el nombre de la zona",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
