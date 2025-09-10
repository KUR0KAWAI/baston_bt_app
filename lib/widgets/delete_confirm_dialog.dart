import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirmar;

  const DeleteConfirmDialog({super.key, required this.onConfirmar});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar Cuidador'),
      content: const Text('¿Estás seguro de que deseas eliminar este cuidador?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            onConfirmar();
            Navigator.pop(context);
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
