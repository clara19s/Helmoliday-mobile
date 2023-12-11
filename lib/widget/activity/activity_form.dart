import 'package:flutter/material.dart';

import '../../model/address.dart';
import '../common/address_form_part.dart';
import '../common/date_time_range_picker.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({
    super.key,
    required this.onSave,
    this.name,
    this.description,
    this.dateTimeRange,
    required this.minDate,
    required this.maxDate,
    this.address,
    this.category,
  });

  final String? name;
  final String? description;
  final DateTimeRange? dateTimeRange;
  final DateTime minDate;
  final DateTime maxDate;
  final Address? address;
  final String? category;
  final Function(Map<String, dynamic>) onSave;

  @override
  State<ActivityForm> createState() => _activityFormState();
}

class _activityFormState extends State<ActivityForm> {
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController streetNumberController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  DateTimeRange? dateTimeRange;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Préremplir les contrôleurs avec les valeurs fournies
    if (widget.name != null) nameController.text = widget.name!;
    if (widget.description != null) {
      descriptionController.text = widget.description!;
    }
    if (widget.category != null) {
      categoryController.text = widget.category!;
    } else {
      categoryController.text = 'entertainment';
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
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nom',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nom de l\'activité',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une description';
                }
                return null;
              },
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description de l\'activité',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Catégorie de l\'activité',
              ),
              value: categoryController.text,
              items: const [
                DropdownMenuItem(
                  value: 'sport',
                  child: Text('Sport'),
                ),
                DropdownMenuItem(
                  value: 'cultural',
                  child: Text('Culture'),
                ),
                DropdownMenuItem(
                  value: 'entertainment',
                  child: Text('Divertissement'),
                ),
                DropdownMenuItem(
                  value: 'gastronomic',
                  child: Text('Gastronomique'),
                ),
                DropdownMenuItem(
                  value: 'other',
                  child: Text('Autre'),
                ),
              ],
              onChanged: (value) {
                categoryController.text = value.toString();
              },
            ),
            const SizedBox(height: 16),
            DateTimeRangePicker(
                initialDateRange: widget.dateTimeRange,
                minDate: widget.minDate,
                maxDate: widget.maxDate,
                onChanged: (dateTimeRange) {
                  setState(() {
                    this.dateTimeRange = dateTimeRange;
                  });
                }),
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
                      if (_formKey.currentState!.validate()) {
                        isLoading = true;
                        await widget.onSave({
                          "name": nameController.text,
                          "description": descriptionController.text,
                          "dateTimeRange": DateTimeRange(
                            start: dateTimeRange!.start,
                            end: dateTimeRange!.end,
                          ),
                          "address": Address(
                            street: streetController.text,
                            streetNumber: streetNumberController.text,
                            postalCode: postalCodeController.text,
                            city: cityController.text,
                            country: countryController.text,
                          ),
                          "category": categoryController.text,
                        });
                        isLoading = false;
                      }
                    },
                    child: const Text('Enregistrer'),
                  ),
          ],
        ));
  }
}
