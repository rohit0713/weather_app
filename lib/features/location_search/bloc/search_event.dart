// Abstract base class for all search-related events
abstract class SearchEvent {}

// Event triggered to fetch the current location
class OnGetCurrentLocation extends SearchEvent {}

// Event triggered when a user selects a location
class OnLocationSelect extends SearchEvent {
  final String placeName;
  final double latitude;
  final double longitude;

  // Constructor to initialize location details
  OnLocationSelect({
    required this.latitude,
    required this.longitude,
    required this.placeName,
  });
}
