import 'package:fpdart/fpdart.dart';
import 'package:weather_app/constants/api_key.dart';
import 'package:weather_app/core/network/network_service.dart';
import 'package:weather_app/features/weather/models/weather_model.dart';
import 'package:weather_app/features/weather/data_source/weather_repo.dart';

// Concrete implementation of the WeatherRepo interface.
// Responsible for fetching weather data from a remote API.
class WeatherService implements WeatherRepo {
  final NetworkService networkService;

  // Constructor takes a NetworkService to perform the actual API call.
  WeatherService({required this.networkService});

  @override
  Future<Either<String, WeatherModel>> fetchWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Perform GET request with query parameters
      var res = await networkService.get(
        '',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': ApiKey.WEATHER_API_KEY, // Your API key
        },
      );

      // Parse the response JSON into a WeatherModel instance
      WeatherModel data = WeatherModel.fromJson(res.data);

      // Return the parsed data wrapped in a Right (success)
      return Right(data);
    } catch (e) {
      // Print error for debugging and return failure wrapped in a Left
      print('Exception :: $e');
      return Left('No data available.');
    }
  }
}
