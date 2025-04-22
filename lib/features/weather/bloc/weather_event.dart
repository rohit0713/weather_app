

abstract class WeatherEvent {
  WeatherEvent();
}

class OnGetWeatherEvent extends WeatherEvent{
  final double latitude;
  final double longitude;
 OnGetWeatherEvent({required this.latitude,required this.longitude});
}