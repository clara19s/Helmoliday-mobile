import 'package:flutter/material.dart';
import 'package:helmoliday/model/activity.dart';
import 'package:provider/provider.dart';

import '../../view_model/activity/add_activity_view_model.dart';
import '../../widget/activity/activity_form.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen(
      {super.key, required this.id, required this.holidayDateRange});

  final String id;
  final DateTimeRange holidayDateRange;

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AddActivityViewModel(context, widget.id, widget.holidayDateRange),
      child: Consumer<AddActivityViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Ajouter une activité'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: model.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ActivityForm(
                      minDate: widget.holidayDateRange.start,
                      maxDate: widget.holidayDateRange.end,
                      onSave: (result) async {
                        var category = ActivityCategory.values.firstWhere((e) =>
                            e.toString() ==
                            'ActivityCategory.${result['category'].toLowerCase()}');
                        model.addActivity(
                          name: result['name'],
                          description: result['description'],
                          dateTimeRange: result['dateTimeRange'],
                          address: result['address'],
                          category: category,
                        );
                      }),
            ),
          ),
        ),
      ),
    );
  }
}
