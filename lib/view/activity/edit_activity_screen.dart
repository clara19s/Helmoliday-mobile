import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../view_model/activity/edit_activity_view_model.dart';

class EditActivityScreen extends StatefulWidget {

  const EditActivityScreen({super.key, required this.id});

  final String id;

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}
class _EditActivityScreenState  extends State<EditActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => EditActivityViewModel(context, widget.id),
    child: Consumer<EditActivityViewModel>(
    builder: (context, model, child) => Scaffold(

    ),
    ),
    );
  }

}
