import 'package:flutter_test/flutter_test.dart';
import 'package:helmoliday/widget/common/password_field.dart';
import 'package:integration_test/integration_test.dart';
import 'package:helmoliday/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("User does not exist", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Remplir les champs de connexion
    await tester.enterText(find.byType(TextFormField).first, "wrong@email.com");
    await tester.enterText(find.byType(PasswordField), "Wr@ngP@ssw0rd");

    // Appuyer sur le bouton de connexion
    await tester.tap(find.text("Se connecter"));
    await tester.pumpAndSettle();

    // Vérifier l'affichage d'un message d'erreur
    expect(find.text("Exception: Utilisateur non trouvé"), findsOneWidget);
  });

  testWidgets("Invalid credentials", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Remplir les champs de connexion
    await tester.enterText(find.byType(TextFormField).first, "lionel@bovy.dev");
    await tester.enterText(find.byType(PasswordField), "Wr@ngP@ssw0rd");

    // Appuyer sur le bouton de connexion
    await tester.tap(find.text("Se connecter"));
    await tester.pumpAndSettle();

    // Vérifier l'affichage d'un message d'erreur
    expect(find.text("Exception: Identifiants invalides"), findsOneWidget);
  });

  testWidgets("Valid credentials", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Remplir les champs de connexion
    await tester.enterText(find.byType(TextFormField).first, "lionel@bovy.dev");
    await tester.enterText(find.byType(PasswordField), "Hello&123");

    // Appuyer sur le bouton de connexion
    await tester.tap(find.text("Se connecter"));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("home_screen")), findsOneWidget);
  });
}