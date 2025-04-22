import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/features/location_search/bloc/search_event.dart';
import 'package:weather_app/features/location_search/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    on<OnGetCurrentLocation>(_onGetCurrentLocation);
    on<OnLocationSelect>(_onLocationSelect);
  }

  _onGetCurrentLocation(
    OnGetCurrentLocation event,
    Emitter<SearchState> emit,
  ) async {
    emit(CurrentLocationLoadingState());
    try {
      Position position = await _getCurrentLocation();
      String placeName=await _getPlaceName(position.latitude,position.longitude);
      emit(
        CurrentLocationSuccessState(
          latitude: position.latitude,
          longitude: position.longitude,
          placeName: placeName
        ),
      );
    } catch (e) {
      emit(CurrentLocationFailureState());
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getPlaceName(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      return "${place.locality}, ${place.administrativeArea}, ${place.country}";
    } else {
      return "Unknown location";
    }
  } catch (e) {
    print('Error in reverse geocoding: $e');
    return "Location not found";
  }
}

_onLocationSelect(
    OnLocationSelect event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(
        CurrentLocationSuccessState(
          latitude:event.latitude,
          longitude: event.longitude,
          placeName:event.placeName
        ),
      );
    } catch (e) {
      emit(CurrentLocationFailureState());
    }
  }

  
}
