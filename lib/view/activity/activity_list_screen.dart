import 'package:flutter/material.dart';
import 'package:helmoliday/view_model/holiday/holiday_detail_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../view_model/activity/activity_list_view_model.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen(
      {super.key,
      required this.id,
      required this.activities,
      required this.onUpdated});

  final String id;
  final Future<List<Activity>> activities;
  final Future<void> onUpdated;

  @override
  State<ActivityListScreen> createState() => _ActivityListScreen();
}

class _ActivityListScreen extends State<ActivityListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HolidayDetailViewModel>(
        builder: (context, viewModel, child) => FutureBuilder(
              future: widget.activities,
              builder: (context, AsyncSnapshot<List<Activity>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erreur lors du chargement des activités'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Aucune activité trouvée'),
                  );
                } else {
                  var activities = snapshot.data;
                  return ListView.separated(
                    itemCount: activities!.length,
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activity.description),
                              Text(
                                "du ${formatDate(activity.startDate)} au ${formatDate(activity.endDate)}",
                              ),
                            ],
                          ),


                          trailing:
                          Wrap(
                            children:[
                              IconButton(
                                icon: const Icon(Icons.directions),
                                onPressed: () {
                                  viewModel.goToActivityMap(activity.id);
                                },
                              ),
                              PopupMenuButton(
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
                            ]
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ));
  }
}

String formatDate(DateTime date) {
  return DateFormat('dd-MM-yy').format(date);
}
