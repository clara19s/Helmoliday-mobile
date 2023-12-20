import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helmoliday/widget/common/password_field.dart';
import 'package:integration_test/integration_test.dart';
import 'package:helmoliday/main.dart' as app;

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("User does not exist", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

  // appuiez sur le bouton s'inscrire
  await tester.tap(find.text("S'inscrire"));
  await tester.pumpAndSettle();
  // remplir les champs de l'inscription
    await tester.enterText(find.byKey(const Key("firstName")), "Lionel");
    await tester.enterText(find.byKey(const Key("name")), "Bovy");
    await tester.enterText(find.byKey(const Key("Adresse e-mail")), "liotest@gmail.com");
    await tester.enterText(find.byType(PasswordField), "HRello&1234");

  // appuyer sur le bouton s'inscrire
  await tester.tap(find.text("S'inscrire"));
  await tester.pumpAndSettle();
  //vérifier qu'on est bien sur la page d'accueil
    expect(find.byKey(const Key("home_screen")), findsOneWidget);

    // cliquez sur le profil
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();
    // cliquez sur le bouton supprimer le compte
    await tester.tap(find.text("Supprimer mon compte"));
    await tester.pumpAndSettle();
    // confirmer la suppression
    await tester.tap(find.text("Supprimer"));
    await tester.pumpAndSettle();

  });
  testWidgets("empty label", (widgetTester) async{
    app.main();
    await widgetTester.pumpAndSettle();

    // appuiez sur le bouton s'inscrire
    await widgetTester.tap(find.text("S'inscrire"));
    await widgetTester.pumpAndSettle();
    // remplir les champs de l'inscription
    await widgetTester.enterText(find.byKey(const Key("firstName")), "truc");
    await widgetTester.enterText(find.byKey(const Key("name")), "bidule");
    await widgetTester.enterText(find.byKey(const Key("Adresse e-mail")), "");
    await widgetTester.enterText(find.byType(PasswordField), "HELOO@1234skg");

    // appuyer sur le bouton s'inscrire
    await widgetTester.tap(find.text("S'inscrire"));
    await widgetTester.pumpAndSettle();
    // veirfier message d'erreur
    expect(find.text("L'adresse e-mail ne peut pas être vide"), findsOneWidget);

  });

  testWidgets("invalid email", (widgetTester) async{
    app.main();
    await widgetTester.pumpAndSettle();

    // appuiez sur le bouton s'inscrire
    await widgetTester.tap(find.text("S'inscrire"));
    await widgetTester.pumpAndSettle();
    // remplir les champs de l'inscription
    await widgetTester.enterText(find.byKey(const Key("firstName")), "truc");
    await widgetTester.enterText(find.byKey(const Key("name")), "bidule");
    await widgetTester.enterText(find.byKey(const Key("Adresse e-mail")), "trucbidule");
    await widgetTester.enterText(find.byType(PasswordField), "HELOO@1234skg");

    // appuyer sur le bouton s'inscrire
    await widgetTester.tap(find.text("S'inscrire"));
    await widgetTester.pumpAndSettle();
    // veirfier message d'erreur
    expect(find.text("L'adresse e-mail n'est pas valide"), findsOneWidget);
  });

}