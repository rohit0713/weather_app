import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/bloc/weather_event.dart';
import 'package:weather_app/features/weather/bloc/weather_state.dart';
import 'package:weather_app/features/weather/repo/weather_repo.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepo weatherRepo;
  WeatherBloc({required this.weatherRepo}) : super(WeatherState()) {
    on<OnGetWeatherEvent>(_onGetWeather);
  }
  _onGetWeather(OnGetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadingState());
    var res = await weatherRepo.fetchWeatherData(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    res.fold(
      (l) {
     
        emit(WeatherFailureState());
      },
      (r) {
        emit(WeatherSuccessState(weatherData: r));
      },
    );
  }
}
