import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static bool _initialized = false;
  static String _language = "es";

  /// Inicializa la configuración de la voz
  static Future<void> init() async {
    try {
      // Idiomas disponibles
      final langs = await _tts.getLanguages;
      print("🌐 Idiomas disponibles: $langs");

      String langToUse = "es-ES"; // valor por defecto

      if (langs.contains("es-ES")) {
        langToUse = "es-ES";
      } else if (langs.contains("es")) {
        langToUse = "es";
      } else if (langs.any((l) => l.startsWith("es"))) {
        langToUse = langs.firstWhere((l) => l.startsWith("es"));
      } else if (langs.contains("en-US")) {
        langToUse = "en-US"; // fallback en inglés
      }

      await _tts.setLanguage(langToUse);
      await _tts.setPitch(1.0);      // tono normal
      await _tts.setSpeechRate(0.5); // velocidad moderada

      _language = langToUse;
      _initialized = true;

      print("✅ TTS inicializado correctamente con idioma: $_language");
    } catch (e) {
      _initialized = false;
      print("⚠️ Error al inicializar TTS: $e");
    }
  }

  /// Hablar un texto
  static Future<void> speak(String text) async {
    if (!_initialized) {
      print("⚠️ TTS no está inicializado, no se puede hablar.");
      return;
    }
    try {
      await _tts.stop(); // detener audio anterior
      await _tts.speak(text);
      print("🔊 TTS hablando: $text");
    } catch (e) {
      print("⚠️ Error al reproducir voz: $e");
    }
  }

  /// Detener la lectura
  static Future<void> stop() async {
    if (!_initialized) return;
    try {
      await _tts.stop();
    } catch (e) {
      print("⚠️ Error al detener TTS: $e");
    }
  }
}
