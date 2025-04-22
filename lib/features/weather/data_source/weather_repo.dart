import 'package:fpdart/fpdart.dart';
import 'package:weather_app/features/weather/models/weather_model.dart';

abstract interface class WeatherRepo {
  Future<Either<String,WeatherModel>> fetchWeatherData({required double latitude,required double longitude});
}