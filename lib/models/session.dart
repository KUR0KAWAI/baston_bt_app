// lib/models/session.dart
class SessionUser {
  final String id;
  final String email;
  final String nombres;
  final String apellidos;
  final String rol;   // "Usuario" o "Contacto"
  final String token;

  SessionUser({
    required this.id,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.rol,
    required this.token,
  });
}

class Session {
  static SessionUser? _currentUser;

  /// 🔹 Obtener el usuario actual
  static SessionUser? get currentUser => _currentUser;

  /// 🔹 Inicializar sesión después de login
  static void start(Map<String, dynamic> data) {
    _currentUser = SessionUser(
      id: data["userId"] ?? "",
      email: data["email"] ?? "",
      nombres: data["fullName"] ?? "",
      apellidos: "", // opcional
      rol: data["rol"] ?? "Usuario", // 👈 corregido ("Usuario" o "Contacto")
      token: data["token"] ?? "",
    );
  }

  /// 🔹 Cerrar sesión (limpiar datos)
  static void clear() {
    _currentUser = null;
  }

  /// 🔹 Verificar si hay sesión activa
  static bool get isActive => _currentUser != null;
}
