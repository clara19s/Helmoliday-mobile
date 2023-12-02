import 'package:flutter/material.dart';
import 'package:helmoliday/widget/holiday/holiday_form.dart';
import 'package:provider/provider.dart';

import '../../view_model/holiday/add_holiday_view_model.dart';

class AddHolidayScreen extends StatefulWidget {
  const AddHolidayScreen({super.key});

  @override
  State<AddHolidayScreen> createState() => _AddScreenHolidayState();
}

class _AddScreenHolidayState extends State<AddHolidayScreen> {
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
                  : HolidayForm(onSave: (result) async {
                    if (model.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(model.errorMessage!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                      model.addHoliday(
                          name: result['name'],
                          description: result['description'],
                          dateTimeRange: result['dateTimeRange'],
                          address: result['address']
                      );
                    }),
            ),
          ),
        ),
      ),
    );
  }
}
