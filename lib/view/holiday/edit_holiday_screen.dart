import 'package:flutter/material.dart';
import 'package:helmoliday/view_model/holiday/edit_holiday_view_model.dart';
import 'package:helmoliday/widget/holiday/holiday_form.dart';
import 'package:provider/provider.dart';

class EditHolidayScreen extends StatefulWidget {
  const EditHolidayScreen({super.key, required this.id});

  final String id;

  @override
  State<EditHolidayScreen> createState() => _EditScreenHolidayState();
}

class _EditScreenHolidayState extends State<EditHolidayScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditHolidayViewModel(context, widget.id),
      child: Consumer<EditHolidayViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Modifier une vacance'),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: FutureBuilder(
                  future: model.getHoliday(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return HolidayForm(
                        name: snapshot.data!.name,
                        description: snapshot.data!.description,
                        dateTimeRange: DateTimeRange(
                            start: snapshot.data!.startDate,
                            end: snapshot.data!.endDate),
                        address: snapshot.data!.address,
                        onSave: (editedHoliday) {
                          if (model.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(model.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          model.editHoliday(
                            name: editedHoliday['name'],
                            description: editedHoliday['description'],
                            dateTimeRange: editedHoliday['dateTimeRange'],
                            address: editedHoliday['address'],
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )),
          ),
        ),
      ),
    );
  }
}
