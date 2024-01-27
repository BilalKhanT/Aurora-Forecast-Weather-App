import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weatherapp/model/weather_model.dart';

Future<WeatherModel> getWeatherData(var lat, var long) async {
  var response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&appid=26456d0b2ae56713ab98d55a0a4b55ea'));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    WeatherModel weatherModel = WeatherModel.fromJson(responseData);
    return weatherModel;
  } else {
    return WeatherModel(locationName: "", mainData: {}, weatherData: [], windData: {}, sysData: {}, cloudData: {});
  }
}

Future<WeatherModel> getWeatherDataByCity(var cityName) async{
  var response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=26456d0b2ae56713ab98d55a0a4b55ea'));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    WeatherModel weatherModel = WeatherModel.fromJson(responseData);
    return weatherModel;
  } else {
    return WeatherModel(locationName: "", mainData: {}, weatherData: [], windData: {}, sysData: {}, cloudData: {});
  }
}


