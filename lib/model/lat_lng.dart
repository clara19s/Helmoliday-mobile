class LatLng {
  final double latitude;
  final double longitude;

  LatLng({required this.latitude, required this.longitude});

  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  @override
  String toString() {
    return '$latitude,$longitude';
  }
}