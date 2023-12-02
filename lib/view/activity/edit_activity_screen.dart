import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../view_model/activity/edit_activity_view_model.dart';
import '../../widget/activity/activity_form.dart';

class EditActivityScreen extends StatefulWidget {
  const EditActivityScreen({super.key, required this.id});

  final String id;

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditActivityViewModel(context, widget.id),
      child: Consumer<EditActivityViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Modifier une activité'),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: model.getDetailActivity(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ActivityForm(
                        name: snapshot.data!.name,
                        description: snapshot.data!.description,
                        dateTimeRange: DateTimeRange(
                            start: snapshot.data!.startDate,
                            end: snapshot.data!.endDate),
                        address: snapshot.data!.address,
                        category: snapshot.data!.category.name,
                        onSave: (editedActivity) {
                          var category = ActivityCategory.values.firstWhere(
                                  (e) => e.toString() == 'ActivityCategory.${editedActivity['category'].toLowerCase()}');
                          model.editActivity(
                            name: editedActivity['name'],
                            description: editedActivity['description'],
                            dateTimeRange: editedActivity['dateTimeRange'],
                            address: editedActivity['address'],
                            category: category,
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
