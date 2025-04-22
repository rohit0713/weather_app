import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/location_search/bloc/search_bloc.dart';
import 'package:weather_app/features/weather/bloc/weather_bloc.dart';
import 'package:weather_app/injection_container.dart' as di;

// A widget that wraps its child with all the necessary BLoC providers.
// This helps in managing and injecting BLoCs throughout the widget tree.
class BlocProviders extends StatelessWidget {
  final Widget child;

  // Constructor takes the child widget that will be wrapped with BLoC providers.
  const BlocProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Providing the SearchBloc globally to the app.
        BlocProvider(create: (context) => SearchBloc()),

        // Providing the WeatherBloc and injecting the required weatherRepo
        // using the service locator (GetIt instance from injection_container).
        BlocProvider(
          create: (context) => WeatherBloc(weatherRepo: di.serviceLocator()),
        ),
      ],
      // The child widget is wrapped with these BLoC providers.
      child: child,
    );
  }
}
