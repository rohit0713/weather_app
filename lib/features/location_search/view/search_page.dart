import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:weather_app/constants/api_key.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  final places = GoogleMapsPlaces(apiKey: ApiKey.GOOGLE_API_KEY);

  Future<void> _fetchPlaceDetails(String placeId) async {
    final detail = await places.getDetailsByPlaceId(placeId);
    final location = detail.result.geometry?.location;

    if (location != null) {
      Navigator.pop(context, {
        'lat': location.lat,
        'lng': location.lng,
        'place': detail.result.name,
      });
    } else {
      print("Location not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GooglePlacesAutoCompleteTextFormField(
          textEditingController: controller,
          googleAPIKey: ApiKey.GOOGLE_API_KEY,
          debounceTime: 400,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Search location...',
            border: OutlineInputBorder(),
          ),
          fetchCoordinates: true,

          onSuggestionClicked: (prediction) {
            controller.text = prediction.description ?? '';
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0),
            );
            _fetchPlaceDetails(prediction.placeId ?? '');
          },
        ),
      ),
    );
  }
}
