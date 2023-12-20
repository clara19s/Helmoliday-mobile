
class Weather {
  late final String wheather;
  late final double temperature;
  late final double  feelsLike;
  late final String icon;

Weather({
    required this.wheather,
    required this.temperature,
    required this.feelsLike,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      wheather: json['weather'],
      temperature: json['temperature'],
      feelsLike: json['feelsLike'],
      icon: json['urlIcon'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'weather': wheather,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'urlIcon': icon,
    };
  }

}
