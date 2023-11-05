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

  void goToEditHoliday() {
    _context.push('/holidays/edit/$id');
  }

  void removeHoliday() async {
    _holidayRepository.deleteHoliday(id);
    _context.pop();
  }

  void goToHolidayMap() {
    _context.push('/holidays/map/$id');
  }
}
