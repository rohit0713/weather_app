import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/bloc_providers.dart';
import 'package:weather_app/features/weather/view/weather_page.dart';
import 'package:weather_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: BlocProviders(child: const WeatherPage()),
    );
  }
}
