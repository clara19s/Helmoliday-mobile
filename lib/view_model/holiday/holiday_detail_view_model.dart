import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:provider/provider.dart';

import '../../model/holiday.dart';

class HolidayDetailViewModel extends ChangeNotifier {
  late final HolidayRepository _holidayRepository;
  final BuildContext _context;
  final String id;

  late Future<Holiday> holiday;

  HolidayDetailViewModel(this._context, this.id) {
    _holidayRepository = _context.read<HolidayRepository>();
    holiday = _getHoliday(id);
  }

  Future<Holiday> _getHoliday(String id) async {
    return _holidayRepository.getHoliday(id);
  }

  void goToEditHoliday()  async {
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

  void goToCreateActivity() {
    // todo implemente this
  }
  void addParticipant( String email) {
    _holidayRepository.addParticipant(id, email);
  }

  void exitHoliday() {
    _holidayRepository.exitHoliday(id);
  }

  void publishHoliday(String id) {
    _holidayRepository.publishHoliday(id);
  }

}
