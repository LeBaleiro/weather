import 'dart:convert';

import '../endpoints/weather_api_endpoint.dart';
import '../models/api_response_model.dart';
import 'package:http/http.dart' as http;

class WeatherRequest {
  
  Future<ApiResponseModel> getWeatherByCoordinates(
      String lat, String lon) async {
    final response = await http
        .get(WeatherApiEndpoints.getWeatherDataByCoordinates(lat, lon));

    return ApiResponseModel.fromJson(jsonDecode(response?.body));
  }

  Future<ApiResponseModel> getWeatherByCityName(String cityName) async {
    final response =
        await http.get(WeatherApiEndpoints.getWeatherDataByCityName(cityName));
    return ApiResponseModel.fromJson(jsonDecode(response?.body));
  }
}
