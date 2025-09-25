import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/local_db.dart';
import '../models/session.dart'; // 🔹 Importamos el modelo de sesión

class AuthService {
  static const String baseUrl = "http://192.168.1.4:5144/api";

  /// 🔹 Login
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/Auth/login");

    print("📤 Login → $url");
    print("Payload: ${jsonEncode({"email": email, "password": password})}");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print("📥 Respuesta login: ${res.statusCode} ${res.body}");

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // 🔹 Guardamos usuario y token en SQLite
      await LocalDb.upsertUsuarioLocal(
        id: data["userId"],
        email: data["email"],
        nombres: data["fullName"],
        apellidos: "",
        rolesJson: data["rol"] ?? "", // "Usuario" o "Contacto"
        token: data["token"],
      );

      // 🔹 Guardamos el token en kv_meta
      await LocalDb.setKv("jwt_token", data["token"]);

      // 🔹 Inicializamos la sesión en memoria
      Session.start(data);

      return data;
    } else {
      print("❌ Error login: ${res.statusCode} ${res.body}");
      return null;
    }
  }

  /// 🔹 Registro
  static Future<bool> register(
      String email, String password, String fullName, String rol) async {
    final url = Uri.parse("$baseUrl/Auth/register");

    final payload = {
      "email": email,
      "password": password,
      "fullName": fullName,
      "rol": rol, // 👈 Coincide con RegisterDto en el backend
    };

    print("📤 Registro → $url");
    print("Payload: ${jsonEncode(payload)}");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    print("📥 Respuesta registro: ${res.statusCode} ${res.body}");

    return res.statusCode == 201;
  }

  /// 🔹 Obtener usuario actual (desde BD local)
  static Future<Map<String, dynamic>?> getUsuarioActual() async {
    return await LocalDb.getUsuarioActual();
  }

  /// 🔹 Obtener token (desde kv_meta)
  static Future<String?> getToken() async {
    return await LocalDb.getKv("jwt_token");
  }

  /// 🔹 Logout
  static Future<void> logout() async {
    await LocalDb.logout();
    Session.clear(); // 🔹 Limpia la sesión en memoria
  }
}
