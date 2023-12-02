import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helmoliday/model/address.dart';
import 'package:provider/provider.dart';

import '../../model/holiday.dart';
import '../../repository/holiday_repository.dart';

class AddHolidayViewModel extends ChangeNotifier {
  late final HolidayRepository _holidaysRepository;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  late BuildContext _context;

  AddHolidayViewModel(BuildContext context) {
    _context = context;
    _holidaysRepository = context.read<HolidayRepository>();
  }

  Future<void> addHoliday(
      {required String name,
      required String description,
      required DateTimeRange dateTimeRange,
      required Address address}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _holidaysRepository.createHoliday(Holiday(
        name: name,
        description: description,
        startDate: dateTimeRange.start,
        endDate: dateTimeRange.end,
        address: address,
        published: false,
      ));
    } catch (e) {
      _errorMessage = 'Erreur lors de la création de la vacance. Veuillez réessayer.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    _context.pop();
  }
}
