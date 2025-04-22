import 'package:get_it/get_it.dart';
import 'package:weather_app/core/network/dio_network_service.dart';
import 'package:weather_app/core/network/network_service.dart';
import 'package:weather_app/features/weather/repo/weather_repo.dart';
import 'package:weather_app/features/weather/services/weather_service.dart';

final serviceLocator = GetIt.instance;

init() {
  serviceLocator.registerLazySingleton<NetworkService>(
    () => DioNetworkServiceImpl(),
  );

  serviceLocator.registerFactory<WeatherRepo>(
    () => WeatherService(networkService: serviceLocator()),
  );
}
