class ApiEndpoints {
  ApiEndpoints._();

  // static const String baseUrl = 'https://crm.fittoria.com'; // Change to correct API url if needed
  // Use 10.0.2.2 for Android Emulator, or your machine's IP (e.g. 192.168.1.x) for physical devices.
  static const String baseUrl = 'https://www.fittoria.in';

  // Auth endpoints
  static const String login = '/api/v2/auth/mobile/login';
  static const String mfa = '/api/v2/auth/mfa';
  static const String refresh = '/api/v2/auth/mobile/refresh';
  static const String logout = '/api/v2/auth/mobile/logout';
  static const String register = '/api/patient/register';

  // Patient endpoints
  static const String profile = '/api/patient/profile';
  static const String onboarding = '/api/patient/onboarding';
  static const String appointments = '/api/patient/appointments';
  static const String clinics = '/api/patient/clinics';
  static const String invoices = '/api/patient/invoices';
  static const String prescriptions = '/api/patient/prescriptions';
  static const String records = '/api/patient/records';
  static const String labReports = '/api/patient/lab-reports';
  static const String labReferrals = '/api/patient/lab-referrals';

  static String cancelAppointment(int id) => '/api/patient/appointments/$id';
  static String clinicDoctors(int clinicId) => '/api/patient/clinics/$clinicId/doctors';
  static String generateInvoicePdf(int id) => '/api/patient/invoices/$id/pdf';
  static String labReferralDetails(int id) => '/api/patient/lab-referrals/$id';
}
