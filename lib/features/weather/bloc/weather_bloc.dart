import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/bloc/weather_event.dart';
import 'package:weather_app/features/weather/bloc/weather_state.dart';
import 'package:weather_app/features/weather/data_source/weather_repo.dart';

// The BLoC class that handles weather-related logic and state changes.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepo weatherRepo;

  // Constructor takes a WeatherRepo to fetch weather data.
  WeatherBloc({required this.weatherRepo}) : super(WeatherState()) {
    // Registering the handler for OnGetWeatherEvent
    on<OnGetWeatherEvent>(_onGetWeather);
  }

  // Event handler for OnGetWeatherEvent.
  // It emits loading, success, or failure states based on the API call result.
  Future<void> _onGetWeather(
    OnGetWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadingState()); // Notify UI that loading has started

    // Fetch weather data using repository and coordinates from the event
    var res = await weatherRepo.fetchWeatherData(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    // Handle the result using Either's fold method
    res.fold(
      (failure) {
        // Emit failure state if API call fails
        emit(WeatherFailureState());
      },
      (weatherData) {
        // Emit success state with fetched data
        emit(WeatherSuccessState(weatherData: weatherData));
      },
    );
  }
}
