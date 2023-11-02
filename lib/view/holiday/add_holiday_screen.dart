import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:provider/provider.dart';

import '../../model/address.dart';
import '../../view_model/holiday/add_holiday_view_model.dart';
import '../../widget/common/address_form_part.dart';
import '../../widget/common/date_time_range_picker.dart';

class AddHolidayScreen extends StatefulWidget {
  const AddHolidayScreen({super.key});

  @override
  State<AddHolidayScreen> createState() => _AddScreenHolidayState();
}

class _AddScreenHolidayState extends State<AddHolidayScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dates
  DateTime? _startDate;
  DateTime? _endDate;

  // Controlleurs pour l'adresse
  final _streetController = TextEditingController();
  final _streetNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddHolidayViewModel(context),
      child: Consumer<AddHolidayViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Ajouter une vacance'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: model.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Informations générales",
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Nom de la période",
                            hintText: "Balade à Liège",
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            hintText: "Une balade dans la ville de Liège...",
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DateTimeRangePicker(
                          onChanged: (DateTimeRange value) {
                            setState(() {
                              _startDate = value.start;
                              _endDate = value.end;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        AddressFormPart(
                          streetController: _streetController,
                          streetNumberController: _streetNumberController,
                          postalCodeController: _postalCodeController,
                          cityController: _cityController,
                          countryController: _countryController,
                        ),
                        const SizedBox(height: 16),
                        model.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Enregistrement en cours..."),
                                    ),
                                  );

                                  await model.addHoliday(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    dateTimeRange: DateTimeRange(
                                      start: _startDate!,
                                      end: _endDate!,
                                    ),
                                    address: Address(
                                      street: _streetController.text,
                                      streetNumber:
                                          _streetNumberController.text,
                                      postalCode: _postalCodeController.text,
                                      city: _cityController.text,
                                      country: _countryController.text,
                                    ),
                                  );
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
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
