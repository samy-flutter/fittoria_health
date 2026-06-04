import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/appointment.dart';

abstract class AppointmentsRemoteDataSource {
  Future<List<Appointment>> getAppointments();
  Future<void> cancelAppointment(int appointmentId);
}

class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  final DioClient _client;

  AppointmentsRemoteDataSourceImpl(this._client);

  @override
  Future<List<Appointment>> getAppointments() async {
    try {
      final response = await _client.get(ApiEndpoints.appointments);
      final list = response.data?['appointments'] as List?;
      if (list != null) {
        return list.map((item) => Appointment.fromJson(item)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> cancelAppointment(int appointmentId) async {
    try {
      await _client.delete('${ApiEndpoints.appointments}/$appointmentId');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
