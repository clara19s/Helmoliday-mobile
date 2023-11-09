import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../repository/activity_repository.dart';

class ActivityListViewModel extends ChangeNotifier{
  late final ActivityRepository _activityRepository;
  final BuildContext _context;
  final String id;

  late Future<List<Activity>> activities;

  ActivityListViewModel(this._context, this.id) {
    _activityRepository = _context.read<ActivityRepository>();
    activities = _getActivity(id);
  }
  // todo return a list of activity view model
  Future<List<Activity>> _getActivity(String id) async {
    return _activityRepository.getActivities(id);
  }

  void goToEditActivity(String id) {
    _context.push('/activities/edit/$id');
  }


  void deleteActivity(String id) async {
    await _activityRepository.deleteActivity(id);
    activities = _getActivity(this.id);
    notifyListeners();
  }
}