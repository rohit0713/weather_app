

abstract class SearchEvent {}

class OnGetCurrentLocation extends SearchEvent{}

class OnLocationSelect extends SearchEvent{
  final String placeName;
  final double latitude;
  final double longitude;
  OnLocationSelect({required this.latitude,required this.longitude,required this.placeName});
}