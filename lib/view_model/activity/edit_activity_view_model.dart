import 'package:flutter/material.dart';
import 'package:helmoliday/model/address.dart';
import 'package:helmoliday/repository/activity_repository.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';

class EditActivityViewModel extends ChangeNotifier {
  late final ActivityRepository _activityRepository;
  final String activityId;
  final DateTimeRange holidayDateRange;
  late BuildContext _context;

  //todo: add activity view model
  late Future<Activity> activity;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  EditActivityViewModel(BuildContext context, this.activityId, this.holidayDateRange) {
    _context = context;
    _activityRepository = context.read<ActivityRepository>();
  }

  Future<Activity> getDetailActivity(String id) async {
    var response = await _activityRepository.getDetailActivity(id);
    return response;
  }

  Future<void> editActivity(
      {required String name,
      required String description,
      required DateTimeRange dateTimeRange,
      required Address address,
      required ActivityCategory category}) async {
    _isLoading = true;
    try {
      await _activityRepository.updateActivity(
          activityId,
          Activity(
              id: activityId,
              name: name,
              description: description,
              startDate: dateTimeRange.start,
              endDate: dateTimeRange.end,
              address: address,
              category: category));
    } catch (e) {
      _isLoading = false;
    } finally {
      _isLoading = false;
      notifyListeners();
      if (_context.mounted && Navigator.canPop(_context)) {
        Navigator.pop(_context);
      }
    }
  }
}
