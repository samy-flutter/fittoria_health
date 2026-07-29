class GymData {
  final GymMembership? activeMembership;
  final List<GymMembership> memberships;
  final List<GymAttendance> attendance;
  final List<GymClassBooking> upcomingClasses;
  final GymStats? stats;

  GymData({
    this.activeMembership,
    this.memberships = const [],
    this.attendance = const [],
    this.upcomingClasses = const [],
    this.stats,
  });

  factory GymData.fromJson(Map<String, dynamic> json) {
    return GymData(
      activeMembership: json['activeMembership'] != null ? GymMembership.fromJson(json['activeMembership']) : null,
      memberships: (json['memberships'] as List?)?.map((e) => GymMembership.fromJson(e)).toList() ?? [],
      attendance: (json['attendance'] as List?)?.map((e) => GymAttendance.fromJson(e)).toList() ?? [],
      upcomingClasses: (json['upcomingClasses'] as List?)?.map((e) => GymClassBooking.fromJson(e)).toList() ?? [],
      stats: json['stats'] != null ? GymStats.fromJson(json['stats']) : null,
    );
  }
}

class GymMembership {
  final int id;
  final String status;
  final String startDate;
  final String endDate;
  final String gymName;
  final String gymAddress;
  final String gymPhone;
  final String planName;
  final double price;
  final int durationMonths;
  final String trainerName;
  final String dietitianName;

  GymMembership({
    required this.id,
    this.status = '',
    this.startDate = '',
    this.endDate = '',
    this.gymName = '',
    this.gymAddress = '',
    this.gymPhone = '',
    this.planName = '',
    this.price = 0.0,
    this.durationMonths = 0,
    this.trainerName = '',
    this.dietitianName = '',
  });

  factory GymMembership.fromJson(Map<String, dynamic> json) {
    return GymMembership(
      id: json['id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      gymName: json['gym_name'] as String? ?? '',
      gymAddress: json['gym_address'] as String? ?? '',
      gymPhone: json['gym_phone'] as String? ?? '',
      planName: json['plan_name'] as String? ?? '',
      price: _parseDouble(json['price']),
      durationMonths: json['duration_months'] as int? ?? 0,
      trainerName: json['trainer_name'] as String? ?? '',
      dietitianName: json['dietitian_name'] as String? ?? '',
    );
  }
}

class GymAttendance {
  final int id;
  final String checkInAt;
  final String checkOutAt;
  final int durationMin;
  final String gymName;

  GymAttendance({
    required this.id,
    this.checkInAt = '',
    this.checkOutAt = '',
    this.durationMin = 0,
    this.gymName = '',
  });

  factory GymAttendance.fromJson(Map<String, dynamic> json) {
    return GymAttendance(
      id: json['id'] as int? ?? 0,
      checkInAt: json['check_in_at'] as String? ?? '',
      checkOutAt: json['check_out_at'] as String? ?? '',
      durationMin: json['duration_min'] as int? ?? 0,
      gymName: json['gym_name'] as String? ?? '',
    );
  }
}

class GymClassBooking {
  final int bookingId;
  final String bookingStatus;
  final String startAt;
  final String endAt;
  final String className;
  final String colorHex;
  final String trainerName;
  final String gymName;

  GymClassBooking({
    required this.bookingId,
    this.bookingStatus = '',
    this.startAt = '',
    this.endAt = '',
    this.className = '',
    this.colorHex = '',
    this.trainerName = '',
    this.gymName = '',
  });

  factory GymClassBooking.fromJson(Map<String, dynamic> json) {
    return GymClassBooking(
      bookingId: json['booking_id'] as int? ?? 0,
      bookingStatus: json['booking_status'] as String? ?? '',
      startAt: json['start_at'] as String? ?? '',
      endAt: json['end_at'] as String? ?? '',
      className: json['class_name'] as String? ?? '',
      colorHex: json['color_hex'] as String? ?? '',
      trainerName: json['trainer_name'] as String? ?? '',
      gymName: json['gym_name'] as String? ?? '',
    );
  }
}

class GymStats {
  final int totalVisits;
  final int thisMonth;

  GymStats({this.totalVisits = 0, this.thisMonth = 0});

  factory GymStats.fromJson(Map<String, dynamic> json) {
    return GymStats(
      totalVisits: json['totalVisits'] as int? ?? 0,
      thisMonth: json['thisMonth'] as int? ?? 0,
    );
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
