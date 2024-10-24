import '../model/holiday.dart';

abstract class HolidayRepository {
  Future<List<Holiday>> getInvitedHolidays();

  Future<List<Holiday>> getPublishedHolidays();

  Future<Holiday> getHoliday(String id);

  Future<void> createHoliday(Holiday holiday);

  Future<void> updateHoliday(String holidayId, Holiday holiday);

  Future<void> deleteHoliday(String id);

  Future<void> addParticipant(String holidayId, String email);

  Future<void> exitHoliday(String id) ;

  Future<void> publishHoliday(Holiday holiday) ;
}
