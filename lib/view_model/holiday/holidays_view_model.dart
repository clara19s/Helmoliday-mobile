import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:provider/provider.dart';

import '../../model/holiday.dart';

class HolidaysViewModel extends ChangeNotifier {
  late final HolidayRepository _holidaysRepository;
  late BuildContext _context;

  late Future<List<Holiday>> invitedHolidaysFuture;
  late Future<List<Holiday>> publishedHolidaysFuture;

  HolidaysViewModel(BuildContext context) {
    _context = context;
    _holidaysRepository = context.read<HolidayRepository>();
    refreshData();
  }

  Future<List<Holiday>> _getInvitedHolidays() async {
    var response = await _holidaysRepository.getInvitedHolidays();
    return response;
  }

  Future<void> refreshData() async {
    invitedHolidaysFuture = _getInvitedHolidays();
    notifyListeners();
  }

  Future<void> goToHolidayDetails(String holidayId) async {
    await _context.push('/holidays/details/$holidayId');
    refreshData();
    return Future.value();
  }

  Future<void> deleteHoliday(String holidayId) async {
    await _holidaysRepository.deleteHoliday(holidayId);
    refreshData();
  }

  Future<void> goToCreateHoliday() async {
    await _context.push('/holidays/add');
    refreshData();
    return Future.value();
  }
}
