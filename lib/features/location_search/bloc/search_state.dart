// Base class for all search-related states
class SearchState {}

// Represents a loading state when fetching current location
class CurrentLocationLoadingState extends SearchState {}

// Represents a successful location fetch with coordinates and place name
class CurrentLocationSuccessState extends SearchState {
  final double latitude;
  final double longitude;
  final String placeName;

  CurrentLocationSuccessState({
    required this.latitude,
    required this.longitude,
    required this.placeName,
  });
}

// Represents a failure while fetching the current location
class CurrentLocationFailureState extends SearchState {}
