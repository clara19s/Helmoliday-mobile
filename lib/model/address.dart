class Address {
  final String street;
  final String streetNumber;
  final String postalCode;
  final String city;
  final String country;

  Address({
    required this.street,
    required this.streetNumber,
    required this.postalCode,
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      streetNumber: json['streetNumber'],
      postalCode: json['postalCode'],
      city: json['city'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'streetNumber': streetNumber,
    'postalCode': postalCode,
    'city': city,
    'country': country,
  };
}