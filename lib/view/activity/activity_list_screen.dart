import 'package:flutter/material.dart';
import 'package:helmoliday/view_model/activity/activity_view_model.dart';
import 'package:provider/provider.dart';

// todo delele this import
import '../../model/activity.dart';
import '../../view_model/activity/activity_list_view_model.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key, required this.id});

  final String id;

  @override
  State<ActivityListScreen> createState() => _ActivityListScreen();
}

class _ActivityListScreen extends State<ActivityListScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext nContext) =>
          ActivityListViewModel(nContext, widget.id),
      child: Consumer<ActivityListViewModel>(
        builder: (context, viewModel, child) => FutureBuilder(
            future: viewModel.activities,
            builder: (context, AsyncSnapshot<List<Activity>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var activities = snapshot.data;
                if (activities == null || activities.isEmpty) {
                  return const Center(
                    child: Text('Aucune activité'),
                  );
                }

                return ListView.separated(
                  itemCount: activities.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var activity = activities[index];
                    return Dismissible(
                      key: Key(activity.id!),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        viewModel.deleteActivity(activity.id!);
                      },
                      child: ListTile(
                        title: Text(activity.name),
                        subtitle: Text(activity.description),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Modifier'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Supprimer'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              viewModel.goToEditActivity(activity.id!);
                            } else if (value == 'delete') {
                              viewModel.deleteActivity(activity.id!);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
