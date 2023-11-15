import 'package:helmoliday/model/guest.dart';

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
  final List<Guest>? guests ;

  Holiday({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.published,
    this.guests,
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
      guests: json['guests'] != null
          ? (json['guests'] as List).map((i) => Guest.fromJson(i)).toList()
          : [],
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
      'guests': guests,
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
    List<Guest>? guests,
  }) {
    return Holiday(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      address: address ?? this.address,
      published: published ?? this.published,
      guests: guests ?? this.guests ?? [],
    );
  }
}
