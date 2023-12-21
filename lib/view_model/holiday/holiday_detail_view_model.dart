import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/repository/activity_repository.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:helmoliday/service/toast_service.dart';
import 'package:provider/provider.dart';

import '../../model/activity.dart';
import '../../model/holiday.dart';

class HolidayDetailViewModel extends ChangeNotifier {
  late final HolidayRepository _holidayRepository;
  late final ActivityRepository _activityRepository;
  final IToastService _toastService;
  final BuildContext _context;
  final String id;
  bool _triCroissant = true;

  late Future<Holiday> holiday;
  late List<Activity> _allActivities;
  List<Activity> _filteredActivities = [];
  final Set<ActivityCategory> _filters = {};

  List<Activity> get filteredActivities => _filteredActivities;

  Set<ActivityCategory> get filters => _filters;

  HolidayDetailViewModel(this._context, this.id)
      : _holidayRepository =
            Provider.of<HolidayRepository>(_context, listen: false),
        _activityRepository =
            Provider.of<ActivityRepository>(_context, listen: false),
        _toastService = Provider.of<IToastService>(_context, listen: false) {
    holiday = _getHoliday(id);
    refreshActivities();
  }

  Future<Holiday> _getHoliday(String id) async {
    return _holidayRepository.getHoliday(id);
  }

  void goToEditHoliday() async {
    await _context.push('/holidays/edit/$id');
    refreshData();
  }

  void removeHoliday() async {
    _holidayRepository.deleteHoliday(id);
    _context.pop();
  }

  void goToHolidayMap() {
    _context.push('/holidays/map/$id');
  }
  void goToActivityMap(String id) {
    _context.push('/activities/map/$id');
  }

  void goToHolidayChat() {
    _context.push('/holidays/chat/$id');
  }

  Future<void> refreshData() async {
    holiday = _getHoliday(id);
    notifyListeners();
  }

  Future<void> addParticipant(String email) async {
    await _holidayRepository.addParticipant(id, email);
    refreshData();
  }

  void exitHoliday() async {
    await _holidayRepository.exitHoliday(id);
    if (_context.mounted) {
      _context.pop();
    }
  }

  void publishHoliday() async {
    var holiday = await this.holiday;
    holiday = holiday.copyWith(published: true);
    await _holidayRepository.publishHoliday(holiday);
    _toastService.showMessage(ToastMessage(
        type: ToastType.success, text: 'Période de vacances publiée'));
    refreshData();
  }

  Future<List<Activity>> _getActivities(String id) {
    return _activityRepository.getActivities(id);
  }

  Future<void> refreshActivities() async {
    List<Activity> activities = await _getActivities(id);
    _allActivities = activities;
    applyFilters();
  }

  void applyFilters() {
    if (_filters.isEmpty) {
      _filteredActivities = List.from(_allActivities);
    } else {
      _filteredActivities = _allActivities.where((activity) {
        return _filters.contains(activity.category);
      }).toList();
    }
    notifyListeners();
  }

  void updateFilters(ActivityCategory category) {
    if (_filters.contains(category)) {
      _filters.remove(category);
    } else {
      _filters.add(category);
    }
    applyFilters();
  }

  void goToEditActivity(String id) async {
    var holiday = await this.holiday;
    if (holiday.published) {
      _toastService.showMessage(ToastMessage(
          type: ToastType.error,
          text: 'Vous ne pouvez pas modifier une activité d\'une période de vacances publiée'));
      return;
    }
    if (_context.mounted) {
      await _context.push('/activities/edit/$id/${holiday.startDate}/${holiday.endDate}');
      refreshActivities();
    }
  }

  void goToCreateActivity() async {
    var holiday = await this.holiday;
    if (holiday.published) {
      _toastService.showMessage(ToastMessage(
          type: ToastType.error,
          text: 'Vous ne pouvez pas ajouter une activité à une période de vacances publiée'));
      return;
    }
    if (_context.mounted) {
      await _context.push('/activities/add/$id/${holiday.startDate}/${holiday.endDate}');
      refreshActivities();
    }
    refreshActivities();
  }

  void deleteActivity(String id) async {
    await _activityRepository.deleteActivity(id);
    refreshActivities();
  }

  void trierListe() {
    _filteredActivities.sort((a, b) {
      if (_triCroissant) {
        return a.startDate.compareTo(b.startDate);
      } else {
        return b.startDate.compareTo(a.startDate);
      }
    });
    _triCroissant = !_triCroissant;
    notifyListeners();
  }

  bool get triCroissant => _triCroissant;

  Future<void> downloadICSFile(String id) async {
    await _holidayRepository.downloadICSFile(id);
  }
}
