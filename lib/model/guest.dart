class Guest {
  final String? id;
  final String firstName;
  final String lastName;

  Guest({
    this.id,
    required this.firstName,
    required this.lastName,
  });

 factory Guest .fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  Guest copyWith({
    String? id,
    String? firstName,
    String? lastName,
  }) {
    return Guest(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

}