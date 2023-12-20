import 'package:flutter_test/flutter_test.dart';
import 'package:helmoliday/model/address.dart';
import 'package:helmoliday/widget/common/password_field.dart';
import 'package:integration_test/integration_test.dart';
import 'package:helmoliday/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> editDate(
      WidgetTester tester, DateTimeRange dateTimeRange) async {
    await tester.tap(find.text(dateTimeRange.start.day.toString()).first);
    await tester.tap(find.text(dateTimeRange.end.day.toString()).first);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();
  }

  Future<void> editAddress(WidgetTester tester, Address address) async {
    await tester.enterText(find.byKey(const Key("street")), address.street);
    await tester.enterText(
        find.byKey(const Key("streetNumber")), address.streetNumber);
    await tester.enterText(
        find.byKey(const Key("postalCode")), address.postalCode);
    await tester.enterText(find.byKey(const Key("city")), address.city);
    await tester.enterText(find.byKey(const Key("country")), address.country);
  }

  testWidgets("Create an activity, modify it and then delete it",
      (WidgetTester tester) async {
    app.main();

    // Attendre que l'application soit prête et soit sur la page d'authentification
    await tester.pumpAndSettle();

    // Se connecter
    await tester.enterText(find.byType(TextFormField).first, "lionel@bovy.dev");
    await tester.enterText(find.byType(PasswordField), "Hello&123");

    await tester.tap(find.text("Se connecter"));
    await tester.pumpAndSettle();

    // Aller sur la page des vacances
    await tester.tap(find.byIcon(Icons.beach_access));
    await tester.pumpAndSettle();

    // Cliquer sur le bouton d'ajout flottant d'une période de vacances
    await tester.tap(find.byKey(const Key("addHolidayButton")));
    await tester.pumpAndSettle();

    // Remplir le formulaire
    await tester.enterText(find.byKey(const Key("name")), "Balade à Liège");
    await tester.enterText(find.byKey(const Key("description")),
        "Une balade dans la ville de Liège...");

    // Sélectionner une date de début et de fin
    await tester.tap(find.byKey(const Key("dateTimeRange")));
    await tester.pumpAndSettle();

    await editDate(
        tester,
        DateTimeRange(
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 2)),
        ));

    // Remplir le formulaire d'adresse
    await editAddress(
        tester,
        Address(
          street: "Rue de Harlez",
          streetNumber: "25",
          postalCode: "4000",
          city: "Liège",
          country: "Belgique",
        ));

    // Fermer le clavier
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // Cliquer sur le bouton de soumission
    await tester.tap(find.byKey(const Key("submitButton")).first);

    // Attendre que la page des périodes de vacances soit affichée
    await tester.pumpAndSettle();

    // Vérifier que la période de vacances a bien été créée
    expect(find.text("Balade à Liège").first, findsOneWidget);

    // Cliquer sur la période de vacances afin de la modifier
    await tester.tap(find.text("Balade à Liège").first);
    await tester.pumpAndSettle();

    // Cliquer sur le bouton de modification
    await tester.tap(find.byKey(const Key("editHolidayButton")));
    await tester.pumpAndSettle();

    // Modifier le nom de la période de vacances
    // Remplacer le texte par "Balade à Bruxelles"
    await tester.enterText(find.byKey(const Key("name")), "Balade à Bruxelles");

    // Fermer le clavier
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // Cliquer sur le bouton de soumission
    await tester.tap(find.byKey(const Key("submitButton")).first);

    // Attendre que les informations soient mises à jour
    await Future.delayed(const Duration(seconds: 5));

    // Vérifier que la période de vacances a bien été modifiée
    expect(find.text("Balade à Bruxelles"), findsOneWidget);

    // Cliquer sur le bouton de suppression
    await tester.tap(find.byKey(const Key("deleteHolidayButton")));
    await tester.pumpAndSettle();

    // Cliquer sur le bouton de confirmation de suppression
    await tester.tap(find.byKey(const Key("confirmDeleteButton")));
    await tester.pumpAndSettle();

    // Attendre que la page des périodes de vacances soit affichée
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));

    // Vérifier que la période de vacances a bien été supprimée
    expect(find.text("Balade à Bruxelles"), findsNothing);
  });
}
