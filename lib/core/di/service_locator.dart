import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
// import '../services/database_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Network
  locator.registerLazySingleton(() => ApiClient());

  // Database (Initialized later)
  // locator.registerLazySingleton(() => DatabaseService());

  // Repositories & Services will be added here
}
