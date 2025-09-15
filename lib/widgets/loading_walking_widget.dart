import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWalkingWidget extends StatelessWidget {
  final String? message;

  const LoadingWalkingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4), // fondo semitransparente
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animación caminando con bastón
            Lottie.asset(
              "assets/animations/walking_cane.json",
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
