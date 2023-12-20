import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../repository/activity_repository.dart';

class ActivityViewModel extends ChangeNotifier{
  late final ActivityRepository _activityRepository;
  late final BuildContext _context;

  ActivityViewModel(BuildContext context) {
    _context = context;
    _activityRepository = _context.read<ActivityRepository>();
    refreshData();
  }


 Future<void> refreshData() async {
    notifyListeners();
  }

  Future<void> goToActivityDetails(String activityId) async {
    await _context.push('/activities/details/$activityId');
    refreshData();
    return Future.value();
  }

  Future<void> deleteActivity(String activityId) async {
    await _activityRepository.deleteActivity(activityId);
    refreshData();
  }

  Future<void> goToCreateActivity() async {
    await _context.push('/activities/add');
    refreshData();
    return Future.value();
  }

  Future<void> goToEditActivity(String activityId) async {
    await _context.push('/activities/edit/$activityId');
    refreshData();
    return Future.value();
  }


  Future<void> goToActivityList(String activityId) async {
    await _context.push('/activities/list/$activityId');
    refreshData();
    return Future.value();
  }

  Future<void> goToActivityListScreen(String activityId) async {
    await _context.push('/activities/list_screen/$activityId');
    refreshData();
    return Future.value();
  }

}