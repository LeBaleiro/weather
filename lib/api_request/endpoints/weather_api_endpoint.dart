class WeatherApiEndpoints {
  static const String APIKEY = "15c2de19889eb36d0eb95bfec4523b53";

  static String getWeatherDataByCoordinates(String lat, String lon) =>
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$APIKEY";

  static String getWeatherDataByCityName(String cityName) =>
      "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$APIKEY";
}
