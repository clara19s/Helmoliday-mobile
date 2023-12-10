class Guest {
  final String? id;
  final String firstName;
  final String lastName;
  final String profilePicture;

  Guest({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture
  });

 factory Guest .fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
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
      profilePicture: profilePicture,
    );
  }

}