import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile_records/domain/repositories/profile_repository.dart';
import '../../../appointments/domain/repositories/appointments_repository.dart';
import '../../../appointments/data/models/appointment.dart';
import '../../../invoices/domain/repositories/invoices_repository.dart';
import '../../../clinics/domain/repositories/clinics_repository.dart';
import '../../../../core/logging/app_logger.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ProfileRepository _profileRepository;
  final AppointmentsRepository _appointmentsRepository;
  final InvoicesRepository _invoicesRepository;
  final ClinicsRepository _clinicsRepository;

  DashboardCubit(
    this._profileRepository,
    this._appointmentsRepository,
    this._invoicesRepository,
    this._clinicsRepository,
  ) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    AppLogger.i('[Dashboard] Loading all dashboard data in parallel…');

    try {
      // Fetch all data sources in parallel
      final results = await Future.wait([
        _profileRepository.getProfile(),
        _appointmentsRepository.getAppointments(),
        _invoicesRepository.getInvoices(),
        _clinicsRepository.searchClinics(),
      ]);

      final profileResponse = results[0] as dynamic;
      final appointments = results[1] as List<Appointment>;
      final invoices = results[2] as dynamic;
      final clinics = results[3] as dynamic;

      final profile = profileResponse.patient;
      final invoiceList = invoices as List;
      final clinicList = clinics as List;

      AppLogger.s('[Dashboard] Fetched: ${appointments.length} appointments, '
          '${invoiceList.length} invoices, ${clinicList.length} clinics');

      // Upcoming appointments (scheduled/waiting/in_consultation)
      final upcoming = appointments
          .where((a) =>
              ['scheduled', 'waiting', 'in_consultation'].contains(a.status))
          .toList()
        ..sort((a, b) {
          final aDate =
              DateTime.tryParse('${a.appointmentDate}T${a.slotStart}');
          final bDate =
              DateTime.tryParse('${b.appointmentDate}T${b.slotStart}');
          if (aDate == null || bDate == null) return 0;
          return aDate.compareTo(bDate);
        });

      // Recent visits (last 3 completed)
      final recentVisits = appointments
          .where((a) => a.status == 'completed')
          .take(3)
          .toList();

      // Pending invoices
      final pendingCount = invoiceList
          .where((i) => i.paymentStatus == 'pending')
          .length;

      // Compute BMI
      double? bmiValue;
      String? bmiClass;
      final double? weight = profile.weightKg;
      final double? height = profile.heightCm;

      if (weight != null && height != null && height > 0) {
        final heightM = height / 100.0;
        bmiValue = weight / (heightM * heightM);
        if (bmiValue < 18.5) {
          bmiClass = 'Underweight';
        } else if (bmiValue < 25.0) {
          bmiClass = 'Normal';
        } else if (bmiValue < 30.0) {
          bmiClass = 'Overweight';
        } else {
          bmiClass = 'Obese';
        }
      }

      emit(DashboardLoaded(
        profile: profile,
        appointments: appointments,
        nextAppointment: upcoming.isNotEmpty ? upcoming.first : null,
        bmi: bmiValue,
        bmiClassification: bmiClass,
        invoices: invoiceList.cast(),
        clinics: clinicList.cast(),
        pendingInvoiceCount: pendingCount,
        recentVisits: recentVisits,
      ));

      AppLogger.s('[Dashboard] State emitted: DashboardLoaded');
    } catch (e, stack) {
      AppLogger.e('[Dashboard] Load failed', e);
      AppLogger.d('[Dashboard] Stack', stack);
      emit(DashboardError(e.toString()));
    }
  }
}
