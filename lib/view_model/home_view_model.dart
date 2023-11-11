import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/holiday.dart';
import '../repository/holiday_repository.dart';

class HomeScreenViewModel extends ChangeNotifier {
  late final HolidayRepository _holidaysRepository;
  late BuildContext _context;

  late Future<List<Holiday>> invitedHolidaysFuture;
  late Future<List<Holiday>> publishedHolidaysFuture;

  HomeScreenViewModel(BuildContext context) {
    _context = context;
    _holidaysRepository = context.read<HolidayRepository>();

    refreshData();
  }

  Future<List<Holiday>> getInvitedHolidays() async {
    var response = await _holidaysRepository.getInvitedHolidays();
    return response;
  }

  Future<List<Holiday>> getPublishedHolidays() async {
    var response = await _holidaysRepository.getPublishedHolidays();
    return response;
  }

  Future<void> refreshData() async {
    invitedHolidaysFuture = getInvitedHolidays();
    publishedHolidaysFuture = getPublishedHolidays();
    notifyListeners();
  }

  Future<void> goToHolidayDetails(String holidayId) async {
    await _context.push('/holidays/details/$holidayId');
    refreshData();
    return Future.value();
  }
}