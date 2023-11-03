import '../model/holiday.dart';

abstract class HolidayRepository {
  Future<List<Holiday>> getInvitedHolidays();

  Future<List<Holiday>> getPublishedHolidays();

  Future<Holiday> getHoliday(String id);

  Future<void> createHoliday(Holiday holiday);

  Future<void> updateHoliday(String holidayId, Holiday holiday);

  Future<void> deleteHoliday(String id);
}
