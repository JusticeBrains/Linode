class DirectionsDetails {
  late var distanceText;
  late var durationText;
  late var encodedPoints;
  late var durationValue;
  late var distanceValue;

  DirectionsDetails(
      {this.distanceText,
      this.distanceValue,
      this.durationText,
      this.durationValue,
      this.encodedPoints});
}

class DirectionDetails {
  late String distanceText;
  late String durationText;
  late int distanceValue;
  late int durationValue;
  late String encodedPoints;

  DirectionDetails({
    required this.distanceText,
    required this.durationText,
    required this.distanceValue,
    required this.durationValue,
    required this.encodedPoints,
  });
}
