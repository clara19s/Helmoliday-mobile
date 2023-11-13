import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:helmoliday/service/toast_service.dart';
import 'package:provider/provider.dart';

import '../../model/holiday.dart';

class HolidayDetailViewModel extends ChangeNotifier {
  late final HolidayRepository _holidayRepository;
  final IToastService _toastService;
  final BuildContext _context;
  final String id;

  late Future<Holiday> holiday;

  HolidayDetailViewModel(this._context, this.id)
      : _holidayRepository =
            Provider.of<HolidayRepository>(_context, listen: false),
        _toastService = Provider.of<IToastService>(_context, listen: false) {
    holiday = _getHoliday(id);
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

  Future<void> refreshData() async {
    holiday = _getHoliday(id);
    notifyListeners();
  }

  void goToCreateActivity() async {
    await _context.push('/activities/add/$id');
    refreshData();
  }

  void addParticipant(String email) {
    _holidayRepository.addParticipant(id, email);
  }

  void exitHoliday() {
    _holidayRepository.exitHoliday(id);
  }

  void publishHoliday() async {
    var holiday = await this.holiday;
    holiday = holiday.copyWith(published: true);
    await _holidayRepository.publishHoliday(holiday);
    _toastService.showMessage(ToastMessage(
        type: ToastType.success, text: 'Période de vacances publiée'));
    refreshData();
  }
}
