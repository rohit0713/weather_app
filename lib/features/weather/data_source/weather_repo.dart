import 'package:fpdart/fpdart.dart';
import 'package:weather_app/features/weather/models/weather_model.dart';

// Abstract interface for the Weather Repository.
// Defines the contract for fetching weather data.
abstract interface class WeatherRepo {
  // Method to fetch weather data using latitude and longitude.
  // Returns an Either:
  // - Left(String) for failure (with an error message)
  // - Right(WeatherModel) for success (with weather data)
  Future<Either<String, WeatherModel>> fetchWeatherData({
    required double latitude,
    required double longitude,
  });
}
