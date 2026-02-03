class AppConstants {
  static const String appName = "QLM Mobile Suite";
  
  // API Config (To be updated for IDX)
  static const String baseUrl = "http://localhost:8000/api";
  
  // Endpoints
  static const String login = "/login";
  static const String syncPull = "/sync/pull";
  static const String syncPush = "/sync/push";
  static const String registryEntries = "/registry-entries";
  
  // Local DB Config
  static const String dbName = "qlm_suite_local.db";
  static const int dbVersion = 1;
}
