import 'package:flutter/material.dart';
import 'package:helmoliday/model/holiday.dart';
import 'package:helmoliday/repository/holiday_repository.dart';
import 'package:provider/provider.dart';

import '../model/weather.dart';

class WeatherViewModel extends ChangeNotifier {
  late final BuildContext _context;
  late final HolidayRepository _holidayRepository;
  final String id;
  late final Future<Weather> weather;


  WeatherViewModel(BuildContext context, this.id) {
    _context = context;
    _holidayRepository = _context.read<HolidayRepository>();
    weather = _getWeather(id);

  }

  Future<Weather> _getWeather(String id) async {
    return _holidayRepository.getWeather(id);
  }


}



