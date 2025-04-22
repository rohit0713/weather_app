

 class SearchState {}

class CurrentLocationLoadingState extends SearchState {}

class CurrentLocationSuccessState extends SearchState {
  final double latitude;
  final double longitude;
  final String placeName;

  CurrentLocationSuccessState({
    required this.latitude,
    required this.longitude,
    required this.placeName
  });
}

class CurrentLocationFailureState extends SearchState {}
