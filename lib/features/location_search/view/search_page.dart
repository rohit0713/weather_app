import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:weather_app/constants/api_key.dart';
import 'package:weather_app/constants/messages.dart';
import 'package:weather_app/constants/texts.dart';
import 'package:weather_app/core/styles/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  final places = GoogleMapsPlaces(apiKey: ApiKey.GOOGLE_API_KEY);
  bool _isLoading = false;  // Loading state to show spinner

  Future<void> _fetchPlaceDetails(String placeId) async {
    setState(() {
      _isLoading = true;  // Set loading state to true
    });

    try {
      final detail = await places.getDetailsByPlaceId(placeId);
      final location = detail.result.geometry?.location;

      if (location != null) {
        Navigator.pop(context, {
          'lat': location.lat,
          'lng': location.lng,
          'place': detail.result.name,
        });
      } else {
        _showErrorMessage(Messages.LOC_NOT_FOUND);
      }
    } catch (e) {
      _showErrorMessage(Messages.FAILED_LOC);
    } finally {
      setState(() {
        _isLoading = false;  // Set loading state back to false after the request
      });
    }
  }

  // Function to show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: AppColors.appWhite),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GooglePlacesAutoCompleteTextFormField(
              textEditingController: controller,
              googleAPIKey: ApiKey.GOOGLE_API_KEY,
              debounceTime: 400,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: Texts.SEARCH_LOC,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),  // Rounded border
                ),
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
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
