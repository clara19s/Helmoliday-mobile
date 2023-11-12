import 'package:helmoliday/model/activity.dart';
import 'package:helmoliday/repository/activity_repository.dart';

import '../../service/api_service.dart';

class ActivityRepositoryImp implements ActivityRepository{
  final ApiService _apiService;

  ActivityRepositoryImp(this._apiService);
  @override
  Future<void> createActivity(Activity activity) async {
     await _apiService.post("/activities", data: activity.toJson());
  }

  @override
  Future<void> deleteActivity(String id) async {
    await _apiService.delete("/activities/$id");
  }

  @override
  Future<List<Activity>> getActivities(String id) async {
   var reponse = await _apiService.get("/activities/holiday/$id");
   return (reponse.data as List)
    .map((activity) => Activity.fromJson(activity))
    .toList();
  }


  @override
  Future<void> updateActivity(String activityId, Activity activity) async {
    var response = await _apiService.put("/activities/$activityId", data: activity.toJson());
    print(response.data);
  }

  Future<Activity> getDetailActivity (String id) async {
    var response = await _apiService.get("/activities/$id");
    return Activity.fromJson(response.data);
  }

}