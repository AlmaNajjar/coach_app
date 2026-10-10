class ApiConstants {
  static const String baseUrl = "https://technogymtest.iss-group.me/api/";
  //"https://technogym.iss-group.me/api/"
  // API Endpoints
  static const String login = "v1/auth/login";
  static const String logout = "v1/auth/logout";
  static const String profile = "v1/auth/me";
  static const String changePassword = "v1/auth/change-password";
  static const String changePhoto = "v1/auth/change-photo";
  static String updateMember(int id) => "v1/members/$id";
  static const String dashboard = "v1/member/dashboard";
  static const String myInvoices = "v1/my-invoices";
  static const String coaches = "v1/coaches";
  static const String coachPrivateSubscriptions =
      "v1/coaches/private-subscriptions";
  static const String activityTypes = "v1/activity-types";
  static const String packages = "v1/subscription-plans";
  static String coachShifts(int coachId) => "v1/coaches/$coachId/shifts";

  // Offers Endpoints
  static const String offers = "v1/offers";
  static String offerDetails(int id) => "v1/offers/$id";
  static String subscribeToOffer(int id) => "v1/offers/$id/subscribe";

  // Notifications Endpoints
  static const String notifications = "v1/notifications";
  static const String unreadNotificationsCount =
      "v1/notifications/unread/count";
  static String notificationDetails(int receptionId) =>
      "v1/notifications/$receptionId";
  static String deleteNotification(int receptionId) =>
      "v1/notifications/$receptionId";
  static String markNotificationAsRead(int receptionId) =>
      "v1/notifications/$receptionId/read";
  static const String markAllNotificationsAsRead =
      "v1/notifications/mark-all-as-read";

  // Attendance Endpoints
  static const String attendanceHistory = "v1/attendances/history";

  // Session Schedule & Live Stream Endpoints
  static const String sessionTemplatesSchedule =
      "v1/session-templates/schedule";
  static const String dashboardStatsStream =
      "v1/attendance-manager/dashboard-stats-stream";
  // Holidays Endpoints
  static String holidays(int branchId) => "v1/branches/$branchId/holidays";

  // App Version Endpoint
  static const String checkVersion = "v1/app/check-version";

  // Branch Contact Info Endpoint
  static const String branchContactInfo = "v1/branches/contact-info";

}
