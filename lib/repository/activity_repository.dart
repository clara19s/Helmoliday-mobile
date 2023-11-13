import '../model/activity.dart';

abstract class ActivityRepository{

  Future<List<Activity>> getActivities(String id);

  Future<void> createActivity(String holidayId, Activity activity);

  Future<void> updateActivity(String activityId, Activity activity);

  Future<void> deleteActivity(String id);

  Future<Activity> getDetailActivity (String id);
}