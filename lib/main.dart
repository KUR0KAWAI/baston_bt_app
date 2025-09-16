import 'package:flutter/material.dart';
import 'pages/menu_layout.dart';
import 'pages/login_page.dart';
import 'services/db_bootstrap.dart';
import 'services/tts_service.dart'; // 👈 servicio TTS
import 'theme/app_theme.dart';

// 🔹 Rol por defecto (se puede cambiar a "confianza" o "usuario")
const String defaultRol = "usuario";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔊 Inicializar TTS con validación
  try {
    await TtsService.init();
    print("✅ TTS inicializado correctamente");
  } catch (e) {
    print("⚠️ No se pudo inicializar TTS en main: $e");
  }

  // 🚀 Inicia la app con el rol por defecto
  runApp(const MyApp(rol: defaultRol));

  // Inicializar BD en background (no bloquea UI)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await DbBootstrap.init();
      await DbBootstrap.logDebugInfo();
    } catch (e) {
      print("⚠️ Error en DbBootstrap: $e");
    }
  });
}

class MyApp extends StatelessWidget {
  final String rol;
  const MyApp({super.key, required this.rol});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PathSense',
      theme: AppTheme.lightTheme, // 🎨 Tema centralizado
      initialRoute: '/menu',
      routes: {
        '/login': (context) => const LoginPage(),
        '/menu': (context) => MenuLayout(rol: rol), // ✅ rol dinámico
      },
    );
  }
}
