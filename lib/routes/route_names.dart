class RouteNames {
  RouteNames._();

  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  
  static const String patientDashboard = '/patient';
  static const String patientAppointments = '/patient/appointments';
  static const String patientBook = '/patient/book';
  static const String patientClinics = '/patient/clinics';
  static const String patientInvoices = '/patient/invoices';
  static const String patientLabReferrals = '/patient/lab-referrals';
  static const String patientLabReports = '/patient/lab-reports';
  static const String patientPrescriptions = '/patient/prescriptions';
  static const String patientProfile = '/patient/profile';
  static const String patientRecords = '/patient/records';

  // Convenience aliases (used by dashboard quick-action grid)
  static const String bookAppointment = patientBook;
  static const String clinics = patientClinics;
  static const String appointments = patientAppointments;
  static const String labs = patientLabReferrals;
  static const String invoices = patientInvoices;
  static const String records = patientRecords;

  // Details routes
  static String patientLabReferralDetails(int id) => '/patient/lab-referrals/$id';
}
