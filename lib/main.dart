import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/bloc_providers.dart';
import 'package:weather_app/features/weather/view/weather_page.dart';
import 'package:weather_app/injection_container.dart' as di;

void main() async {
  // Ensures Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Locks the app orientation to portrait mode only (both up and down)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initializes the service locator (dependency injection setup)
  await di.init();

  // Launches the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      // Injects BLoC providers and sets the initial screen as WeatherPage
      home: BlocProviders(child: const WeatherPage()),
    );
  }
}
