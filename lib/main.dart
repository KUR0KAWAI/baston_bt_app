import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 necesario para controlar la orientación
import 'pages/menu_layout.dart';
import 'pages/login_page.dart';
import 'services/db_bootstrap.dart';
import 'services/tts_service.dart'; // 👈 servicio TTS
import 'theme/app_theme.dart';
import 'models/session.dart'; // 👈 importamos la sesión

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Forzar orientación solo en vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 🔊 Inicializar TTS con validación
  try {
    await TtsService.init();
    print("✅ TTS inicializado correctamente");
  } catch (e) {
    print("⚠️ No se pudo inicializar TTS en main: $e");
  }

  // Inicializar BD en background (no bloquea UI)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await DbBootstrap.init();
      await DbBootstrap.logDebugInfo();
    } catch (e) {
      print("⚠️ Error en DbBootstrap: $e");
    }
  });

  // 🚀 Inicia la app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser; // 👈 verificamos si hay sesión activa

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PathSense',
      theme: AppTheme.lightTheme, // 🎨 Tema centralizado
      home: user == null
          ? const LoginPage() // 🔹 si no hay sesión, login
          : const MenuLayout(), // 🔹 si hay sesión, menú según rol
      routes: {
        '/login': (context) => const LoginPage(),
        '/menu': (context) => const MenuLayout(),
      },
    );
  }
}
