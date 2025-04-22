import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/constants/texts.dart';
import 'package:weather_app/core/helper/helper.dart';
import 'package:weather_app/core/styles/app_colors.dart';
import 'package:weather_app/core/utils/app_text.dart';
import 'package:weather_app/features/location_search/bloc/search_bloc.dart';
import 'package:weather_app/features/location_search/bloc/search_event.dart';
import 'package:weather_app/features/location_search/bloc/search_state.dart';
import 'package:weather_app/features/location_search/view/search_page.dart';
import 'package:weather_app/features/weather/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/bloc/weather_event.dart';
import 'package:weather_app/features/weather/bloc/weather_state.dart';
import 'package:weather_app/features/weather/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String placeName = '';

  @override
  void initState() {
    // Request current location when page initializes
    context.read<SearchBloc>().add(OnGetCurrentLocation());
    super.initState();
  }

  // Dispatch weather event using lat/lng from current location
  _getWeatherData(CurrentLocationSuccessState state) {
    context.read<WeatherBloc>().add(
      OnGetWeatherEvent(latitude: state.latitude, longitude: state.longitude),
    );
  }

  // Update location when user selects one from search
  _setLocation(double latitude, double longitude, String placeName) {
    context.read<SearchBloc>().add(
      OnLocationSelect(
        latitude: latitude,
        longitude: longitude,
        placeName: placeName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset('assets/bg_image.png', fit: BoxFit.fill),
            BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is CurrentLocationSuccessState) {
                  _getWeatherData(state);
                  setState(() {
                    placeName = state.placeName;
                  });
                }
              },
              builder: (context, state) {
                if (state is CurrentLocationLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.appWhite),
                  );
                }
                return BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(color: AppColors.appWhite),
                      );
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 80, 10, 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Display location
                            AppText(
                              title:
                                  placeName.isEmpty
                                      ? Texts.SELECT_LOC
                                      : placeName.split(',').first,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),
                            // Handle failure state
                            if (state is WeatherFailureState) ...{
                              Center(
                                child: AppText(
                                  title: Texts.NO_DATA,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            },
                            // Show weather data if available
                            if (state is WeatherSuccessState) ...{
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 4),
                                  AppText(
                                    title:
                                        '${(state.weatherData.current?.temp - 273).toStringAsFixed(2)}°C',

                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  AppText(
                                    title:
                                        state
                                            .weatherData
                                            .current
                                            ?.weather?[0]
                                            .main
                                            .toString() ??
                                        '',
                                  ),
                                  const SizedBox(height: 30),
                                  // Hourly forecast
                                  SizedBox(
                                    height: 116,
                                    width: double.infinity,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return _hourlyData(
                                          state.weatherData.hourly?[index],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(width: 10);
                                      },
                                      itemCount:
                                          state.weatherData.hourly?.length ?? 0,
                                    ),
                                  ),

                                  const SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: AppText(
                                      title: Texts.WEATHER_DETAILS,

                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _weatherDetails(state.weatherData),

                                  const SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: AppText(
                                      title: Texts.REPORT,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // Daily forecast
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return _dailyData(
                                        state.weatherData.daily?[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                    itemCount:
                                        state.weatherData.daily?.length ?? 0,
                                  ),
                                ],
                              ),
                            },
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // Search button
            Positioned(
              top: 20,
              right: 20,
              child: InkWell(
                onTap: () async {
                  var data = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                  if (data != null) {
                    _setLocation(data['lat'], data['lng'], data['place']);
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.search, color: AppColors.appBlack),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Weather detail metrics (humidity, wind speed, etc.)
  _weatherDetails(WeatherModel data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.appWhite10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 20,
          children: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: _detailItem(
                    Texts.VISIBILITY,
                    '${(data.current?.visibility / 1000).toInt()} km',
                  ),
                ),
                Expanded(
                  child: _detailItem(
                    Texts.HUMIDITY,
                    '${data.current?.humidity}%',
                  ),
                ),
              ],
            ),
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: _detailItem(
                    Texts.WIND_SPEED,
                    '${data.current?.windSpeed} km/h',
                  ),
                ),
                Expanded(
                  child: _detailItem(
                    Texts.PRESSURE,
                    '${data.current?.pressure} hPa',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable detail item widget
  _detailItem(String title, String value) {
    return Column(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title: value, fontSize: 16),
        AppText(title: title, fontSize: 14),
      ],
    );
  }

  // Hourly weather item
  _hourlyData(Hourly? data) {
    String time = formatTimeFromTimestamp(data?.dt);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhite10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 2,
          children: [
            AppText(title: time, fontSize: 14),

            Image.network(
              'https://openweathermap.org/img/wn/${data?.weather?[0].icon}@2x.png',
              height: 20,
              width: 20,
            ),
            AppText(title: data?.weather?[0].main ?? '', fontSize: 14),
            AppText(
              title: '${(data?.temp - 273).toStringAsFixed(2)}°C',
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  // Daily forecast item
  _dailyData(Daily? data) {
    String date = getDayAndDateFromTimestamp(data?.dt);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhite10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 10,
          children: [
            Expanded(
              child: AppText(
                title: date.split(',').first,

                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(child: AppText(title: date.split(',').last, fontSize: 14)),
            Expanded(
              child: Image.network(
                'https://openweathermap.org/img/wn/${data?.weather?[0].icon}@2x.png',
                height: 20,
                width: 20,
              ),
            ),
            Expanded(
              child: AppText(title: data?.weather?[0].main ?? '', fontSize: 14),
            ),
            Expanded(
              child: AppText(
                title: '${(data?.temp?.day - 273).toStringAsFixed(2)}°C',

                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
