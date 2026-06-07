class MeetingsData {
  final List<CareMeeting> upcoming;
  final List<CareMeeting> past;
  final List<CareWebinar> webinars;

  MeetingsData({
    this.upcoming = const [],
    this.past = const [],
    this.webinars = const [],
  });

  factory MeetingsData.fromJson(Map<String, dynamic> json) {
    return MeetingsData(
      upcoming: (json['upcoming'] as List?)?.map((e) => CareMeeting.fromJson(e)).toList() ?? [],
      past: (json['past'] as List?)?.map((e) => CareMeeting.fromJson(e)).toList() ?? [],
      webinars: (json['webinars'] as List?)?.map((e) => CareWebinar.fromJson(e)).toList() ?? [],
    );
  }
}

class CareMeeting {
  final int id;
  final String title;
  final String mode;
  final String link;
  final String address;
  final String scheduledAt;
  final int durationMinutes;
  final String status;
  final String notes;
  final String staffName;
  final String staffRole;

  CareMeeting({
    required this.id,
    this.title = '',
    this.mode = '',
    this.link = '',
    this.address = '',
    this.scheduledAt = '',
    this.durationMinutes = 0,
    this.status = '',
    this.notes = '',
    this.staffName = '',
    this.staffRole = '',
  });

  factory CareMeeting.fromJson(Map<String, dynamic> json) {
    return CareMeeting(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      link: json['link'] as String? ?? '',
      address: json['address'] as String? ?? '',
      scheduledAt: json['scheduled_at'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      staffName: json['staff_name'] as String? ?? '',
      staffRole: json['staff_role'] as String? ?? '',
    );
  }
}

class CareWebinar {
  final int id;
  final String title;
  final String description;
  final String scheduledAt;
  final int durationMinutes;
  final String meetingUrl;
  final String status;
  final String hostName;

  CareWebinar({
    required this.id,
    this.title = '',
    this.description = '',
    this.scheduledAt = '',
    this.durationMinutes = 0,
    this.meetingUrl = '',
    this.status = '',
    this.hostName = '',
  });

  factory CareWebinar.fromJson(Map<String, dynamic> json) {
    return CareWebinar(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      scheduledAt: json['scheduled_at'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      meetingUrl: json['meeting_url'] as String? ?? '',
      status: json['status'] as String? ?? '',
      hostName: json['host_name'] as String? ?? '',
    );
  }
}
