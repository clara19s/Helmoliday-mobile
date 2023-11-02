import '../util/date_util.dart';
import 'address.dart';

class Activity {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Address address;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.address,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateUtility.parseDate(json['startDate']),
      endDate: DateUtility.parseDate(json['endDate']),
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'startDate': DateUtility.toFormattedString(startDate),
        'endDate': DateUtility.toFormattedString(endDate),
        'address': address.toJson(),
      };
}
