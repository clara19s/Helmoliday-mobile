import 'package:helmoliday/model/holiday.dart';

import '../../repository/holiday_repository.dart';
import '../../service/api_service.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  final ApiService _apiService;

  HolidayRepositoryImpl(this._apiService);

  @override
  Future<void> createHoliday(Holiday holiday) async {
    _apiService.post("/holidays", data: holiday.toJson());
  }

  @override
  Future<void> deleteHoliday(String id) async {
    _apiService.delete("/holidays/$id");
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
    var response = await _apiService.put("/holidays/$holidayId", data: holiday.toJson());
    print(response.data);
  }

  @override
  Future<List<Holiday>> getPublishedHolidays() async {
    var response = await _apiService.get("/holidays/published");
    return (response.data as List)
        .map((holiday) => Holiday.fromJson(holiday))
        .toList();
  }
  Future<void> addParticipant(String holidayId, String email) async {
    await _apiService.post("/invitation", data: {"email": email, "holidayId": holidayId});
  }
  Future<void> exitHoliday(String id) async {
    await _apiService.delete("/invitation/$id");
  }
  Future<void> publishHoliday(String id) async {
    // TODO : implement this
  }
}
