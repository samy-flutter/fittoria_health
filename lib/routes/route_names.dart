class RouteNames {
  RouteNames._();

  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  
  static const String patientDashboard = '/patient';
  static const String patientFit = '/patient/fit';
  static const String patientCare = '/patient/care';
  static const String patientCommunity = '/patient/community';
  static const String patientMore = '/patient/more';

  static const String patientAppointments = '/patient/appointments';
  static const String patientBook = '/patient/book';
  static const String patientClinics = '/patient/clinics';
  static const String patientInvoices = '/patient/invoices';
  static const String patientLabReferrals = '/patient/lab-referrals';
  static const String patientLabReports = '/patient/lab-reports';
  static const String patientPrescriptions = '/patient/prescriptions';
  static const String patientProfile = '/patient/profile';
  static const String patientRecords = '/patient/records';
  static const String patientReports = '/patient/reports';
  // --- Interim Dashboard Phase Placeholder Routes ---
  static const String patientLabBooking = '/patient/lab-booking';
  static const String patientSocial = '/patient/social';
  static const String patientClubs = '/patient/clubs';
  static const String patientClubChat = '/patient/clubs/:id/chat';
  static const String patientEvents = '/patient/events';
  static const String patientEventDetails = '/patient/events/details';
  static const String patientChallenges = '/patient/fit/challenges';
  static const String patientAcademy = '/patient/academy';
  static const String patientAcademyDetails = '/patient/academy/video';
  static const String patientShop = '/patient/shop';
  static const String patientShopCart = '/patient/shop/cart';
  static const String patientShopCheckout = '/patient/shop/checkout';
  static const String patientShopOrders = '/patient/shop/orders';
  static const String patientShopOrderTracking = '/patient/shop/orders/:id';
  static const String patientShopAddresses = '/patient/shop/addresses';
  static const String patientShopAddressForm = '/patient/shop/address-form';
  static const String patientAchievements = '/patient/achievements';
  static const String patientOnboarding = '/patient/onboarding';
  static const String patientGym = '/patient/gym';
  static const String patientFitness = '/patient/fitness';
  static const String patientTrainers = '/patient/trainers';
  static const String patientNutrition = '/patient/nutrition';
  static const String patientAiNutrition = '/patient/ai-nutrition';
  static const String patientMeetings = '/patient/meetings';
  static const String patientFitLog = '/patient/fit/log';
  static const String patientFitActivity = '/patient/fit/activity';
  static const String patientFitGoals = '/patient/fit/goals';
  static const String patientFitHeartRate = '/patient/fit/heart-rate';
  static const String patientFitSleep = '/patient/fit/sleep';
  static const String patientFitWater = '/patient/fit/water';
  static const String patientFitNutrition = '/patient/fit/nutrition';
  static const String patientFitMood = '/patient/fit/mood';
  static const String patientFitWorkouts = '/patient/fit/workouts';
  static const String patientFitRecord = '/patient/fit/record';
  static const String patientFitPrograms = '/patient/fit/programs';
  static const String patientBodyProgress = '/patient/body-progress';
  static const String patientFitDevices = '/patient/fit/devices';

  // Convenience aliases (used by dashboard quick-action grid)
  static const String bookAppointment = patientBook;
  static const String clinics = patientClinics;
  static const String appointments = patientAppointments;
  static const String labs = patientLabReferrals;
  static const String invoices = patientInvoices;
  static const String records = patientRecords;

  // Details routes
  static String patientLabReferralDetails(int id) => '/patient/lab-referrals/$id';
  static String patientShopOrderTrackingDetails(int id) => '/patient/shop/orders/$id';
}
