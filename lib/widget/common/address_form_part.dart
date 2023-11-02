import 'package:flutter/material.dart';

class AddressFormPart extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController streetNumberController;
  final TextEditingController postalCodeController;
  final TextEditingController cityController;
  final TextEditingController countryController;

  const AddressFormPart({
    super.key,
    required this.streetController,
    required this.streetNumberController,
    required this.postalCodeController,
    required this.cityController,
    required this.countryController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Adresse",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 8),
        TextFormField(
            controller: streetController,
            decoration: const InputDecoration(
              labelText: "Rue",
              hintText: "Rue de Harlez",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une rue';
              }
              return null;
            }),
        const SizedBox(height: 8),
        TextFormField(
            controller: streetNumberController,
            decoration: const InputDecoration(
              labelText: "Numéro de rue",
              hintText: "25",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un numéro de rue';
              }
              return null;
            }),
        const SizedBox(height: 8),
        TextFormField(
            controller: postalCodeController,
            decoration: const InputDecoration(
              labelText: "Code postal",
              hintText: "4000",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un code postal';
              }
              return null;
            }),
        const SizedBox(height: 8),
        TextFormField(
            controller: cityController,
            decoration: const InputDecoration(
              labelText: "Ville",
              hintText: "Liège",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une ville';
              }
              return null;
            }),
        const SizedBox(height: 8),
        TextFormField(
            controller: countryController,
            decoration: const InputDecoration(
              labelText: "Pays",
              hintText: "Belgique",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un pays';
              }
              return null;
            }),
      ],
    );
  }
}
