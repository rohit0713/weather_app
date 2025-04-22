// Base class for all weather-related events.
// Extend this class to define different triggers for weather logic.
abstract class WeatherEvent {
  WeatherEvent();
}

// Event to trigger fetching weather data based on coordinates.
class OnGetWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  // Requires latitude and longitude to fetch the weather for a specific location.
  OnGetWeatherEvent({
    required this.latitude,
    required this.longitude,
  });
}
