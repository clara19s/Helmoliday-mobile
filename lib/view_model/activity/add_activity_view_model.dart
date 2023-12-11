import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../model/address.dart';
import '../../repository/activity_repository.dart';

class AddActivityViewModel extends ChangeNotifier {
  late final ActivityRepository _activityRepository;

  final String holidayId;
  final DateTimeRange holidayDateRange;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  late BuildContext _context;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  AddActivityViewModel(BuildContext context, this.holidayId, this.holidayDateRange) {
    _context = context;
    _activityRepository = context.read<ActivityRepository>();
  }

  Future<void> addActivity(
      {required String name,
      required String description,
      required DateTimeRange dateTimeRange,
      required Address address,
      required ActivityCategory category}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _activityRepository.createActivity(
          holidayId,
          Activity(
              id: holidayId,
              name: name,
              description: description,
              startDate: dateTimeRange.start,
              endDate: dateTimeRange.end,
              address: address,
              category: category));
    } catch (e) {
      _errorMessage =
          'Erreur lors de la création de l\'activité. Veuillez réessayer.';
    } finally {
      _isLoading = false;
      notifyListeners();
      if (_context.mounted && Navigator.canPop(_context)) {
        Navigator.pop(_context);
      }
    }
  }
}
