import 'package:get_it/get_it.dart';
import 'package:weather_app/core/network/dio_network_service.dart';
import 'package:weather_app/core/network/network_service.dart';
import 'package:weather_app/features/weather/data_source/weather_repo.dart';
import 'package:weather_app/features/weather/data_source/weather_service.dart';

// Creating an instance of GetIt, which will be used for dependency injection
final serviceLocator = GetIt.instance;

// Function to initialize all the dependencies
init() {
  // Registering a singleton instance of NetworkService using DioNetworkServiceImpl.
  // This ensures only one instance is created and reused wherever needed.
  serviceLocator.registerLazySingleton<NetworkService>(
    () => DioNetworkServiceImpl(),
  );

  // Registering a factory for WeatherRepo.
  // A new instance of WeatherService is created every time it's requested.
  // It uses the NetworkService instance from the service locator.
  serviceLocator.registerFactory<WeatherRepo>(
    () => WeatherService(networkService: serviceLocator()),
  );
}
