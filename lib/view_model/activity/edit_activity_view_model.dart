import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/model/address.dart';
import 'package:helmoliday/repository/activity_repository.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';

class EditActivityViewModel extends ChangeNotifier{
  late final ActivityRepository _activityRepository;
  final String id;
  late BuildContext _context;
  //todo: add activity view model
  late Future<Activity> activity;

  EditActivityViewModel(BuildContext context, this.id) {
    _context = context;
    _activityRepository = context.read<ActivityRepository>();
  }

  Future<List<Activity>> getActivity(String id) async {
    var response = await _activityRepository.getActivities(id);
    return response;
  }

  Future<void> editActivity(
  {
    required String name,
    required String description,
    required DateTimeRange dateTimeRange,
    required String holidayId,
    required Address address,
  }) async {
    _activityRepository.updateActivity(id, Activity(
      id : id,
      name: name,
      description: description,
      startDate: dateTimeRange.start,
      endDate: dateTimeRange.end,
      address: address,
    ));

    _context.pop();
  }
}