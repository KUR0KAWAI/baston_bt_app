import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5144/api";
  // ⚠️ En emulador Android usa 10.0.2.2 en lugar de localhost.
  // Si usas dispositivo físico en la misma red, pon la IP de tu PC.

  static String? token; // aquí guardaremos el JWT temporalmente

  // --- LOGIN ---
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/Auth/login");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      token = data["token"]; // guardamos el JWT
      return data;
    } else {
      print("❌ Error login: ${res.body}");
      return null;
    }
  }

  // --- REGISTER ---
  static Future<bool> register(String email, String password, String fullName, String phone) async {
    final url = Uri.parse("$baseUrl/Auth/register");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "fullName": fullName,
        "phone": phone,
      }),
    );

    return res.statusCode == 201;
  }

  // --- EJEMPLO DE ENDPOINT PROTEGIDO ---
  static Future<String?> getProtectedData() async {
    final url = Uri.parse("$baseUrl/db/health");
    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return res.body;
    } else {
      print("❌ Error protected: ${res.body}");
      return null;
    }
  }
}
