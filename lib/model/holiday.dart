import '../util/date_util.dart';
import 'address.dart';

class Holiday {
  final String? id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Address address;
  final bool published;

  Holiday({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.published,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateUtility.parseDate(json['startDate']),
      endDate: DateUtility.parseDate(json['endDate']),
      address: Address.fromJson(json['address']),
      published: json['published'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': DateUtility.toFormattedString(startDate),
      'endDate': DateUtility.toFormattedString(endDate),
      'address': address.toJson(),
      'published': published,
    };
  }

  Holiday copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    Address? address,
    bool? published,
  }) {
    return Holiday(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      address: address ?? this.address,
      published: published ?? this.published,
    );
  }
}
