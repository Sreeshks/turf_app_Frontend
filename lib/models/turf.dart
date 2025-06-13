class Turf {
  final String userId;
  final String turfId;
  final String name;
  final String turfLocation;
  final List<String> sports;

  Turf({
    required this.userId,
    required this.turfId,
    required this.name,
    required this.turfLocation,
    required this.sports,
  });

  factory Turf.fromJson(Map<String, dynamic> json) {
    return Turf(
      userId: json['userid'] ?? '',
      turfId: json['turfId'] ?? '',
      name: json['name'] ?? '',
      turfLocation: json['turfLocation'] ?? '',
      sports: List<String>.from(json['sports'] ?? []),
    );
  }
}
