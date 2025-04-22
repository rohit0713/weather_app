import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/features/location_search/bloc/search_event.dart';
import 'package:weather_app/features/location_search/bloc/search_state.dart';

// SearchBloc handles search-related events and emits corresponding states
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Constructor to handle different events
  SearchBloc() : super(SearchState()) {
    on<OnGetCurrentLocation>(_onGetCurrentLocation);
    on<OnLocationSelect>(_onLocationSelect);
  }

  // Handles event when user requests current location
  _onGetCurrentLocation(
    OnGetCurrentLocation event,
    Emitter<SearchState> emit,
  ) async {
    emit(CurrentLocationLoadingState()); // Emit loading state
    try {
      // Fetch current position and place name
      Position position = await _getCurrentLocation();
      String placeName = await _getPlaceName(
        position.latitude,
        position.longitude,
      );

      // Emit success state with obtained data
      emit(
        CurrentLocationSuccessState(
          latitude: position.latitude,
          longitude: position.longitude,
          placeName: placeName,
        ),
      );
    } catch (e) {
      // Emit failure state if there was an error
      emit(CurrentLocationFailureState());
    }
  }

  // Fetches current location position from device
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    // Request permission if not granted
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    // Handle case where permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Converts coordinates to a human-readable place name using reverse geocoding
  Future<String> _getPlaceName(double lat, double lng) async {
    try {
      // Fetch placemarks using reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // Return formatted location string
        return "${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "Unknown location"; // Fallback if no placemarks are found
      }
    } catch (e) {
      // Handle any error during geocoding
      print('Error in reverse geocoding: $e');
      return "Location not found"; // Return default error string
    }
  }

  // Handles event when user selects a location manually
  _onLocationSelect(OnLocationSelect event, Emitter<SearchState> emit) async {
    try {
      // Emit success state with selected location data
      emit(
        CurrentLocationSuccessState(
          latitude: event.latitude,
          longitude: event.longitude,
          placeName: event.placeName,
        ),
      );
    } catch (e) {
      // Emit failure state if there was an error
      emit(CurrentLocationFailureState());
    }
  }
}
