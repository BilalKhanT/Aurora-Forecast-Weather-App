class WeatherModel {
  late String locationName;
  late Map<String, dynamic> mainData;
  late List<dynamic> weatherData;
  late Map<String, dynamic> windData;
  late Map<String, dynamic> sysData;
  late Map<String, dynamic> cloudData;

  WeatherModel({
    required this.locationName,
    required this.mainData,
    required this.weatherData,
    required this.windData,
    required this.sysData,
    required this.cloudData,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      locationName: json['name'] ?? "",
      mainData: json['main'] ?? {},
      weatherData: json['weather'] ?? [],
      windData: json['wind'] ?? {},
      sysData: json['sys'] ?? {},
      cloudData: json['clouds'] ?? {},
    );
  }
}