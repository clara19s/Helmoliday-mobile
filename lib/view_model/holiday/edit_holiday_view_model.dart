import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:provider/provider.dart';

import '../../model/address.dart';
import '../../model/holiday.dart';

class EditHolidayViewModel extends ChangeNotifier {
  late final HolidayRepository _holidaysRepository;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final String id;
  late BuildContext _context;
  late Future<Holiday> holiday;

  EditHolidayViewModel(BuildContext context, this.id) {
    _context = context;
    _holidaysRepository = context.read<HolidayRepository>();
  }

  Future<Holiday> getHoliday(String id) async {
    var response = await _holidaysRepository.getHoliday(id);
    return response;
  }

  Future<void> editHoliday(
      {required String name,
        required String description,
        required DateTimeRange dateTimeRange,
        required Address address}) async {
    _isLoading = true;
    notifyListeners();

    _holidaysRepository.updateHoliday(id, Holiday(
      name: name,
      description: description,
      startDate: dateTimeRange.start,
      endDate: dateTimeRange.end,
      address: address,
      published: false,
    ));

    _isLoading = false;
    notifyListeners();

    _context.pop();
  }
}