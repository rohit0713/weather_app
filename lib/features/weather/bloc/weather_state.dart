import 'package:weather_app/features/weather/models/weather_model.dart';

class WeatherState {
  WeatherState();
}

class WeatherLoadingState extends WeatherState {}

class WeatherSuccessState extends WeatherState {
  final WeatherModel weatherData;

  WeatherSuccessState({required this.weatherData});
}

class WeatherFailureState extends WeatherState {}
