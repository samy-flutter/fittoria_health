class FitEvent {
  final int id;
  final String title;
  final String eventType;
  final String description;
  final String? bannerUrl;
  final String venue;
  final String city;
  final DateTime startAt;
  final double registrationFee;
  final double? distanceKm;
  final int registeredCount;
  final int capacity;
  final String status;
  final bool registered;
  final String? myStatus;

  FitEvent({
    required this.id,
    required this.title,
    required this.eventType,
    required this.description,
    this.bannerUrl,
    required this.venue,
    required this.city,
    required this.startAt,
    required this.registrationFee,
    this.distanceKm,
    required this.registeredCount,
    required this.capacity,
    required this.status,
    required this.registered,
    this.myStatus,
  });

  factory FitEvent.fromJson(Map<String, dynamic> json) {
    return FitEvent(
      id: json['id'] as int,
      title: json['title'] as String,
      eventType: json['event_type'] as String? ?? 'general',
      description: json['description'] as String? ?? '',
      bannerUrl: json['banner_url'] as String?,
      venue: json['venue'] as String? ?? 'TBA',
      city: json['city'] as String? ?? 'TBA',
      startAt: json['start_at'] != null ? DateTime.parse(json['start_at'] as String) : DateTime.now(),
      registrationFee: (json['registration_fee'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      registeredCount: json['registered_count'] as int? ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      status: json['status'] as String? ?? 'upcoming',
      registered: json['registered'] as bool? ?? false,
      myStatus: json['myStatus'] as String?,
    );
  }
}
