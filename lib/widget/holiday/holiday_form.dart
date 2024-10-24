import 'package:flutter/material.dart';

import '../../model/address.dart';
import '../common/address_form_part.dart';
import '../common/date_time_range_picker.dart';

class HolidayForm extends StatefulWidget {
  const HolidayForm({
    super.key,
    required this.onSave,
    this.name,
    this.description,
    this.dateTimeRange,
    this.address,
  });

  final String? name;
  final String? description;
  final DateTimeRange? dateTimeRange;
  final Address? address;
  final Function(Map<String, dynamic>) onSave;

  @override
  State<HolidayForm> createState() => _HolidayFormState();
}

class _HolidayFormState extends State<HolidayForm> {
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController streetNumberController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Préremplir les contrôleurs avec les valeurs fournies
    if (widget.name != null) nameController.text = widget.name!;
    if (widget.description != null) {
      descriptionController.text = widget.description!;
    }
    if (widget.address != null) {
      streetController.text = widget.address!.street;
      streetNumberController.text = widget.address!.streetNumber;
      postalCodeController.text = widget.address!.postalCode;
      cityController.text = widget.address!.city;
      countryController.text = widget.address!.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Informations générales",
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Nom de la période",
            hintText: "Balade à Liège",
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: descriptionController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: "Description",
            hintText: "Une balade dans la ville de Liège...",
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 8),
        DateTimeRangePicker(
          initialDateRange: widget.dateTimeRange,
          onChanged: (DateTimeRange value) {},
        ),
        const SizedBox(height: 16),
        AddressFormPart(
          streetController: streetController,
          streetNumberController: streetNumberController,
          postalCodeController: postalCodeController,
          cityController: cityController,
          countryController: countryController,
        ),
        const SizedBox(height: 16),
        isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  await widget.onSave({
                    "name": nameController.text,
                    "description": descriptionController.text,
                    "dateTimeRange": DateTimeRange(
                      start: DateTime.now(),
                      end: DateTime.now(),
                    ),
                    "address": Address(
                      street: streetController.text,
                      streetNumber: streetNumberController.text,
                      postalCode: postalCodeController.text,
                      city: cityController.text,
                      country: countryController.text,
                    ),
                  });
                  isLoading = false;
                },
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
      ],
    );
  }
}
