import 'package:fpdart/fpdart.dart';
import 'package:weather_app/constants/api_key.dart';
import 'package:weather_app/core/network/network_service.dart';
import 'package:weather_app/features/weather/models/weather_model.dart';
import 'package:weather_app/features/weather/repo/weather_repo.dart';

class WeatherService implements WeatherRepo {
  final NetworkService networkService;
  WeatherService({required this.networkService});
  @override
  Future<Either<String, WeatherModel>> fetchWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    try {
      var res = await networkService.get(
        '',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': ApiKey.WEATHER_API_KEY,
        },
      );
      WeatherModel data = WeatherModel.fromJson(res.data);
      return Right(data);
    } catch (e) {
      print('Exception :: $e');
      return Left('No data available.');
    }
  }
}
