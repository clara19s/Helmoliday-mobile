import '../util/date_util.dart';
import 'address.dart';

class Activity {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Address address;
  final ActivityCategory category;

  Activity(
      {required this.id,
      required this.name,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.address,
      required this.category});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateUtility.parseDate(json['startDate']),
      endDate: DateUtility.parseDate(json['endDate']),
      address: Address.fromJson(json['address']),
      category: ActivityCategory.values.firstWhere(
          (e) => e.toString() == 'ActivityCategory.${json['category'].toLowerCase()}'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'startDate': DateUtility.toFormattedString(startDate),
        'endDate': DateUtility.toFormattedString(endDate),
        'address': address.toJson(),
        'category': _capitalizeFirstLetter(category.toString().split('.').last),
      };
}

enum ActivityCategory {
  entertainment,
  cultural,
  sport,
  gastronomic,
  other
}

extension ActivityCategoryExtension on ActivityCategory {
  String get label {
    switch (this) {
      case ActivityCategory.entertainment:
        return "Divertissement";
      case ActivityCategory.cultural:
        return "Culturel";
      case ActivityCategory.sport:
        return "Sport";
      case ActivityCategory.gastronomic:
        return "Gastronomie";
      case ActivityCategory.other:
        return "Autre";
      default:
        return toString().split('.').last;
    }
  }
}

String _capitalizeFirstLetter(String str) {
  if (str.isEmpty) return str;
  return str[0].toUpperCase() + str.substring(1);
}