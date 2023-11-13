import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../model/address.dart';
import '../../repository/activity_repository.dart';

class AddActivityViewModel extends ChangeNotifier{
  late final ActivityRepository _activityRepository;

  final String id;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late BuildContext _context;

  AddActivityViewModel(BuildContext context, this.id) {
    _context = context;
    _activityRepository = context.read<ActivityRepository>();
  }

  Future<void> addActivity(
  {
    required String name,
    required String description,
    required DateTimeRange dateTimeRange,
    required Address address }) async {
    _isLoading = true;
    notifyListeners();

    _activityRepository.createActivity(id, Activity(
      id : id,
      name: name,
      description: description,
      startDate: dateTimeRange.start,
      endDate: dateTimeRange.end,
      address: address,
    ));
    _isLoading = false;
    notifyListeners();
    _context.pop();
  }
}