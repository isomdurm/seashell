import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';

import 'custom_exception_service.dart';

class ApiService {
  WeatherFactory wf = WeatherFactory("please enter api key here");



  Future<dynamic> getCityWeatherByName(String cityName) async {
    List<Weather> forecast = await wf.fiveDayForecastByCityName(cityName).catchError((e) {
      print(e);
      return throw Exception("Exception");
    });

    return forecast;
  }

  // default response handler
  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body.toString());
        return responseJson;
      case 400:
        return response.body.toString();
      case 401:
        return response.body.toString();
      case 403:
        return response.body.toString();
      case 500:
        return response.body.toString();
      default:
        return response.body.toString();
    }
  }
}

class Messages {

}
