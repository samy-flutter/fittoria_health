import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../../clinics/data/models/clinic.dart';

/// Model for a doctor available at a clinic
class ClinicDoctor {
  final int id;
  final String fullName;
  final String? specialization;
  final double? consultationFee;

  ClinicDoctor({
    required this.id,
    required this.fullName,
    this.specialization,
    this.consultationFee,
  });

  factory ClinicDoctor.fromJson(Map<String, dynamic> json) {
    return ClinicDoctor(
      id: parseInt(json['id']) ?? 0,
      fullName: parseString(json['full_name']) ?? parseString(json['name']) ?? '',
      specialization: parseString(json['specialization']),
      consultationFee: parseDouble(json['consultation_fee']),
    );
  }
}

/// Result from a successful booking
class BookingResult {
  final int tokenNo;
  final int appointmentId;

  BookingResult({required this.tokenNo, required this.appointmentId});

  factory BookingResult.fromJson(Map<String, dynamic> json) {
    return BookingResult(
      tokenNo: json['token_no'] as int? ?? 0,
      appointmentId: json['id'] as int? ?? json['appointment_id'] as int? ?? 0,
    );
  }
}

abstract class BookingRemoteDataSource {
  Future<List<Clinic>> getClinics();
  Future<List<ClinicDoctor>> getDoctors(int clinicId);
  Future<BookingResult> bookAppointment(Map<String, dynamic> payload);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final DioClient _client;

  BookingRemoteDataSourceImpl(this._client);

  @override
  Future<List<Clinic>> getClinics() async {
    try {
      final response = await _client.get(ApiEndpoints.clinics);
      final list = response.data?['clinics'] as List? ?? response.data as List? ?? [];
      return list.map((item) => Clinic.fromJson(item)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<List<ClinicDoctor>> getDoctors(int clinicId) async {
    try {
      final response = await _client.get(ApiEndpoints.clinicDoctors(clinicId));
      final list = response.data?['doctors'] as List? ?? response.data as List? ?? [];
      return list.map((item) => ClinicDoctor.fromJson(item)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<BookingResult> bookAppointment(Map<String, dynamic> payload) async {
    try {
      final response = await _client.post(ApiEndpoints.appointments, data: payload);
      final data = response.data?['data'] ?? response.data;
      return BookingResult.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
