import 'package:flutter/material.dart';
import 'pages/menu_layout.dart';
import 'pages/login_page.dart';
import 'services/db_bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  // ⬇️ LOG de BD tras el primer frame (no altera tu UI)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await DbBootstrap.init();
      await DbBootstrap.logDebugInfo(); // imprime BD, clave y tablas en consola
    } catch (_) {/*silencio en prod*/}
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PathSense',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/menu',
      routes: {
        '/login': (context) => const LoginPage(),
        '/menu': (context) => const MenuLayout(),
      },
    );
  }
}

