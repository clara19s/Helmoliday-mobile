import 'dart:convert';

import 'package:helmoliday/model/holiday.dart';
import 'package:open_file/open_file.dart';

import '../../model/weather.dart';
import '../../repository/holiday_repository.dart';
import '../../service/api_service.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';


class HolidayRepositoryImpl implements HolidayRepository {
  final ApiService _apiService;

  HolidayRepositoryImpl(this._apiService);

  @override
  Future<void> createHoliday(Holiday holiday) async {
    await _apiService.post("/holidays", data: holiday.toJson());
  }

  @override
  Future<void> deleteHoliday(String id) async {
    await _apiService.delete("/holidays/$id");
  }

  @override
  Future<Holiday> getHoliday(String id) async {
    var response = await _apiService.get("/holidays/$id");
    return Holiday.fromJson(response.data);
  }

  @override
  Future<List<Holiday>> getInvitedHolidays() async {
    var response = await _apiService.get("/holidays/invited");
    return (response.data as List)
        .map((holiday) => Holiday.fromJson(holiday))
        .toList();
  }

  @override
  Future<void> updateHoliday(String holidayId, Holiday holiday) async {
    var response =
        await _apiService.put("/holidays/$holidayId", data: holiday.toJson());
    print(response.data);
  }

  @override
  Future<List<Holiday>> getPublishedHolidays() async {
    var response = await _apiService.get("/holidays/published");
    return (response.data as List)
        .map((holiday) => Holiday.fromJson(holiday))
        .toList();
  }

  @override
  Future<void> addParticipant(String holidayId, String email) async {
    var response = await _apiService
        .post("/invitations", data: {"email": email, "holidayId": holidayId});
    print(response.data);
  }

  @override
  Future<void> exitHoliday(String id) async {
    await _apiService.delete("/invitations/$id");
  }

  @override
  Future<void> publishHoliday(Holiday holiday) async {
    await _apiService.put("/holidays/${holiday.id}",
        data: holiday.copyWith(published: true).toJson());
  }

  @override
  Future<Weather> getWeather(String id) async {
    var response = await _apiService.get("/holidays/$id/weather");
    return Weather.fromJson(response.data);
  }
  @override
  Future<void> downloadICSFile(String id) async {
    try {
      var response = await _apiService.get("/holidays/$id/calendar");

      Directory? tempDir = await getExternalStorageDirectory();
      String? tempPath = tempDir?.path;

      File file = File('$tempPath/mon_fichier.ics');
      await file.writeAsBytes(utf8.encode(response.data));
      await OpenFile.open(file.path);



    } catch (e) {
      print(e.toString());
    }
  }





}
