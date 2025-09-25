import 'package:flutter_test/flutter_test.dart';
import 'package:baston_bt_app/main.dart';
import 'package:baston_bt_app/models/session.dart';

void main() {
  setUp(() {
    // 🔹 Limpia la sesión antes de cada test
    Session.clear();
  });

  testWidgets('Muestra LoginPage si no hay sesión activa',
          (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());

        // 🔎 Verifica por texto (ajústalo al de tu LoginPage real)
        expect(find.text('Iniciar Sesión'), findsOneWidget);
      });

  testWidgets('Muestra MenuLayout si hay sesión activa',
          (WidgetTester tester) async {
        Session.start({
          "userId": "1",
          "email": "test@example.com",
          "fullName": "Usuario Test",
          "rol": "Usuario",
          "token": "fake-jwt-token",
        });

        await tester.pumpWidget(const MyApp());

        // 🔎 Verifica que aparece el texto de bienvenida de InicioPage
        expect(find.textContaining('Bienvenido'), findsOneWidget);
      });
}
