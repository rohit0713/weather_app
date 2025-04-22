import 'package:weather_app/features/weather/models/weather_model.dart';

// Base class for all weather-related states.
class WeatherState {
  WeatherState();
}

// State when weather data is being fetched (loading spinner can be shown).
class WeatherLoadingState extends WeatherState {}

// State when weather data is successfully fetched.
class WeatherSuccessState extends WeatherState {
  final WeatherModel weatherData;

  // Requires a WeatherModel instance that holds the fetched weather information.
  WeatherSuccessState({required this.weatherData});
}

// State when fetching weather data fails (can be used to show an error message).
class WeatherFailureState extends WeatherState {}
